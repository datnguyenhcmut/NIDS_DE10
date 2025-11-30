#!/usr/bin/env python3
"""
Generate comparison report between Python golden reference and Verilog simulation
Validates that hardware matches software implementation
"""

import json
import subprocess
from pathlib import Path
from datetime import datetime


def run_simulation(test_indices, base_dir):
    """
    Run ModelSim simulation and extract results for specific tests
    """
    print("Running ModelSim simulation...")
    
    # Run simulation
    cmd = [
        'vsim', '-c', 
        '-do', 'run -all; quit',
        'work.tb_diverse'
    ]
    
    result = subprocess.run(
        cmd, 
        capture_output=True, 
        text=True,
        cwd=str(base_dir)
    )
    
    # Parse simulation output
    sim_results = {}
    for line in result.stdout.split('\n'):
        if '[PASS]' in line or '[FAIL]' in line:
            # Parse: [PASS] Test  0: All zeros | Attack=0 | Major=174 | Minor=0
            parts = line.split('|')
            if len(parts) >= 3:
                # Extract test number
                test_part = line.split(':')[0]
                test_num = int(''.join(filter(str.isdigit, test_part.split('Test')[1])))
                
                # Extract values
                attack = int(parts[1].split('=')[1].strip())
                major = int(parts[2].split('=')[1].strip())
                minor = int(parts[3].split('=')[1].strip()) if len(parts) > 3 else 0
                
                sim_results[test_num] = {
                    'attack': attack,
                    'major': major,
                    'minor': minor
                }
    
    return sim_results


def generate_report(golden_data, sim_results, output_path, selected_tests):
    """
    Generate detailed comparison report
    """
    
    test_cases = golden_data['test_cases']
    config = golden_data['config']
    
    report = []
    report.append("="*80)
    report.append("  PCA-BASED NIDS VERIFICATION REPORT")
    report.append("  Python Golden Reference vs Verilog Hardware Implementation")
    report.append("="*80)
    report.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    report.append(f"Configuration:")
    report.append(f"  - Features: {config['n_features']}")
    report.append(f"  - Major Components: {config['n_major_components']}")
    report.append(f"  - Minor Components: {config['n_minor_components']}")
    report.append(f"  - Data Width: {config['total_bits']} bits")
    report.append(f"  - Fractional Bits: {config['frac_bits']} bits (Q24.8 format)")
    report.append(f"  - Threshold: 100 << {config['frac_bits']} = {100 << config['frac_bits']}")
    report.append("="*80)
    report.append("")
    
    # Summary statistics
    total_tests = len(selected_tests)
    matches = 0
    
    for test_idx in selected_tests:
        if test_idx in sim_results:
            golden = test_cases[test_idx]
            sim = sim_results[test_idx]
            
            # Check if results match
            attack_match = (golden['actual_attack'] == sim['attack'])
            major_match = (golden['major_score'] == sim['major'])
            minor_match = (golden['minor_score'] == sim['minor'])
            
            if attack_match and major_match and minor_match:
                matches += 1
    
    report.append("SUMMARY")
    report.append("-"*80)
    report.append(f"Total Tests: {total_tests}")
    report.append(f"Matches: {matches}")
    report.append(f"Mismatches: {total_tests - matches}")
    report.append(f"Accuracy: {100.0 * matches / total_tests:.1f}%")
    report.append("")
    report.append("="*80)
    report.append("")
    
    # Detailed comparison for selected tests
    report.append("DETAILED TEST COMPARISON")
    report.append("="*80)
    
    for test_idx in selected_tests:
        if test_idx not in sim_results:
            continue
            
        golden = test_cases[test_idx]
        sim = sim_results[test_idx]
        
        report.append("")
        report.append(f"Test {test_idx}: {golden['name']}")
        report.append("-"*80)
        
        # Show first 5 features as sample
        report.append("Sample Input Features (first 5 of 28):")
        for i in range(min(5, len(golden['features_fp']))):
            feat_fp = golden['features_fp'][i]
            feat_float = feat_fp / (1 << config['frac_bits'])
            report.append(f"  Feature[{i:2d}] = {feat_fp:12d} (0x{feat_fp & 0xFFFFFFFF:08X}) = {feat_float:12.4f}")
        report.append(f"  ... (23 more features)")
        report.append("")
        
        # Attack detection
        attack_match = "✓ MATCH" if golden['actual_attack'] == sim['attack'] else "✗ MISMATCH"
        report.append(f"Attack Detection: {attack_match}")
        report.append(f"  Python:  {golden['actual_attack']}")
        report.append(f"  Verilog: {sim['attack']}")
        report.append("")
        
        # Major score
        major_diff = abs(golden['major_score'] - sim['major'])
        major_match = "✓ MATCH" if major_diff == 0 else f"✗ DIFF={major_diff}"
        major_float_py = golden['major_score'] / (1 << config['frac_bits'])
        major_float_hw = sim['major'] / (1 << config['frac_bits'])
        
        report.append(f"Major Score: {major_match}")
        report.append(f"  Python:  {golden['major_score']:12d} (0x{golden['major_score'] & 0xFFFFFFFF:08X}) = {major_float_py:12.2f}")
        report.append(f"  Verilog: {sim['major']:12d} (0x{sim['major'] & 0xFFFFFFFF:08X}) = {major_float_hw:12.2f}")
        report.append("")
        
        # Minor score
        minor_diff = abs(golden['minor_score'] - sim['minor'])
        minor_match = "✓ MATCH" if minor_diff == 0 else f"✗ DIFF={minor_diff}"
        minor_float_py = golden['minor_score'] / (1 << config['frac_bits'])
        minor_float_hw = sim['minor'] / (1 << config['frac_bits'])
        
        report.append(f"Minor Score: {minor_match}")
        report.append(f"  Python:  {golden['minor_score']:12d} (0x{golden['minor_score'] & 0xFFFFFFFF:08X}) = {minor_float_py:12.2f}")
        report.append(f"  Verilog: {sim['minor']:12d} (0x{sim['minor'] & 0xFFFFFFFF:08X}) = {minor_float_hw:12.2f}")
        report.append("")
        
        # Overall result
        if attack_match == "✓ MATCH" and major_match == "✓ MATCH" and minor_match == "✓ MATCH":
            report.append(">>> RESULT: ✓✓✓ PERFECT MATCH ✓✓✓")
        else:
            report.append(">>> RESULT: ✗✗✗ MISMATCH ✗✗✗")
        report.append("")
    
    report.append("="*80)
    report.append("END OF REPORT")
    report.append("="*80)
    
    # Write to file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(report))
    
    return matches, total_tests


def main():
    base_dir = Path(__file__).parent.parent
    golden_path = base_dir / 'model' / 'diverse_test_golden.json'
    output_path = base_dir / 'output' / 'logs' / 'verification_report.txt'
    
    # Check ALL test cases for comprehensive verification
    # Load golden to determine total test count
    with open(golden_path, 'r') as f:
        golden_data_temp = json.load(f)
    n_tests = len(golden_data_temp['test_cases'])
    selected_tests = list(range(n_tests))  # All tests
    
    print("="*80)
    print("  PCA NIDS Verification Report Generator")
    print("="*80)
    print()
    
    # Load golden reference
    print(f"Loading golden reference from {golden_path}...")
    with open(golden_path, 'r') as f:
        golden_data = json.load(f)
    print(f"✓ Loaded {len(golden_data['test_cases'])} test cases")
    print()
    
    # Run simulation
    sim_results = run_simulation(selected_tests, base_dir)
    print(f"✓ Simulation completed, {len(sim_results)} results extracted")
    print()
    
    # Generate report
    print(f"Generating comparison report...")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    matches, total = generate_report(golden_data, sim_results, output_path, selected_tests)
    
    print()
    print("="*80)
    print(f"✓ Report saved to: {output_path}")
    print(f"  Match Rate: {matches}/{total} ({100.0*matches/total:.1f}%)")
    print("="*80)
    
    if matches == total:
        print()
        print("🎉 ALL TESTS MATCH! Hardware ready for FPGA deployment!")
        return 0
    else:
        print()
        print("⚠️  Some mismatches detected. Review report for details.")
        return 1


if __name__ == '__main__':
    exit(main())
