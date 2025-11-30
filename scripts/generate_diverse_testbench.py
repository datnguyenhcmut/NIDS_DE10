#!/usr/bin/env python3
"""
Generate diverse test cases for NIDS testbench
Tests: zeros, max values, random, boundary, real normal/attack traffic
"""

import numpy as np
import json
import csv
from pathlib import Path


def fixed_point_convert(value, frac_bits=8):
    """Convert floating point to fixed-point Q24.8"""
    result = int(round(value * (1 << frac_bits)))
    # Clamp to 32-bit signed range
    if result > 2147483647:
        result = 2147483647
    elif result < -2147483648:
        result = -2147483648
    return result


def fixed_point_to_float(value, frac_bits=8):
    """Convert fixed-point back to float"""
    return value / (1 << frac_bits)


def load_pca_model(json_path):
    """Load PCA model"""
    with open(json_path, 'r') as f:
        return json.load(f)


def pca_detection_fixed(features, model):
    """
    PCA anomaly detection using fixed-point arithmetic (matching hardware)
    """
    mean = model['mean']
    major_comps = model['major_components']
    minor_comps = model['minor_components']
    
    # Convert to fixed-point
    features_fp = [fixed_point_convert(f) for f in features]
    mean_fp = [fixed_point_convert(m) for m in mean]
    major_fp = [[fixed_point_convert(c) for c in comp] for comp in major_comps]
    minor_fp = [[fixed_point_convert(c) for c in comp] for comp in minor_comps]
    
    # Center features
    centered = [features_fp[i] - mean_fp[i] for i in range(len(features))]
    
    # Project onto major components (using int64 to prevent overflow)
    major_proj = []
    for comp in major_fp:
        proj = np.int64(0)
        for i in range(len(centered)):
            proj += np.int64(centered[i]) * np.int64(comp[i])
        # Shift to get fixed-point result (Q24.8 * Q24.8 = Q48.16, shift by 8)
        proj = int(proj >> 8)
        # Wrap to 32-bit signed (modulo 2^32, like hardware)
        if proj < 0:
            proj = int((proj % (2**32)) - 2**32)
        else:
            proj = int(proj % (2**32))
            if proj >= 2**31:
                proj -= 2**32
        major_proj.append(proj)
    
    # Project onto minor components
    minor_proj = []
    for comp in minor_fp:
        proj = np.int64(0)
        for i in range(len(centered)):
            proj += np.int64(centered[i]) * np.int64(comp[i])
        proj = int(proj >> 8)
        # Wrap to 32-bit signed (modulo 2^32, like hardware)
        if proj < 0:
            proj = int((proj % (2**32)) - 2**32)
        else:
            proj = int(proj % (2**32))
            if proj >= 2**31:
                proj -= 2**32
        minor_proj.append(proj)
    
    # Reconstruct from major components
    reconstructed = [0] * len(features)
    for comp_idx, proj_val in enumerate(major_proj):
        for feat_idx in range(len(features)):
            # Q24.8 * Q24.8 = Q48.16, shift by 8
            recon_contrib = (np.int64(proj_val) * np.int64(major_fp[comp_idx][feat_idx])) >> 8
            reconstructed[feat_idx] += int(recon_contrib)
    
    # SPE (major reconstruction error)
    major_score = np.int64(0)
    for i in range(len(centered)):
        residual = centered[i] - reconstructed[i]
        major_score += np.int64(residual) * np.int64(residual)
    major_score = int(major_score >> 8)
    # Wrap to 32-bit signed (modulo 2^32, like hardware)
    if major_score < 0:
        major_score = int((major_score % (2**32)) - 2**32)
    else:
        major_score = int(major_score % (2**32))
        if major_score >= 2**31:
            major_score -= 2**32
    
    # Minor subspace score
    minor_score = np.int64(0)
    for proj in minor_proj:
        minor_score += np.int64(proj) * np.int64(proj)
    minor_score = int(minor_score >> 8)
    # Wrap to 32-bit signed (modulo 2^32, like hardware)
    if minor_score < 0:
        minor_score = int((minor_score % (2**32)) - 2**32)
    else:
        minor_score = int(minor_score % (2**32))
        if minor_score >= 2**31:
            minor_score -= 2**32
    
    # Attack detection (threshold = 100 << 8 = 25600 in fixed-point)
    # Use absolute value to handle overflow cases with negative scores
    threshold_fp = 100 << 8
    major_abs = abs(major_score)
    minor_abs = abs(minor_score)
    attack_detected = 1 if (major_abs > threshold_fp or minor_abs > threshold_fp) else 0
    
    return attack_detected, major_score, minor_score


def load_real_dataset(csv_path, n_samples=20, normal_only=False):
    """Load real samples from KDD Cup dataset
    
    Args:
        csv_path: Path to dataset CSV
        n_samples: Number of samples to load
        normal_only: If True, only load 'normal' traffic (not attacks)
    """
    samples = []
    with open(csv_path, 'r') as f:
        reader = csv.reader(f)
        for i, row in enumerate(reader):
            if len(samples) >= n_samples:
                break
            if len(row) >= 42:  # Need label column
                # Check label (last column before comma) - filter for normal traffic if requested
                label = row[41].strip().rstrip('.')
                if normal_only and label != 'normal':
                    continue
                
                # Extract numeric features
                try:
                    features = []
                    # Duration
                    features.append(float(row[0]))
                    # Protocol type (skip - categorical)
                    # Service (skip - categorical)
                    # Flag (skip - categorical)
                    # src_bytes, dst_bytes, land, wrong_fragment, urgent
                    for idx in [4, 5, 6, 7, 8]:
                        features.append(float(row[idx]))
                    # Hot, num_failed_logins, logged_in, num_compromised
                    for idx in [9, 10, 11, 12]:
                        features.append(float(row[idx]))
                    # Root_shell through dst_host_srv_rerror_rate (indices 13-40)
                    for idx in range(13, 41):
                        features.append(float(row[idx]))
                    
                    # Limit to 28 features
                    if len(features) >= 28:
                        features = features[:28]
                        samples.append({
                            'features': features,
                            'label': label,
                            'is_normal': (label == 'normal')
                        })
                except (ValueError, IndexError):
                    continue
    return samples


def generate_test_cases(model):
    """Generate diverse test cases"""
    n_features = model['config']['n_features']
    test_cases = []
    
    # Test 1: All zeros
    test_cases.append({
        'name': 'All zeros',
        'features': [0.0] * n_features,
        'expected_attack': 0
    })
    
    # Test 2: Small values (normal traffic)
    test_cases.append({
        'name': 'Small values',
        'features': [0.1, 0.0, 0.0, 0.0, 10.0, 5.0, 0.0, 0.0, 0.0, 0.0,
                     0.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                     0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        'expected_attack': 0
    })
    
    # Test 3: Large src_bytes (possible attack)
    test_cases.append({
        'name': 'Large src_bytes',
        'features': [5.0, 0.0, 0.0, 0.0, 50000.0, 100.0, 0.0, 0.0, 0.0, 0.0,
                     0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                     0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        'expected_attack': 1
    })
    
    # Test 4: High connection rate (DoS attack)
    test_cases.append({
        'name': 'High connection rate',
        'features': [0.1, 0.0, 0.0, 0.0, 100.0, 50.0, 0.0, 0.0, 0.0, 0.0,
                     0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                     0.95, 0.95, 0.0, 0.0, 0.8, 0.9, 0.0, 0.0],
        'expected_attack': 1
    })
    
    # Test 5: Failed login attempts (probe attack)
    test_cases.append({
        'name': 'Failed logins',
        'features': [10.0, 0.0, 0.0, 0.0, 200.0, 100.0, 0.0, 0.0, 0.0, 5.0,
                     0.0, 0.0, 5.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                     0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
        'expected_attack': 1
    })
    
    # Test 6: Boundary - near threshold
    test_cases.append({
        'name': 'Boundary value',
        'features': [1.0, 0.0, 0.0, 0.0, 1000.0, 500.0, 0.0, 0.0, 0.0, 0.0,
                     0.0, 0.8, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                     0.5, 0.5, 0.0, 0.0, 0.5, 0.5, 0.0, 0.0],
        'expected_attack': 0  # May or may not be attack
    })
    
    # Test 7: Random normal values
    np.random.seed(42)
    random_features = []
    for i in range(n_features):
        if i == 4:  # src_bytes
            random_features.append(np.random.uniform(0, 1000))
        elif i == 5:  # dst_bytes
            random_features.append(np.random.uniform(0, 500))
        else:
            random_features.append(np.random.uniform(0, 1))
    test_cases.append({
        'name': 'Random normal',
        'features': random_features,
        'expected_attack': 0
    })
    
    # Test 8: Random attack-like
    random_attack = []
    for i in range(n_features):
        if i == 4:  # src_bytes
            random_attack.append(np.random.uniform(10000, 50000))
        elif i == 5:  # dst_bytes
            random_attack.append(np.random.uniform(5000, 10000))
        elif i > 20:  # Connection stats
            random_attack.append(np.random.uniform(0.7, 1.0))
        else:
            random_attack.append(np.random.uniform(0, 1))
    test_cases.append({
        'name': 'Random attack',
        'features': random_attack,
        'expected_attack': 1
    })
    
    # Test 9-13: Edge cases with extreme values
    # Test 9: Maximum positive values (overflow test)
    test_cases.append({
        'name': 'Max positive values',
        'features': [100.0, 0.0, 0.0, 0.0, 100000.0, 50000.0, 0.0, 0.0, 0.0, 0.0,
                     0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                     1.0, 1.0, 0.0, 0.0, 1.0, 1.0, 0.0, 0.0],
        'expected_attack': 1
    })
    
    # Test 10: Very small non-zero values
    test_cases.append({
        'name': 'Very small values',
        'features': [0.001] * n_features,
        'expected_attack': 0
    })
    
    # Test 11: Mixed positive and high connection rate
    test_cases.append({
        'name': 'Mixed high rate',
        'features': [2.0, 0.0, 0.0, 0.0, 5000.0, 2500.0, 0.0, 0.0, 0.0, 0.0,
                     0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                     0.99, 0.99, 0.0, 0.0, 0.95, 0.98, 0.0, 0.0],
        'expected_attack': 1
    })
    
    # Test 12: Alternating pattern
    alternating = []
    for i in range(n_features):
        alternating.append(100.0 if i % 2 == 0 else 0.0)
    test_cases.append({
        'name': 'Alternating pattern',
        'features': alternating,
        'expected_attack': 1
    })
    
    # Test 13: Gaussian-like normal traffic
    test_cases.append({
        'name': 'Gaussian normal',
        'features': [0.5, 0.0, 0.0, 0.0, 500.0, 250.0, 0.0, 0.0, 0.0, 0.0,
                     0.0, 0.7, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                     0.3, 0.3, 0.0, 0.0, 0.4, 0.4, 0.0, 0.0],
        'expected_attack': 0
    })
    
    # Test 14-18: More random variations with different seeds
    for seed_offset in range(5):
        np.random.seed(100 + seed_offset)
        random_test = []
        for i in range(n_features):
            if i == 4:
                random_test.append(np.random.uniform(0, 10000))
            elif i == 5:
                random_test.append(np.random.uniform(0, 5000))
            else:
                random_test.append(np.random.uniform(0, 1))
        test_cases.append({
            'name': f'Random seed {100+seed_offset}',
            'features': random_test,
            'expected_attack': -1  # Unknown
        })
    
    # Test 19-23: Port scan patterns (varied connection rates)
    for rate in [0.5, 0.6, 0.7, 0.85, 0.95]:
        test_cases.append({
            'name': f'Port scan rate {rate}',
            'features': [0.5, 0.0, 0.0, 0.0, 200.0, 100.0, 0.0, 0.0, 0.0, 0.0,
                         0.0, 0.5, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                         rate, rate, 0.0, 0.0, rate*0.9, rate*0.95, 0.0, 0.0],
            'expected_attack': 1 if rate > 0.7 else 0
        })
    
    # Test 24-28: Different byte sizes
    for bytes_size in [100, 1000, 5000, 20000, 80000]:
        test_cases.append({
            'name': f'Bytes {bytes_size}',
            'features': [1.0, 0.0, 0.0, 0.0, float(bytes_size), float(bytes_size/2), 
                         0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.0, 0.0, 0.0, 0.0,
                         0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.0, 0.0, 0.3, 0.3, 0.0, 0.0],
            'expected_attack': 1 if bytes_size > 10000 else 0
        })
    
    # Test 29-33: Failed login variations
    for failed_count in [1, 3, 5, 10, 20]:
        test_cases.append({
            'name': f'Failed logins {failed_count}',
            'features': [5.0, 0.0, 0.0, 0.0, 150.0, 75.0, 0.0, 0.0, 0.0, float(failed_count),
                         0.0, 0.0 if failed_count > 5 else 1.0, float(failed_count), 0.0, 
                         0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0],
            'expected_attack': 1 if failed_count >= 5 else 0
        })
    
    return test_cases


def main():
    # Paths
    base_dir = Path(__file__).parent.parent
    model_path = base_dir / 'model' / 'pca_coeffs.json'
    dataset_path = base_dir / 'dataset' / 'kddcup.data_10_percent.csv'
    output_path = base_dir / 'model' / 'diverse_test_golden.json'
    
    print("Loading PCA model...")
    model = load_pca_model(model_path)
    
    print("Generating diverse test cases...")
    test_cases = generate_test_cases(model)
    n_features = model['config']['n_features']
    
    # Add synthetic normal traffic (model trained on SMOTE data, so use synthetic)
    print("Generating synthetic normal traffic samples...")
    
    # Normal traffic: small values similar to training data mean
    for i in range(10):
        np.random.seed(100 + i)
        normal_features = []
        for j in range(n_features):
            if j == 0:  # duration
                normal_features.append(np.random.uniform(0, 0.001))
            elif j == 4:  # src_bytes
                normal_features.append(np.random.uniform(0, 0.05))
            elif j == 5:  # dst_bytes
                normal_features.append(np.random.uniform(0, 0.02))
            else:
                normal_features.append(np.random.uniform(0, 0.001))
        
        test_cases.append({
            'name': f'Normal traffic {i+1}',
            'features': normal_features,
            'expected_attack': 0  # Should NOT trigger
        })
    print(f"Added 10 synthetic normal traffic samples")
    
    # Add attack-like patterns for contrast
    print("Generating attack-like traffic samples...")
    for i in range(10):
        np.random.seed(200 + i)
        attack_features = []
        for j in range(n_features):
            if j == 0:  # duration
                attack_features.append(np.random.uniform(0.5, 2.0))
            elif j == 4:  # src_bytes  
                attack_features.append(np.random.uniform(5.0, 20.0))
            elif j == 5:  # dst_bytes
                attack_features.append(np.random.uniform(2.0, 10.0))
            elif j > 20:  # connection stats
                attack_features.append(np.random.uniform(0.7, 1.0))
            else:
                attack_features.append(np.random.uniform(0, 0.5))
        
        test_cases.append({
            'name': f'Attack pattern {i+1}',
            'features': attack_features,
            'expected_attack': 1  # Should trigger
        })
    print(f"Added 10 attack pattern samples")
    
    # Run PCA detection on all test cases
    print(f"\nProcessing {len(test_cases)} test cases...")
    results = []
    
    for i, test in enumerate(test_cases):
        features = test['features']
        attack, major_score, minor_score = pca_detection_fixed(features, model)
        
        result = {
            'test_id': i,
            'name': test['name'],
            'features_fp': [fixed_point_convert(f) for f in features],
            'expected_attack': test.get('expected_attack', -1),
            'actual_attack': attack,
            'major_score': major_score,
            'minor_score': minor_score,
            'major_score_float': fixed_point_to_float(major_score),
            'minor_score_float': fixed_point_to_float(minor_score)
        }
        results.append(result)
        
        match = '✓' if test.get('expected_attack', -1) == -1 or test['expected_attack'] == attack else '✗'
        print(f"Test {i}: {test['name']:20s} | Attack={attack} | "
              f"Major={major_score:12d} ({result['major_score_float']:10.2f}) | "
              f"Minor={minor_score:12d} ({result['minor_score_float']:10.2f}) {match}")
    
    # Save results
    output = {
        'config': model['config'],
        'test_cases': results
    }
    
    with open(output_path, 'w') as f:
        json.dump(output, f, indent=2)
    
    print(f"\n✓ Saved {len(results)} test cases to {output_path}")
    
    # Summary
    if any(r.get('expected_attack', -1) != -1 for r in results):
        known_tests = [r for r in results if r.get('expected_attack', -1) != -1]
        matches = sum(1 for r in known_tests if r['expected_attack'] == r['actual_attack'])
        print(f"Known test accuracy: {matches}/{len(known_tests)} ({100*matches/len(known_tests):.1f}%)")


if __name__ == '__main__':
    main()
