#!/usr/bin/env python3
"""
Compare Verilog simulation results with Python golden reference
Verifies hardware implementation correctness
"""

import json
import re
from pathlib import Path
from typing import List, Dict, Tuple


def load_golden_reference(json_path: str) -> Dict:
    """Load golden reference from JSON file"""
    with open(json_path, 'r') as f:
        golden = json.load(f)
    return golden


def parse_simulation_log(log_path: str) -> List[Dict]:
    """Parse simulation log file to extract results"""
    results = []
    
    with open(log_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Try different patterns
    # Pattern 1: From new testbench with golden reference
    # Test N: PASS/FAIL followed by Got values
    test_blocks = re.findall(r'Test (\d+): (PASS|FAIL)\n(?:  Attack: Got=(\d+).*\n  Major:  Got=\s*(-?\d+).*\n  Minor:  Got=\s*(-?\d+))?', content)
    
    for match in test_blocks:
        test_id = int(match[0])
        status = match[1]
        
        if status == 'PASS':
            # For PASS, need to get values from display message
            pass_pattern = rf'Test {test_id}: PASS - attack=(\d+), major=\s*(\d+), minor=\s*(\d+)'
            pass_match = re.search(pass_pattern, content)
            if pass_match:
                attack = int(pass_match.group(1))
                major = int(pass_match.group(2))
                minor = int(pass_match.group(3))
                results.append({
                    'test_id': test_id,
                    'attack_detected': attack,
                    'major_score': major,
                    'minor_score': minor
                })
        else:  # FAIL
            if match[2]:  # Has Got values
                attack = int(match[2])
                major = int(match[3])
                minor = int(match[4])
                results.append({
                    'test_id': test_id,
                    'attack_detected': attack,
                    'major_score': major,
                    'minor_score': minor
                })
    
    # If no results, try old patterns
    if not results:
        # Pattern 2: Old format - Expected attack=X, Got attack=Y, Major=Z, Minor=W
        pattern2 = r'Test\s+(\d+):\s+Expected.*Got attack=(\d+),\s+Major=\s*(\d+),\s+Minor=\s*(\d+)'
        matches2 = re.findall(pattern2, content)
        
        for match in matches2:
            test_id = int(match[0])
            attack = int(match[1])
            major = int(match[2])
            minor = int(match[3])
            
            results.append({
                'test_id': test_id,
                'attack_detected': attack,
                'major_score': major,
                'minor_score': minor
            })
    
    return results


def compare_results(sim_results: List[Dict], golden_ref: Dict, tolerance: int = 10) -> Tuple[int, int, List[Dict]]:
    """
    Compare simulation results with golden reference
    
    Args:
        sim_results: List of simulation results
        golden_ref: Golden reference dictionary
        tolerance: Tolerance for score comparison (in fixed-point units)
    
    Returns:
        (pass_count, fail_count, mismatches)
    """
    golden_results = golden_ref['results']
    pass_count = 0
    fail_count = 0
    mismatches = []
    
    for sim in sim_results:
        test_id = sim['test_id'] - 1  # Convert to 0-indexed
        
        if test_id >= len(golden_results):
            print(f"Warning: Test {sim['test_id']} not found in golden reference")
            continue
        
        golden = golden_results[test_id]
        
        # Compare results
        attack_match = (sim['attack_detected'] == golden['attack_detected'])
        
        major_diff = abs(sim['major_score'] - golden['major_score_fixed'])
        minor_diff = abs(sim['minor_score'] - golden['minor_score_fixed'])
        
        major_match = (major_diff <= tolerance)
        minor_match = (minor_diff <= tolerance)
        
        if attack_match and major_match and minor_match:
            pass_count += 1
        else:
            fail_count += 1
            mismatches.append({
                'test_id': sim['test_id'],
                'attack_match': attack_match,
                'major_match': major_match,
                'minor_match': minor_match,
                'sim_attack': sim['attack_detected'],
                'golden_attack': golden['attack_detected'],
                'sim_major': sim['major_score'],
                'golden_major': golden['major_score_fixed'],
                'major_diff': major_diff,
                'sim_minor': sim['minor_score'],
                'golden_minor': golden['minor_score_fixed'],
                'minor_diff': minor_diff
            })
    
    return pass_count, fail_count, mismatches


def generate_comparison_report(sim_results: List[Dict], golden_ref: Dict, 
                               output_path: str, tolerance: int = 10):
    """Generate detailed comparison report"""
    
    pass_count, fail_count, mismatches = compare_results(sim_results, golden_ref, tolerance)
    total = pass_count + fail_count
    
    print("\n" + "="*70)
    print("VERIFICATION REPORT")
    print("="*70)
    print(f"\nTotal Tests:  {total}")
    print(f"Passed:       {pass_count} ({100*pass_count/total:.1f}%)")
    print(f"Failed:       {fail_count} ({100*fail_count/total:.1f}%)")
    print(f"Tolerance:    ±{tolerance} (fixed-point units)")
    
    # Write detailed report
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write("="*70 + "\n")
        f.write("VERILOG vs PYTHON GOLDEN REFERENCE COMPARISON\n")
        f.write("="*70 + "\n\n")
        
        f.write(f"Total Tests:  {total}\n")
        f.write(f"Passed:       {pass_count} ({100*pass_count/total:.1f}%)\n")
        f.write(f"Failed:       {fail_count} ({100*fail_count/total:.1f}%)\n")
        f.write(f"Tolerance:    ±{tolerance} (fixed-point units)\n\n")
        
        if fail_count == 0:
            f.write("\n✓ ALL TESTS PASSED!\n\n")
            print("\n✓ ALL TESTS PASSED!")
        else:
            f.write("\n✗ MISMATCHES FOUND:\n")
            f.write("="*70 + "\n\n")
            
            print(f"\n✗ Found {fail_count} mismatches:")
            print("-"*70)
            
            for mm in mismatches[:10]:  # Show first 10 mismatches
                f.write(f"Test {mm['test_id']}:\n")
                f.write(f"  Attack Detection: {'✓' if mm['attack_match'] else '✗'}\n")
                f.write(f"    Sim:    {mm['sim_attack']}\n")
                f.write(f"    Golden: {mm['golden_attack']}\n")
                f.write(f"  Major Score: {'✓' if mm['major_match'] else '✗'}\n")
                f.write(f"    Sim:    {mm['sim_major']:10d}\n")
                f.write(f"    Golden: {mm['golden_major']:10d}\n")
                f.write(f"    Diff:   {mm['major_diff']:10d}\n")
                f.write(f"  Minor Score: {'✓' if mm['minor_match'] else '✗'}\n")
                f.write(f"    Sim:    {mm['sim_minor']:10d}\n")
                f.write(f"    Golden: {mm['golden_minor']:10d}\n")
                f.write(f"    Diff:   {mm['minor_diff']:10d}\n")
                f.write("\n")
                
                print(f"  Test {mm['test_id']}: "
                      f"Attack={'✓' if mm['attack_match'] else '✗'} "
                      f"Major={'✓' if mm['major_match'] else '✗'}(diff={mm['major_diff']}) "
                      f"Minor={'✓' if mm['minor_match'] else '✗'}(diff={mm['minor_diff']})")
            
            if len(mismatches) > 10:
                f.write(f"... and {len(mismatches) - 10} more mismatches\n")
                print(f"  ... and {len(mismatches) - 10} more mismatches")
        
        # Summary statistics
        f.write("\n" + "="*70 + "\n")
        f.write("DETAILED RESULTS\n")
        f.write("="*70 + "\n\n")
        f.write(f"{'Test':<8} {'Attack':<10} {'Major Score':<25} {'Minor Score':<25} {'Status':<10}\n")
        f.write(f"{'ID':<8} {'S/G':<10} {'Sim / Golden (Diff)':<25} {'Sim / Golden (Diff)':<25} {'':<10}\n")
        f.write("-"*70 + "\n")
        
        golden_results = golden_ref['results']
        for sim in sim_results[:50]:  # First 50 tests
            test_id = sim['test_id'] - 1
            if test_id >= len(golden_results):
                continue
                
            golden = golden_results[test_id]
            major_diff = abs(sim['major_score'] - golden['major_score_fixed'])
            minor_diff = abs(sim['minor_score'] - golden['minor_score_fixed'])
            
            attack_str = f"{sim['attack_detected']}/{golden['attack_detected']}"
            major_str = f"{sim['major_score']}/{golden['major_score_fixed']}({major_diff})"
            minor_str = f"{sim['minor_score']}/{golden['minor_score_fixed']}({minor_diff})"
            
            status = "PASS" if (sim['attack_detected'] == golden['attack_detected'] and 
                               major_diff <= tolerance and minor_diff <= tolerance) else "FAIL"
            
            f.write(f"{sim['test_id']:<8} {attack_str:<10} {major_str:<25} {minor_str:<25} {status:<10}\n")
    
    print(f"\nDetailed report saved to: {output_path}")
    print("="*70 + "\n")
    
    return pass_count, fail_count


def main():
    # Paths
    base_dir = Path(__file__).parent.parent
    golden_path = base_dir / "model" / "golden_reference.json"
    
    # Try both possible log locations
    sim_log_path1 = base_dir / "output" / "logs" / "sim_report.txt"
    sim_log_path2 = base_dir / "logs" / "sim_report.txt"
    
    if sim_log_path1.exists():
        sim_log_path = sim_log_path1
    elif sim_log_path2.exists():
        sim_log_path = sim_log_path2
    else:
        sim_log_path = sim_log_path1  # Use default for error message
    
    comparison_report_path = base_dir / "output" / "logs" / "comparison_report.txt"
    
    # Check if files exist
    if not golden_path.exists():
        print(f"Error: Golden reference not found: {golden_path}")
        print("Run 'make golden' first to generate golden reference")
        return 1
    
    if not sim_log_path.exists():
        print(f"Error: Simulation log not found: {sim_log_path}")
        print("Run 'make' first to generate simulation results")
        return 1
    
    # Load golden reference
    print(f"Loading golden reference from {golden_path}...")
    golden_ref = load_golden_reference(str(golden_path))
    print(f"  Loaded {golden_ref['num_samples']} golden samples")
    
    # Parse simulation log
    print(f"\nParsing simulation log from {sim_log_path}...")
    sim_results = parse_simulation_log(str(sim_log_path))
    print(f"  Found {len(sim_results)} simulation results")
    
    if len(sim_results) == 0:
        print("\nError: No simulation results found in log file")
        return 1
    
    # Compare and generate report
    print("\nComparing results...")
    pass_count, fail_count = generate_comparison_report(
        sim_results, 
        golden_ref, 
        str(comparison_report_path),
        tolerance=10
    )
    
    # Return exit code
    return 0 if fail_count == 0 else 1


if __name__ == "__main__":
    exit(main())
