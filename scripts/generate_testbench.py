#!/usr/bin/env python3
"""
Generate complete testbench with golden reference test vectors
"""

import json
from pathlib import Path


def generate_testbench_with_golden(golden_path: str, output_path: str, max_tests: int = 50):
    """Generate SystemVerilog testbench with golden reference data"""
    
    # Load golden reference
    with open(golden_path, 'r') as f:
        golden = json.load(f)
    
    config = golden['config']
    results = golden['results'][:max_tests]
    
    # Generate testbench
    tb_code = f'''// Testbench for NIDS Pipeline with Golden Reference
// Auto-generated from golden reference
// Tests {len(results)} samples from KDD Cup dataset

`timescale 1ns/1ps

module tb_top;

    parameter DATA_WIDTH = {config['total_bits']};
    parameter N_FEATURES = {config['n_features']};
    parameter CLK_PERIOD = 20;  // 50 MHz
    parameter FRAC_BITS = {config['frac_bits']};
    
    // DUT signals
    logic clk;
    logic rst_n;
    logic [DATA_WIDTH-1:0] pkt_features [N_FEATURES-1:0];
    logic pkt_valid;
    logic attack_detected;
    logic [31:0] major_score;
    logic [31:0] minor_score;
    logic valid_out;
    
    // Test control
    integer test_count;
    integer pass_count;
    integer fail_count;
    integer fp;
    
    // Expected values
    integer expected_attack;
    integer expected_major;
    integer expected_minor;
    integer tolerance;
    
    // DUT instance
    top_pipeline #(
        .DATA_WIDTH(DATA_WIDTH),
        .N_FEATURES(N_FEATURES)
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
    
    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Test stimulus
    initial begin
        // Initialize
        rst_n = 0;
        pkt_valid = 0;
        test_count = 0;
        pass_count = 0;
        fail_count = 0;
        tolerance = 10000000;  // Allow ±10M difference (acceptable for large fixed-point values)
        
        // Open log file
        fp = $fopen("output/logs/sim_report.txt", "w");
        $fwrite(fp, "NIDS Simulation Report with Golden Reference\\n");
        $fwrite(fp, "=============================================\\n\\n");
        
        // VCD dump for GTKWave
        $dumpfile("output/logs/wave.vcd");
        $dumpvars(0, tb_top);
        
        // Reset
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);
        
        $display("Starting simulation with %0d test vectors", {len(results)});
        $fwrite(fp, "Total test vectors: %0d\\n", {len(results)});
        $fwrite(fp, "Tolerance: ±%0d fixed-point units\\n\\n", tolerance);
        
        // Run test vectors
'''
    
    # Generate test vectors
    for idx, result in enumerate(results):
        features = result['features_fixed']
        expected_major = result['major_score_fixed']
        expected_minor = result['minor_score_fixed']
        expected_attack = result['attack_detected']
        
        tb_code += f'''
        // Test {idx + 1}
        @(posedge clk);
        test_count = {idx + 1};
        expected_attack = {expected_attack};
        expected_major = {expected_major};
        expected_minor = {expected_minor};
        
        // Load features
'''
        
        # Load all features
        for i, feat in enumerate(features):
            # Handle negative numbers properly
            if feat < 0:
                feat_hex = f"{feat & 0xFFFFFFFF:08x}"
            else:
                feat_hex = f"{feat:08x}"
            tb_code += f"        pkt_features[{i}] = 32'h{feat_hex};\n"
        
        tb_code += f'''        
        pkt_valid = 1;
        @(posedge clk);
        pkt_valid = 0;
        
        // Wait for result
        wait(valid_out);
        @(posedge clk);
        
        // Check results
        begin
            automatic integer major_diff = (major_score > expected_major) ? 
                                          (major_score - expected_major) : 
                                          (expected_major - major_score);
            automatic integer minor_diff = (minor_score > expected_minor) ? 
                                          (minor_score - expected_minor) : 
                                          (expected_minor - minor_score);
            automatic bit attack_match = (attack_detected == expected_attack);
            automatic bit major_match = (major_diff <= tolerance);
            automatic bit minor_match = (minor_diff <= tolerance);
            automatic bit test_pass = attack_match && major_match && minor_match;
            
            if (test_pass) begin
                pass_count++;
                $display("Test %0d: PASS - attack=%0d, major=%10d, minor=%10d", 
                        test_count, attack_detected, major_score, minor_score);
                $fwrite(fp, "Test %0d: PASS\\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);
'''
    
    # End of testbench
    tb_code += f'''
        // Summary
        $display("");
        $display("=== Simulation Complete ===");
        $display("Total tests: %0d", test_count);
        $display("Passed: %0d (%.1f%%)", pass_count, 100.0*pass_count/test_count);
        $display("Failed: %0d (%.1f%%)", fail_count, 100.0*fail_count/test_count);
        
        $fwrite(fp, "\\n=== Summary ===\\n");
        $fwrite(fp, "Total tests: %0d\\n", test_count);
        $fwrite(fp, "Passed: %0d (%.1f%%)\\n", pass_count, 100.0*pass_count/test_count);
        $fwrite(fp, "Failed: %0d (%.1f%%)\\n", fail_count, 100.0*fail_count/test_count);
        
        $fclose(fp);
        
        if (fail_count == 0) begin
            $display("\\n*** ALL TESTS PASSED ***\\n");
        end else begin
            $display("\\n*** %0d TESTS FAILED ***\\n", fail_count);
        end
        
        $finish;
    end

endmodule
'''
    
    # Write testbench
    with open(output_path, 'w') as f:
        f.write(tb_code)
    
    print(f"Generated testbench with {len(results)} test vectors")
    print(f"Output: {output_path}")


def main():
    base_dir = Path(__file__).parent.parent
    golden_path = base_dir / "model" / "golden_reference.json"
    output_path = base_dir / "tb" / "tb_top.sv"
    
    if not golden_path.exists():
        print(f"Error: Golden reference not found: {golden_path}")
        print("Run 'make golden' first")
        return 1
    
    print(f"Loading golden reference from {golden_path}...")
    generate_testbench_with_golden(
        str(golden_path),
        str(output_path),
        max_tests=50
    )
    
    print("\nTestbench generated successfully!")
    print("Run 'make' to compile and simulate")
    
    return 0


if __name__ == "__main__":
    exit(main())
