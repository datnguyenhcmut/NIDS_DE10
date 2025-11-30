#!/usr/bin/env python3
"""
Generate SystemVerilog testbench from diverse test cases
"""

import json
from pathlib import Path


def generate_testbench(test_data, output_path):
    """Generate SystemVerilog testbench"""
    
    test_cases = test_data['test_cases']
    n_tests = len(test_cases)
    n_features = test_data['config']['n_features']
    
    sv_code = f'''`timescale 1ns / 1ps

//==============================================================================
// Diverse Test Testbench for PCA NIDS Pipeline
// Auto-generated from diverse_test_golden.json
// Tests: zeros, boundaries, random, real samples
//==============================================================================

module tb_diverse;

    // Clock and reset
    logic clk;
    logic rst_n;
    
    // DUT interface
    logic [31:0] pkt_features [0:27];
    logic        pkt_valid;
    logic        attack_detected;
    logic [31:0] major_score;
    logic [31:0] minor_score;
    logic        valid_out;
    
    // Test control
    int test_num;
    int pass_count;
    int fail_count;
    
    // Expected results
    logic [31:0] expected_features [0:{n_tests-1}][0:27];
    int          expected_attack [0:{n_tests-1}];
    logic signed [31:0] expected_major [0:{n_tests-1}];
    logic signed [31:0] expected_minor [0:{n_tests-1}];
    string       test_names [0:{n_tests-1}];
    
    // DUT instantiation
    top_pipeline #(
        .DATA_WIDTH(32),
        .N_FEATURES(28)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .pkt_features(pkt_features),
        .pkt_valid(pkt_valid),
        .attack_detected(attack_detected),
        .major_score(major_score),
        .minor_score(minor_score),
        .valid_out(valid_out)
    );
    
    // Clock generation: 50MHz (20ns period)
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end
    
    // Initialize test vectors
    initial begin
'''
    
    # Generate test vectors
    for i, test in enumerate(test_cases):
        sv_code += f'        // Test {i}: {test["name"]}\n'
        sv_code += f'        test_names[{i}] = "{test["name"]}";\n'
        sv_code += f'        expected_attack[{i}] = {test["actual_attack"]};\n'
        
        # Handle negative numbers for SystemVerilog syntax
        major_val = test["major_score"]
        if major_val < 0:
            sv_code += f'        expected_major[{i}] = -32\'sd{-major_val};\n'
        else:
            sv_code += f'        expected_major[{i}] = 32\'sd{major_val};\n'
        
        minor_val = test["minor_score"]
        if minor_val < 0:
            sv_code += f'        expected_minor[{i}] = -32\'sd{-minor_val};\n'
        else:
            sv_code += f'        expected_minor[{i}] = 32\'sd{minor_val};\n'
        
        for j, feat_val in enumerate(test['features_fp']):
            # Convert to signed 32-bit
            if feat_val < 0:
                feat_val_str = f"-32'sd{-feat_val}"
            else:
                feat_val_str = f"32'd{feat_val}"
            sv_code += f'        expected_features[{i}][{j}] = {feat_val_str};\n'
        sv_code += '\n'
    
    sv_code += '''    end
    
    // Main test sequence
    initial begin
        // Initialize
        rst_n = 0;
        pkt_valid = 0;
        test_num = 0;
        pass_count = 0;
        fail_count = 0;
        
        // Reset DUT
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);
        
        $display("=================================================================");
        $display("  Diverse Test - PCA NIDS Pipeline");
        $display("=================================================================");
        
        // Run all tests
'''
    
    sv_code += f'        for (test_num = 0; test_num < {n_tests}; test_num++) begin : test_loop\n'
    sv_code += '''            int tolerance;
            int major_diff;
            int minor_diff;
            logic pass_attack;
            logic pass_major;
            logic pass_minor;
            logic pass_all;
            
            // Load test features
            for (int i = 0; i < 28; i++) begin
                pkt_features[i] = expected_features[test_num][i];
            end
            
            // Apply stimulus
            pkt_valid = 1;
            @(posedge clk);
            pkt_valid = 0;
            
            // Wait for result
            wait(valid_out == 1);
            @(posedge clk);
            
            // Check results
            tolerance = 10000000;  // ±10M tolerance
            major_diff = (major_score > expected_major[test_num]) ? 
                         (major_score - expected_major[test_num]) : 
                         (expected_major[test_num] - major_score);
            minor_diff = (minor_score > expected_minor[test_num]) ? 
                         (minor_score - expected_minor[test_num]) : 
                         (expected_minor[test_num] - minor_score);
            
            pass_attack = (attack_detected == expected_attack[test_num]);
            pass_major = (major_diff <= tolerance);
            pass_minor = (minor_diff <= tolerance);
            pass_all = pass_attack && pass_major && pass_minor;
            
            if (pass_all) begin
                pass_count++;
                $display("[PASS] Test %2d: %-25s | Attack=%0d | Major=%10d | Minor=%10d", 
                         test_num, test_names[test_num], attack_detected, 
                         $signed(major_score), $signed(minor_score));
            end else begin
                fail_count++;
                $display("[FAIL] Test %2d: %-25s", test_num, test_names[test_num]);
                if (!pass_attack)
                    $display("       Attack: got=%0d, expected=%0d", 
                             attack_detected, expected_attack[test_num]);
                if (!pass_major)
                    $display("       Major:  got=%10d, expected=%10d, diff=%10d", 
                             $signed(major_score), $signed(expected_major[test_num]), major_diff);
                if (!pass_minor)
                    $display("       Minor:  got=%10d, expected=%10d, diff=%10d", 
                             $signed(minor_score), $signed(expected_minor[test_num]), minor_diff);
            end
            
            // Wait between tests
            repeat(5) @(posedge clk);
        end
        
        // Summary
        $display("=================================================================");
        $display("  Test Summary");
        $display("=================================================================");
        $display("  PASS: %2d / %2d", pass_count, pass_count + fail_count);
        $display("  FAIL: %2d / %2d", fail_count, pass_count + fail_count);
        $display("  Rate: %0.1f%%", 100.0 * pass_count / (pass_count + fail_count));
        $display("=================================================================");
        
        if (fail_count == 0) begin
            $display("✓ ALL TESTS PASSED!");
        end else begin
            $display("✗ Some tests failed - check results above");
        end
        
        $finish;
    end
    
    // Timeout watchdog
    initial begin
        #100000000;  // 100ms timeout
        $display("ERROR: Simulation timeout!");
        $finish;
    end

endmodule
'''
    
    # Write to file
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(sv_code)


def main():
    base_dir = Path(__file__).parent.parent
    input_path = base_dir / 'model' / 'diverse_test_golden.json'
    output_path = base_dir / 'tb' / 'tb_diverse.sv'
    
    print(f"Loading test data from {input_path}...")
    with open(input_path, 'r') as f:
        test_data = json.load(f)
    
    print(f"Generating testbench with {len(test_data['test_cases'])} tests...")
    generate_testbench(test_data, output_path)
    
    print(f"✓ Testbench saved to {output_path}")


if __name__ == '__main__':
    main()
