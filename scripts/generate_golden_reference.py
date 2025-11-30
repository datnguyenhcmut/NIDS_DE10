#!/usr/bin/env python3
"""
Generate Golden Reference for PCA-based NIDS
Reads dataset and PCA model, outputs expected results for hardware verification
"""

import numpy as np
import json
import csv
from pathlib import Path


def fixed_point_convert(value, frac_bits=8):
    """Convert floating point to fixed-point integer"""
    return int(round(value * (1 << frac_bits)))


def fixed_point_to_float(value, frac_bits=8):
    """Convert fixed-point integer back to float"""
    return value / (1 << frac_bits)


def load_pca_model(json_path):
    """Load PCA coefficients from JSON"""
    with open(json_path, 'r') as f:
        model = json.load(f)
    return model


def load_dataset(csv_path, max_samples=200):
    """Load KDD Cup dataset"""
    samples = []
    with open(csv_path, 'r') as f:
        reader = csv.reader(f)
        for i, row in enumerate(reader):
            if i >= max_samples:
                break
            if len(row) > 0:
                samples.append(row)
    return samples


def preprocess_kdd_sample(sample):
    """
    Preprocess KDD Cup sample to extract numeric features
    KDD Cup has 41 features, we select 28 numeric ones
    """
    # Feature indices to extract (adjust based on your feature selection)
    # This is a simplified version - adjust based on your actual preprocessing
    numeric_features = []
    
    try:
        # Duration
        numeric_features.append(float(sample[0]))
        
        # Protocol type (encoded: tcp=0, udp=1, icmp=2)
        protocol_map = {'tcp': 0, 'udp': 1, 'icmp': 2}
        numeric_features.append(protocol_map.get(sample[1], 0))
        
        # Service (simplified - use hash or encoding)
        numeric_features.append(hash(sample[2]) % 256)
        
        # Flag (simplified)
        numeric_features.append(hash(sample[3]) % 256)
        
        # src_bytes
        numeric_features.append(float(sample[4]))
        
        # dst_bytes
        numeric_features.append(float(sample[5]))
        
        # land
        numeric_features.append(float(sample[6]))
        
        # wrong_fragment
        numeric_features.append(float(sample[7]))
        
        # urgent
        numeric_features.append(float(sample[8]))
        
        # hot
        numeric_features.append(float(sample[9]))
        
        # num_failed_logins
        numeric_features.append(float(sample[10]))
        
        # logged_in
        numeric_features.append(float(sample[11]))
        
        # num_compromised
        numeric_features.append(float(sample[12]))
        
        # root_shell
        numeric_features.append(float(sample[13]))
        
        # su_attempted
        numeric_features.append(float(sample[14]))
        
        # num_root
        numeric_features.append(float(sample[15]))
        
        # num_file_creations
        numeric_features.append(float(sample[16]))
        
        # num_shells
        numeric_features.append(float(sample[17]))
        
        # num_access_files
        numeric_features.append(float(sample[18]))
        
        # num_outbound_cmds
        numeric_features.append(float(sample[19]))
        
        # is_host_login
        numeric_features.append(float(sample[20]))
        
        # is_guest_login
        numeric_features.append(float(sample[21]))
        
        # count
        numeric_features.append(float(sample[22]))
        
        # srv_count
        numeric_features.append(float(sample[23]))
        
        # serror_rate
        numeric_features.append(float(sample[24]))
        
        # srv_serror_rate
        numeric_features.append(float(sample[25]))
        
        # rerror_rate
        numeric_features.append(float(sample[26]))
        
        # srv_rerror_rate
        numeric_features.append(float(sample[27]))
        
        # Pad or truncate to 28 features
        while len(numeric_features) < 28:
            numeric_features.append(0.0)
        numeric_features = numeric_features[:28]
        
    except (ValueError, IndexError) as e:
        print(f"Warning: Error processing sample: {e}")
        numeric_features = [0.0] * 28
    
    return np.array(numeric_features)


def pca_detection_float(features, model):
    """
    PCA-based anomaly detection using floating point (golden reference)
    """
    mean = np.array(model['mean'])
    major_comp = np.array(model['major_components'])  # Shape: (Q, N_FEATURES)
    minor_comp = np.array(model['minor_components'])  # Shape: (R, N_FEATURES)
    
    # Center the data
    centered = features - mean
    
    # Project onto major components
    major_proj = major_comp @ centered  # Shape: (Q,)
    
    # Project onto minor components
    minor_proj = minor_comp @ centered  # Shape: (R,)
    
    # Reconstruct from major components
    major_recon = major_comp.T @ major_proj  # Shape: (N_FEATURES,)
    
    # Compute scores
    # Major score: Squared Prediction Error (SPE) in major subspace
    residual = centered - major_recon
    major_score = np.sum(residual ** 2)
    
    # Minor score: Score in minor subspace
    minor_score = np.sum(minor_proj ** 2)
    
    return major_score, minor_score, major_proj, minor_proj


def pca_detection_fixed(features_fixed, model, frac_bits=8):
    """
    PCA-based anomaly detection using fixed-point arithmetic (matches hardware)
    Uses int64 to avoid overflow, then truncates to int32 for final results
    """
    mean_fixed = np.array(model['mean_fixed'], dtype=np.int64)
    major_comp_fixed = np.array(model['major_components_fixed'], dtype=np.int64)
    minor_comp_fixed = np.array(model['minor_components_fixed'], dtype=np.int64)
    
    Q = len(major_comp_fixed)
    R = len(minor_comp_fixed)
    N = len(features_fixed)
    
    features_fixed = np.array(features_fixed, dtype=np.int64)
    
    # Center the data
    centered = features_fixed - mean_fixed
    
    # Project onto major components
    major_proj = np.zeros(Q, dtype=np.int64)
    for i in range(Q):
        acc = np.int64(0)
        for j in range(N):
            mult_result = (centered[j] * major_comp_fixed[i][j]) >> frac_bits
            acc += mult_result
        major_proj[i] = np.int32(acc & 0xFFFFFFFF)  # Truncate to 32-bit
    
    # Project onto minor components
    minor_proj = np.zeros(R, dtype=np.int64)
    for i in range(R):
        acc = np.int64(0)
        for j in range(N):
            mult_result = (centered[j] * minor_comp_fixed[i][j]) >> frac_bits
            acc += mult_result
        minor_proj[i] = np.int32(acc & 0xFFFFFFFF)  # Truncate to 32-bit
    
    # Reconstruct from major components
    major_recon = np.zeros(N, dtype=np.int64)
    for j in range(N):
        acc = np.int64(0)
        for i in range(Q):
            mult_result = (major_proj[i] * major_comp_fixed[i][j]) >> frac_bits
            acc += mult_result
        major_recon[j] = np.int32(acc & 0xFFFFFFFF)  # Truncate to 32-bit
    
    # Compute major score
    major_score_acc = np.int64(0)
    for i in range(N):
        residual = np.int32(centered[i] - major_recon[i])
        mult_result = (np.int64(residual) * np.int64(residual)) >> frac_bits
        major_score_acc += mult_result
    
    # Compute minor score
    minor_score_acc = np.int64(0)
    for i in range(R):
        mult_result = (minor_proj[i] * minor_proj[i]) >> frac_bits
        minor_score_acc += mult_result
    
    # Truncate scores to 32-bit signed (wrap on overflow like hardware)
    # Convert to uint32 first, then reinterpret as int32
    major_score_u32 = np.uint32(major_score_acc & 0xFFFFFFFF)
    minor_score_u32 = np.uint32(minor_score_acc & 0xFFFFFFFF)
    major_score_final = major_score_u32.view(np.int32)
    minor_score_final = minor_score_u32.view(np.int32)
    
    # Threshold check (threshold = 100 in fixed-point)
    threshold = 100 << frac_bits
    # Use truncated 32-bit values for threshold comparison (like hardware)
    attack_detected = 1 if (int(major_score_final) > threshold or int(minor_score_final) > threshold) else 0
    
    return int(major_score_final), int(minor_score_final), attack_detected


def generate_golden_reference(dataset_path, model_path, output_path, max_samples=200):
    """
    Generate golden reference file for hardware verification
    """
    print(f"Loading PCA model from {model_path}...")
    model = load_pca_model(model_path)
    
    print(f"Loading dataset from {dataset_path}...")
    samples = load_dataset(dataset_path, max_samples)
    print(f"Loaded {len(samples)} samples")
    
    config = model['config']
    frac_bits = config['frac_bits']
    
    # Generate golden reference
    golden_results = []
    
    print("Generating golden reference...")
    for idx, sample in enumerate(samples):
        # Preprocess sample
        features_float = preprocess_kdd_sample(sample)
        
        # Convert to fixed-point
        features_fixed = np.array([fixed_point_convert(f, frac_bits) for f in features_float], dtype=np.int32)
        
        # Run floating-point version (for reference)
        major_float, minor_float, _, _ = pca_detection_float(features_float, model)
        
        # Run fixed-point version (matches hardware)
        major_fixed, minor_fixed, attack = pca_detection_fixed(features_fixed, model, frac_bits)
        
        golden_results.append({
            'sample_id': idx,
            'features_fixed': features_fixed.tolist(),
            'major_score_float': float(major_float),
            'minor_score_float': float(minor_float),
            'major_score_fixed': int(major_fixed),
            'minor_score_fixed': int(minor_fixed),
            'attack_detected': int(attack)
        })
        
        if (idx + 1) % 50 == 0:
            print(f"  Processed {idx + 1} samples...")
    
    # Save golden reference
    print(f"\nSaving golden reference to {output_path}...")
    with open(output_path, 'w') as f:
        json.dump({
            'config': config,
            'num_samples': len(golden_results),
            'results': golden_results
        }, f, indent=2)
    
    print("Done!")
    print(f"\nSummary:")
    print(f"  Total samples: {len(golden_results)}")
    attacks = sum(1 for r in golden_results if r['attack_detected'] == 1)
    print(f"  Attacks detected: {attacks}")
    print(f"  Normal traffic: {len(golden_results) - attacks}")
    
    return golden_results


def generate_systemverilog_testdata(golden_results, output_path, max_samples=50):
    """
    Generate SystemVerilog testbench data from golden reference
    """
    print(f"\nGenerating SystemVerilog test data to {output_path}...")
    
    with open(output_path, 'w') as f:
        f.write("// Auto-generated test vectors for tb_top.sv\n")
        f.write("// Generated by generate_golden_reference.py\n\n")
        
        for idx, result in enumerate(golden_results[:max_samples]):
            f.write(f"        // Test {idx + 1}\n")
            f.write(f"        @(posedge clk);\n")
            f.write(f"        pkt_valid <= 1'b1;\n")
            
            features = result['features_fixed']
            for i, feat in enumerate(features):
                f.write(f"        pkt_features[{i}] <= 16'sd{feat};\n")
            
            f.write(f"        \n")
            f.write(f"        @(posedge clk);\n")
            f.write(f"        pkt_valid <= 1'b0;\n")
            f.write(f"        \n")
            f.write(f"        // Wait for result\n")
            f.write(f"        repeat(10) @(posedge clk);\n")
            f.write(f"        \n")
            f.write(f"        // Expected: major={result['major_score_fixed']}, minor={result['minor_score_fixed']}, attack={result['attack_detected']}\n")
            f.write(f"        if (valid_out) begin\n")
            f.write(f"            $display(\"Test {idx + 1}: attack=%0d, major=%10d, minor=%10d\", attack_detected, major_score, minor_score);\n")
            f.write(f"        end\n\n")
    
    print(f"Generated {min(max_samples, len(golden_results))} test vectors")


def main():
    # Paths
    base_dir = Path(__file__).parent.parent
    dataset_path = base_dir / "dataset" / "kddcup.data_10_percent.csv"
    model_path = base_dir / "model" / "pca_coeffs.json"
    output_path = base_dir / "model" / "golden_reference.json"
    sv_output_path = base_dir / "tb" / "test_vectors_golden.sv"
    
    # Generate golden reference
    golden_results = generate_golden_reference(
        dataset_path=str(dataset_path),
        model_path=str(model_path),
        output_path=str(output_path),
        max_samples=200
    )
    
    # Generate SystemVerilog test data
    generate_systemverilog_testdata(
        golden_results=golden_results,
        output_path=str(sv_output_path),
        max_samples=50
    )


if __name__ == "__main__":
    main()
