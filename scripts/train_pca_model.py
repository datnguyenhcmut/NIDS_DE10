#!/usr/bin/env python3
"""
Train PCA model for NIDS using KDD Cup dataset
Generates PCA coefficients for hardware implementation
"""

import numpy as np
import pandas as pd
import json
from pathlib import Path
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler


def load_kdd_data(csv_path, max_samples=10000):
    """Load and preprocess KDD Cup dataset"""
    print(f"Loading dataset from {csv_path}...")
    
    # KDD Cup column names
    columns = [
        'duration', 'protocol_type', 'service', 'flag',
        'src_bytes', 'dst_bytes', 'land', 'wrong_fragment', 'urgent',
        'hot', 'num_failed_logins', 'logged_in', 'num_compromised',
        'root_shell', 'su_attempted', 'num_root', 'num_file_creations',
        'num_shells', 'num_access_files', 'num_outbound_cmds',
        'is_host_login', 'is_guest_login', 'count', 'srv_count',
        'serror_rate', 'srv_serror_rate', 'rerror_rate', 'srv_rerror_rate',
        'same_srv_rate', 'diff_srv_rate', 'srv_diff_host_rate',
        'dst_host_count', 'dst_host_srv_count', 'dst_host_same_srv_rate',
        'dst_host_diff_srv_rate', 'dst_host_same_src_port_rate',
        'dst_host_srv_diff_host_rate', 'dst_host_serror_rate',
        'dst_host_srv_serror_rate', 'dst_host_rerror_rate',
        'dst_host_srv_rerror_rate', 'label'
    ]
    
    # Read CSV
    df = pd.read_csv(csv_path, names=columns, nrows=max_samples)
    
    # Select 28 numeric features (matching hardware)
    numeric_features = [
        'duration', 'src_bytes', 'dst_bytes', 'land', 'wrong_fragment',
        'urgent', 'hot', 'num_failed_logins', 'logged_in', 'num_compromised',
        'root_shell', 'su_attempted', 'num_root', 'num_file_creations',
        'num_shells', 'num_access_files', 'num_outbound_cmds',
        'is_host_login', 'is_guest_login', 'count', 'srv_count',
        'serror_rate', 'srv_serror_rate', 'rerror_rate', 'srv_rerror_rate',
        'same_srv_rate', 'diff_srv_rate', 'srv_diff_host_rate'
    ]
    
    # Extract features and labels
    X = df[numeric_features].values
    y = df['label'].apply(lambda x: 0 if x.strip() == 'normal.' else 1).values
    
    print(f"Loaded {len(X)} samples with {X.shape[1]} features")
    print(f"Normal: {np.sum(y==0)}, Attack: {np.sum(y==1)}")
    
    return X, y


def train_pca_model(X, n_major=4, n_minor=2):
    """Train PCA model"""
    print(f"\nTraining PCA model...")
    print(f"Major components: {n_major}, Minor components: {n_minor}")
    
    # Standardize data
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)
    
    # Fit PCA
    n_components = n_major + n_minor
    pca = PCA(n_components=n_components)
    pca.fit(X_scaled)
    
    print(f"Explained variance ratio: {pca.explained_variance_ratio_}")
    print(f"Total variance explained: {np.sum(pca.explained_variance_ratio_):.4f}")
    
    return scaler, pca


def fixed_point_convert(value, frac_bits=8):
    """Convert floating point to fixed-point integer"""
    return int(round(value * (1 << frac_bits)))


def export_pca_model(scaler, pca, output_path, n_major=4, n_minor=2, frac_bits=8, total_bits=32):
    """Export PCA model to JSON for hardware"""
    print(f"\nExporting PCA model to {output_path}...")
    
    n_features = len(scaler.mean_)
    
    # Convert mean to fixed-point
    mean_float = scaler.mean_.tolist()
    mean_fixed = [fixed_point_convert(m, frac_bits) for m in mean_float]
    
    # Convert PCA components to fixed-point
    # Note: components are already in scaled space, multiply by scaler.scale_
    major_components_float = []
    major_components_fixed = []
    for i in range(n_major):
        comp_float = (pca.components_[i] / scaler.scale_).tolist()
        comp_fixed = [fixed_point_convert(c, frac_bits) for c in comp_float]
        major_components_float.append(comp_float)
        major_components_fixed.append(comp_fixed)
    
    minor_components_float = []
    minor_components_fixed = []
    for i in range(n_major, n_major + n_minor):
        comp_float = (pca.components_[i] / scaler.scale_).tolist()
        comp_fixed = [fixed_point_convert(c, frac_bits) for c in comp_float]
        minor_components_float.append(comp_float)
        minor_components_fixed.append(comp_fixed)
    
    # Create model dictionary
    model = {
        'config': {
            'n_features': n_features,
            'n_major_components': n_major,
            'n_minor_components': n_minor,
            'total_bits': total_bits,
            'frac_bits': frac_bits
        },
        'mean': mean_float,
        'mean_fixed': mean_fixed,
        'major_components': major_components_float,
        'major_components_fixed': major_components_fixed,
        'minor_components': minor_components_float,
        'minor_components_fixed': minor_components_fixed,
        'explained_variance_ratio': pca.explained_variance_ratio_.tolist(),
        'scale': scaler.scale_.tolist()
    }
    
    # Save to JSON
    with open(output_path, 'w') as f:
        json.dump(model, f, indent=2)
    
    print(f"Model exported successfully!")
    print(f"  Features: {n_features}")
    print(f"  Major components: {n_major}")
    print(f"  Minor components: {n_minor}")
    print(f"  Fixed-point: Q{total_bits - frac_bits}.{frac_bits}")


def main():
    # Paths
    base_dir = Path(__file__).parent.parent
    dataset_path = base_dir / "dataset" / "kddcup.data_10_percent.csv"
    output_path = base_dir / "model" / "pca_coeffs.json"
    
    # Load data (use smaller sample for faster training)
    X, y = load_kdd_data(str(dataset_path), max_samples=5000)
    
    # Train PCA
    scaler, pca = train_pca_model(X, n_major=4, n_minor=2)
    
    # Export model
    export_pca_model(scaler, pca, str(output_path), 
                     n_major=4, n_minor=2, frac_bits=8, total_bits=32)
    
    print("\n" + "="*50)
    print("PCA model training complete!")
    print("Next steps:")
    print("  1. Run: python scripts/generate_golden_reference.py")
    print("  2. Run: python scripts/generate_testbench.py")
    print("  3. Run: make all")
    print("="*50)


if __name__ == "__main__":
    main()
