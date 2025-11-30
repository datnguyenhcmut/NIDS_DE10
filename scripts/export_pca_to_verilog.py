#!/usr/bin/env python3
"""
Export PCA coefficients to Verilog-readable format
Can be used standalone or as part of the main pipeline
"""

import json
import sys
from pathlib import Path


def export_to_verilog_params(json_path: str, output_path: str):
    """
    Convert PCA coefficients JSON to Verilog parameter file
    """
    with open(json_path, 'r') as f:
        coeffs = json.load(f)
    
    config = coeffs['config']
    n_features = config['n_features']
    q = config['n_major_components']
    r = config['n_minor_components']
    total_bits = config['total_bits']
    frac_bits = config['frac_bits']
    
    # Generate Verilog package
    verilog_code = f"""// PCA Coefficients Package
// Auto-generated from {json_path}

package pca_coeffs_pkg;

    parameter N_FEATURES = {n_features};
    parameter Q = {q};
    parameter R = {r};
    parameter DATA_WIDTH = {total_bits};
    parameter FRAC_BITS = {frac_bits};
    
    // Mean vector (fixed-point)
    parameter logic signed [DATA_WIDTH-1:0] MEAN [N_FEATURES-1:0] = '{{
"""
    
    # Add mean values
    for i, val in enumerate(coeffs['mean_fixed']):
        verilog_code += f"        {total_bits}'sd{val}"
        if i < n_features - 1:
            verilog_code += ","
        verilog_code += f"  // Feature {i}\n"
    
    verilog_code += "    };\n\n"
    
    # Add major components
    verilog_code += "    // Major components matrix\n"
    verilog_code += f"    parameter logic signed [DATA_WIDTH-1:0] MAJOR_COMPONENTS [Q-1:0][N_FEATURES-1:0] = '{{\n"
    
    for i, row in enumerate(coeffs['major_components_fixed']):
        verilog_code += "        '{\n"
        for j, val in enumerate(row):
            verilog_code += f"            {total_bits}'sd{val}"
            if j < len(row) - 1:
                verilog_code += ","
            verilog_code += "\n"
        verilog_code += "        }"
        if i < q - 1:
            verilog_code += ","
        verilog_code += f"  // Major component {i}\n"
    
    verilog_code += "    };\n\n"
    
    # Add minor components
    verilog_code += "    // Minor components matrix\n"
    verilog_code += f"    parameter logic signed [DATA_WIDTH-1:0] MINOR_COMPONENTS [R-1:0][N_FEATURES-1:0] = '{{\n"
    
    for i, row in enumerate(coeffs['minor_components_fixed']):
        verilog_code += "        '{\n"
        for j, val in enumerate(row):
            verilog_code += f"            {total_bits}'sd{val}"
            if j < len(row) - 1:
                verilog_code += ","
            verilog_code += "\n"
        verilog_code += "        }"
        if i < r - 1:
            verilog_code += ","
        verilog_code += f"  // Minor component {i}\n"
    
    verilog_code += "    };\n\n"
    verilog_code += "endpackage\n"
    
    with open(output_path, 'w') as f:
        f.write(verilog_code)
    
    print(f"Exported to {output_path}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python export_pca_to_verilog.py <pca_coeffs.json> [output.sv]")
        sys.exit(1)
    
    json_path = sys.argv[1]
    output_path = sys.argv[2] if len(sys.argv) > 2 else "pca_coeffs_pkg.sv"
    
    export_to_verilog_params(json_path, output_path)
