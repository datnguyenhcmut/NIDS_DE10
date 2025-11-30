#!/usr/bin/env python3
"""
Generate memory initialization files (.mem and .mif) for FPGA
Loads test vectors into Block RAM for hardware testing
"""

import json
from pathlib import Path


def to_hex_string(value, width=32):
    """Convert signed integer to hex string"""
    if value < 0:
        value = (1 << width) + value
    return f"{value:08X}"


def generate_mem_file(golden_path, output_path, num_tests=10):
    """Generate .mem file (simple hex format)"""
    
    with open(golden_path, 'r') as f:
        golden = json.load(f)
    
    test_cases = golden['test_cases'][:num_tests]
    n_features = golden['config']['n_features']
    
    mem_lines = []
    mem_lines.append(f"// NIDS Test Vectors - {num_tests} tests x {n_features} features")
    mem_lines.append(f"// Format: 32-bit hex values (Q24.8 fixed-point)")
    mem_lines.append("")
    
    for test_idx, test in enumerate(test_cases):
        mem_lines.append(f"// Test {test_idx}: {test['name']} (Expected: Attack={test['expected_attack']})")
        
        features = test['features_fp']
        for feat_val in features:
            hex_val = to_hex_string(feat_val)
            mem_lines.append(hex_val)
        
        mem_lines.append("")
    
    with open(output_path, 'w') as f:
        f.write('\n'.join(mem_lines))
    
    print(f"✓ Generated .mem file: {output_path}")
    print(f"  Tests: {num_tests}, Features per test: {n_features}")
    print(f"  Total memory words: {num_tests * n_features}")


def generate_mif_file(golden_path, output_path, num_tests=10):
    """Generate .mif file (Altera/Intel format)"""
    
    with open(golden_path, 'r') as f:
        golden = json.load(f)
    
    test_cases = golden['test_cases'][:num_tests]
    n_features = golden['config']['n_features']
    
    mif_lines = []
    mif_lines.append("-- NIDS Test Vectors Memory Initialization File")
    mif_lines.append("-- Format: Altera .mif for Block RAM initialization")
    mif_lines.append("")
    mif_lines.append(f"DEPTH = {num_tests * n_features};  -- Number of memory words")
    mif_lines.append("WIDTH = 32;                          -- Bits per word")
    mif_lines.append("ADDRESS_RADIX = DEC;                 -- Address in decimal")
    mif_lines.append("DATA_RADIX = HEX;                    -- Data in hex")
    mif_lines.append("")
    mif_lines.append("CONTENT BEGIN")
    
    addr = 0
    for test_idx, test in enumerate(test_cases):
        mif_lines.append(f"    -- Test {test_idx}: {test['name']}")
        
        features = test['features_fp']
        for feat_val in features:
            hex_val = to_hex_string(feat_val)
            mif_lines.append(f"    {addr:4d} : {hex_val};")
            addr += 1
    
    mif_lines.append("END;")
    
    with open(output_path, 'w') as f:
        f.write('\n'.join(mif_lines))
    
    print(f"✓ Generated .mif file: {output_path}")


def generate_test_info(golden_path, output_path, num_tests=10):
    """Generate test information CSV for reference"""
    
    with open(golden_path, 'r') as f:
        golden = json.load(f)
    
    test_cases = golden['test_cases'][:num_tests]
    
    csv_lines = []
    csv_lines.append("Test_ID,Name,Expected_Attack,Major_Score,Minor_Score,Memory_Start_Addr")
    
    for test in test_cases:
        addr = test['test_id'] * 28  # 28 features per test
        csv_lines.append(f"{test['test_id']},{test['name']},{test['expected_attack']},"
                        f"{test['major_score']},{test['minor_score']},{addr}")
    
    with open(output_path, 'w') as f:
        f.write('\n'.join(csv_lines))
    
    print(f"✓ Generated test info: {output_path}")


if __name__ == '__main__':
    base_dir = Path(__file__).parent.parent
    golden_path = base_dir / 'model' / 'diverse_test_golden.json'
    
    mem_path = base_dir / 'quartus_project' / 'test_vectors.mem'
    mif_path = base_dir / 'quartus_project' / 'test_vectors.mif'
    info_path = base_dir / 'quartus_project' / 'test_info.csv'
    
    print("="*70)
    print("  Generating Memory Initialization Files for FPGA")
    print("="*70)
    print()
    
    # Generate memory files
    generate_mem_file(golden_path, mem_path, num_tests=10)
    print()
    generate_mif_file(golden_path, mif_path, num_tests=10)
    print()
    generate_test_info(golden_path, info_path, num_tests=10)
    
    print()
    print("="*70)
    print("✓ Memory files ready for Quartus synthesis")
    print()
    print("Usage in Quartus:")
    print("  1. Add test_vectors.mif to project")
    print("  2. In IP Catalog, create ROM/RAM with .mif initialization")
    print("  3. Or use $readmemh(\"test_vectors.mem\", memory_array) in RTL")
    print("="*70)
