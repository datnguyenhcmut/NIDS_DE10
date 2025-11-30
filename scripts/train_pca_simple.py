#!/usr/bin/env python3
"""
Train PCA model using preprocessed SMOTE data
Simple version without sklearn dependencies issues
"""

import numpy as np
import pandas as pd
import json
from pathlib import Path


def compute_pca_manual(X, n_components=6):
    """Compute PCA manually using SVD"""
    print("Computing PCA using SVD...")
    
    # Center the data
    mean = np.mean(X, axis=0)
    X_centered = X - mean
    
    # Compute SVD
    U, s, Vt = np.linalg.svd(X_centered, full_matrices=False)
    
    # Components are rows of Vt
    components = Vt[:n_components]
    
    # Explained variance
    explained_variance = (s[:n_components] ** 2) / (X.shape[0] - 1)
    total_variance = np.sum(s ** 2) / (X.shape[0] - 1)
    explained_variance_ratio = explained_variance / total_variance
    
    return mean, components, explained_variance_ratio


def fixed_point_convert(value, frac_bits=8):
    """Convert floating point to fixed-point integer"""
    return int(round(value * (1 << frac_bits)))


def main():
    base_dir = Path(__file__).parent.parent
    data_path = base_dir / "dataset" / "data_after_smote.csv"
    output_path = base_dir / "model" / "pca_coeffs.json"
    
    print(f"Loading data from {data_path}...")
    df = pd.read_csv(data_path)
    
    print(f"NaN values: {df.isnull().sum().sum()}")
    
    # Fill NaN with 0
    df = df.fillna(0)
    
    # Remove class column and select only numeric columns
    if 'class' in df.columns:
        y = df['class'].apply(lambda x: 0 if 'normal' in str(x).lower() else 1).values
        X = df.drop('class', axis=1).select_dtypes(include=[np.number]).values
    else:
        y = np.zeros(len(df))
        X = df.select_dtypes(include=[np.number]).values
    
    # Limit to 28 features to match hardware
    if X.shape[1] > 28:
        print(f"Limiting from {X.shape[1]} to 28 features for hardware compatibility")
        X = X[:, :28]
    
    print(f"Data shape: {X.shape}")
    print(f"Features: {X.shape[1]}")
    print(f"Samples: {X.shape[0]}")
    print(f"Normal: {np.sum(y==0)}, Attack: {np.sum(y==1)}")
    
    # Use subset for faster computation
    max_samples = min(10000, X.shape[0])
    X_subset = X[:max_samples]
    
    print(f"\nUsing {max_samples} samples for PCA training...")
    
    # Compute PCA (6 components: 4 major + 2 minor)
    n_major = 4
    n_minor = 2
    n_total = n_major + n_minor
    
    mean, components, variance_ratio = compute_pca_manual(X_subset, n_components=n_total)
    
    print(f"\nPCA Results:")
    print(f"Explained variance ratio: {variance_ratio}")
    print(f"Total variance explained: {np.sum(variance_ratio):.4f}")
    
    # Convert to fixed-point
    frac_bits = 8
    total_bits = 32
    n_features = X.shape[1]
    
    # Note: We need to scale features to match fixed-point range
    # Compute scale factors
    feature_max = np.max(np.abs(X_subset), axis=0)
    feature_max[feature_max == 0] = 1  # Avoid division by zero
    scale = 1.0 / feature_max
    
    # Adjust mean and components for scaling
    mean_scaled = mean * scale
    components_scaled = components * scale[:, np.newaxis].T
    
    # Convert to fixed-point
    mean_fixed = [fixed_point_convert(m, frac_bits) for m in mean_scaled]
    
    major_components_float = components_scaled[:n_major].tolist()
    major_components_fixed = [[fixed_point_convert(c, frac_bits) for c in comp] 
                              for comp in components_scaled[:n_major]]
    
    minor_components_float = components_scaled[n_major:].tolist()
    minor_components_fixed = [[fixed_point_convert(c, frac_bits) for c in comp] 
                              for comp in components_scaled[n_major:]]
    
    # Create model dictionary
    model = {
        'config': {
            'n_features': n_features,
            'n_major_components': n_major,
            'n_minor_components': n_minor,
            'total_bits': total_bits,
            'frac_bits': frac_bits
        },
        'mean': mean_scaled.tolist(),
        'mean_fixed': mean_fixed,
        'major_components': major_components_float,
        'major_components_fixed': major_components_fixed,
        'minor_components': minor_components_float,
        'minor_components_fixed': minor_components_fixed,
        'explained_variance_ratio': variance_ratio.tolist(),
        'scale': scale.tolist()
    }
    
    # Save to JSON
    print(f"\nSaving model to {output_path}...")
    with open(output_path, 'w') as f:
        json.dump(model, f, indent=2)
    
    print(f"\n{'='*50}")
    print("PCA model trained successfully!")
    print(f"  Features: {n_features}")
    print(f"  Major components: {n_major}")
    print(f"  Minor components: {n_minor}")
    print(f"  Fixed-point: Q{total_bits - frac_bits}.{frac_bits}")
    print(f"\nNext steps:")
    print("  1. python scripts/generate_golden_reference.py")
    print("  2. python scripts/generate_testbench.py")
    print("  3. make all")
    print(f"{'='*50}")


if __name__ == "__main__":
    main()
