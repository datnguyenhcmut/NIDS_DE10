// Testbench for NIDS Pipeline with Golden Reference
// Auto-generated from golden reference
// Tests 50 samples from KDD Cup dataset

`timescale 1ns/1ps

module tb_top;

    parameter DATA_WIDTH = 32;
    parameter N_FEATURES = 28;
    parameter CLK_PERIOD = 20;  // 50 MHz
    parameter FRAC_BITS = 8;
    
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
        $fwrite(fp, "NIDS Simulation Report with Golden Reference\n");
        $fwrite(fp, "=============================================\n\n");
        
        // VCD dump for GTKWave
        $dumpfile("output/logs/wave.vcd");
        $dumpvars(0, tb_top);
        
        // Reset
        repeat(5) @(posedge clk);
        rst_n = 1;
        repeat(2) @(posedge clk);
        
        $display("Starting simulation with %0d test vectors", 50);
        $fwrite(fp, "Total test vectors: %0d\n", 50);
        $fwrite(fp, "Tolerance: ±%0d fixed-point units\n\n", tolerance);
        
        // Run test vectors

        // Test 1
        @(posedge clk);
        test_count = 1;
        expected_attack = 0;
        expected_major = 174;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00000000;
        pkt_features[3] = 32'h00000000;
        pkt_features[4] = 32'h00000000;
        pkt_features[5] = 32'h00000000;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000000;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000000;
        pkt_features[23] = 32'h00000000;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 2
        @(posedge clk);
        test_count = 2;
        expected_attack = 0;
        expected_major = -964008424;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000b500;
        pkt_features[5] = 32'h00154a00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000800;
        pkt_features[23] = 32'h00000800;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 3
        @(posedge clk);
        test_count = 3;
        expected_attack = 1;
        expected_major = 88817476;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000ef00;
        pkt_features[5] = 32'h0001e600;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000800;
        pkt_features[23] = 32'h00000800;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 4
        @(posedge clk);
        test_count = 4;
        expected_attack = 1;
        expected_major = 485478538;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000eb00;
        pkt_features[5] = 32'h00053900;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000800;
        pkt_features[23] = 32'h00000800;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 5
        @(posedge clk);
        test_count = 5;
        expected_attack = 1;
        expected_major = 483605318;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000db00;
        pkt_features[5] = 32'h00053900;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000600;
        pkt_features[23] = 32'h00000600;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 6
        @(posedge clk);
        test_count = 6;
        expected_attack = 1;
        expected_major = 1082790424;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000d900;
        pkt_features[5] = 32'h0007f000;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000600;
        pkt_features[23] = 32'h00000600;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 7
        @(posedge clk);
        test_count = 7;
        expected_attack = 1;
        expected_major = 1082790424;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000d900;
        pkt_features[5] = 32'h0007f000;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000600;
        pkt_features[23] = 32'h00000600;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 8
        @(posedge clk);
        test_count = 8;
        expected_attack = 1;
        expected_major = 988677300;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000d400;
        pkt_features[5] = 32'h00079400;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000100;
        pkt_features[23] = 32'h00000200;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 9
        @(posedge clk);
        test_count = 9;
        expected_attack = 1;
        expected_major = 1306888;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00009f00;
        pkt_features[5] = 32'h000ff700;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000500;
        pkt_features[23] = 32'h00000500;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 10
        @(posedge clk);
        test_count = 10;
        expected_attack = 1;
        expected_major = 30857396;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000d200;
        pkt_features[5] = 32'h00009700;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000800;
        pkt_features[23] = 32'h00000800;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 11
        @(posedge clk);
        test_count = 11;
        expected_attack = 1;
        expected_major = 183388598;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000d400;
        pkt_features[5] = 32'h00031200;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000100;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000800;
        pkt_features[23] = 32'h00000800;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 12
        @(posedge clk);
        test_count = 12;
        expected_attack = 1;
        expected_major = 124828498;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000d200;
        pkt_features[5] = 32'h00027000;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00001200;
        pkt_features[23] = 32'h00001200;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 13
        @(posedge clk);
        test_count = 13;
        expected_attack = 1;
        expected_major = 1030407432;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000b100;
        pkt_features[5] = 32'h0007c100;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000100;
        pkt_features[23] = 32'h00000100;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 14
        @(posedge clk);
        test_count = 14;
        expected_attack = 1;
        expected_major = 179339438;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000de00;
        pkt_features[5] = 32'h00030500;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000b00;
        pkt_features[23] = 32'h00000b00;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 15
        @(posedge clk);
        test_count = 15;
        expected_attack = 1;
        expected_major = 380317196;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00010000;
        pkt_features[5] = 32'h00049100;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000400;
        pkt_features[23] = 32'h00000400;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 16
        @(posedge clk);
        test_count = 16;
        expected_attack = 1;
        expected_major = 45740540;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000f100;
        pkt_features[5] = 32'h00010300;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000100;
        pkt_features[23] = 32'h00000100;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 17
        @(posedge clk);
        test_count = 17;
        expected_attack = 1;
        expected_major = 894943658;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00010400;
        pkt_features[5] = 32'h00072d00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000b00;
        pkt_features[23] = 32'h00000b00;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 18
        @(posedge clk);
        test_count = 18;
        expected_attack = 1;
        expected_major = 46008066;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000f100;
        pkt_features[5] = 32'h00010500;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000200;
        pkt_features[23] = 32'h00000200;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 19
        @(posedge clk);
        test_count = 19;
        expected_attack = 1;
        expected_major = 201970376;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00010100;
        pkt_features[5] = 32'h00033200;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000c00;
        pkt_features[23] = 32'h00000c00;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 20
        @(posedge clk);
        test_count = 20;
        expected_attack = 1;
        expected_major = 44259526;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000e900;
        pkt_features[5] = 32'h0000ff00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000200;
        pkt_features[23] = 32'h00000800;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 21
        @(posedge clk);
        test_count = 21;
        expected_attack = 1;
        expected_major = 92646938;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000e900;
        pkt_features[5] = 32'h0001f800;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000700;
        pkt_features[23] = 32'h00000700;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 22
        @(posedge clk);
        test_count = 22;
        expected_attack = 1;
        expected_major = 445469062;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00010000;
        pkt_features[5] = 32'h0004f900;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00001100;
        pkt_features[23] = 32'h00001100;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 23
        @(posedge clk);
        test_count = 23;
        expected_attack = 1;
        expected_major = 44374462;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000ea00;
        pkt_features[5] = 32'h0000ff00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000500;
        pkt_features[23] = 32'h00000500;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 24
        @(posedge clk);
        test_count = 24;
        expected_attack = 1;
        expected_major = 45811138;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000f100;
        pkt_features[5] = 32'h00010300;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000c00;
        pkt_features[23] = 32'h00000c00;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 25
        @(posedge clk);
        test_count = 25;
        expected_attack = 1;
        expected_major = 268199582;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000ef00;
        pkt_features[5] = 32'h0003c800;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000300;
        pkt_features[23] = 32'h00000300;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 26
        @(posedge clk);
        test_count = 26;
        expected_attack = 1;
        expected_major = 971874228;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000f500;
        pkt_features[5] = 32'h00077f00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000d00;
        pkt_features[23] = 32'h00000d00;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 27
        @(posedge clk);
        test_count = 27;
        expected_attack = 1;
        expected_major = 1190053970;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000f800;
        pkt_features[5] = 32'h00085100;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00001700;
        pkt_features[23] = 32'h00001700;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 28
        @(posedge clk);
        test_count = 28;
        expected_attack = 1;
        expected_major = 831563746;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00016200;
        pkt_features[5] = 32'h0006d800;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000200;
        pkt_features[23] = 32'h00000200;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 29
        @(posedge clk);
        test_count = 29;
        expected_attack = 0;
        expected_major = -194165468;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000c100;
        pkt_features[5] = 32'h000f9700;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000100;
        pkt_features[23] = 32'h00000100;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 30
        @(posedge clk);
        test_count = 30;
        expected_attack = 1;
        expected_major = 1476327240;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000d600;
        pkt_features[5] = 32'h003a6f00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000600;
        pkt_features[23] = 32'h00000600;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 31
        @(posedge clk);
        test_count = 31;
        expected_attack = 1;
        expected_major = 463874888;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000d400;
        pkt_features[5] = 32'h00051d00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000200;
        pkt_features[23] = 32'h00000a00;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 32
        @(posedge clk);
        test_count = 32;
        expected_attack = 0;
        expected_major = -821412710;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000d700;
        pkt_features[5] = 32'h000e5600;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000300;
        pkt_features[23] = 32'h00000300;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 33
        @(posedge clk);
        test_count = 33;
        expected_attack = 1;
        expected_major = 1118263652;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000d900;
        pkt_features[5] = 32'h00480200;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000200;
        pkt_features[23] = 32'h00000200;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 34
        @(posedge clk);
        test_count = 34;
        expected_attack = 1;
        expected_major = 70637152;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000cd00;
        pkt_features[5] = 32'h0001a800;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000200;
        pkt_features[23] = 32'h00001900;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 35
        @(posedge clk);
        test_count = 35;
        expected_attack = 1;
        expected_major = 65915718;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00009b00;
        pkt_features[5] = 32'h0001a800;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000300;
        pkt_features[23] = 32'h00000d00;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 36
        @(posedge clk);
        test_count = 36;
        expected_attack = 1;
        expected_major = 70170724;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000ca00;
        pkt_features[5] = 32'h0001a800;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000300;
        pkt_features[23] = 32'h00000300;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 37
        @(posedge clk);
        test_count = 37;
        expected_attack = 0;
        expected_major = -1614318320;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000eb00;
        pkt_features[5] = 32'h0019e300;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000100;
        pkt_features[23] = 32'h00000100;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 38
        @(posedge clk);
        test_count = 38;
        expected_attack = 0;
        expected_major = -336338108;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00010300;
        pkt_features[5] = 32'h000f4d00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000100;
        pkt_features[23] = 32'h00000100;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 39
        @(posedge clk);
        test_count = 39;
        expected_attack = 1;
        expected_major = 1838711722;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00012d00;
        pkt_features[5] = 32'h000a5d00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000200;
        pkt_features[23] = 32'h00000200;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 40
        @(posedge clk);
        test_count = 40;
        expected_attack = 1;
        expected_major = 86264002;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00014200;
        pkt_features[5] = 32'h0001a800;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000200;
        pkt_features[23] = 32'h00000200;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 41
        @(posedge clk);
        test_count = 41;
        expected_attack = 1;
        expected_major = 117968116;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00017200;
        pkt_features[5] = 32'h00020800;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000300;
        pkt_features[23] = 32'h00000300;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 42
        @(posedge clk);
        test_count = 42;
        expected_attack = 1;
        expected_major = 117968116;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00017200;
        pkt_features[5] = 32'h00020800;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000300;
        pkt_features[23] = 32'h00000300;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 43
        @(posedge clk);
        test_count = 43;
        expected_attack = 1;
        expected_major = 294414662;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000ac00;
        pkt_features[5] = 32'h0016fc00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000600;
        pkt_features[23] = 32'h00000600;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 44
        @(posedge clk);
        test_count = 44;
        expected_attack = 0;
        expected_major = -2140499756;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00010800;
        pkt_features[5] = 32'h003efb00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000200;
        pkt_features[23] = 32'h00000d00;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 45
        @(posedge clk);
        test_count = 45;
        expected_attack = 1;
        expected_major = 1001831208;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h0000ff00;
        pkt_features[5] = 32'h00079c00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000400;
        pkt_features[23] = 32'h00000e00;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 46
        @(posedge clk);
        test_count = 46;
        expected_attack = 1;
        expected_major = 1509459398;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00011200;
        pkt_features[5] = 32'h004d4e00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000600;
        pkt_features[23] = 32'h00000600;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 47
        @(posedge clk);
        test_count = 47;
        expected_attack = 1;
        expected_major = 60758884;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00013900;
        pkt_features[5] = 32'h00012500;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000300;
        pkt_features[23] = 32'h00000300;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 48
        @(posedge clk);
        test_count = 48;
        expected_attack = 1;
        expected_major = 830057176;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00009100;
        pkt_features[5] = 32'h00117200;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000400;
        pkt_features[23] = 32'h00000400;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 49
        @(posedge clk);
        test_count = 49;
        expected_attack = 1;
        expected_major = 89396376;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00012200;
        pkt_features[5] = 32'h0001cc00;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000100;
        pkt_features[23] = 32'h00000100;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Test 50
        @(posedge clk);
        test_count = 50;
        expected_attack = 0;
        expected_major = -473527484;
        expected_minor = 0;
        
        // Load features
        pkt_features[0] = 32'h00000000;
        pkt_features[1] = 32'h00000000;
        pkt_features[2] = 32'h00006f00;
        pkt_features[3] = 32'h0000cb00;
        pkt_features[4] = 32'h00013500;
        pkt_features[5] = 32'h00458600;
        pkt_features[6] = 32'h00000000;
        pkt_features[7] = 32'h00000000;
        pkt_features[8] = 32'h00000000;
        pkt_features[9] = 32'h00000000;
        pkt_features[10] = 32'h00000000;
        pkt_features[11] = 32'h00000100;
        pkt_features[12] = 32'h00000000;
        pkt_features[13] = 32'h00000000;
        pkt_features[14] = 32'h00000000;
        pkt_features[15] = 32'h00000000;
        pkt_features[16] = 32'h00000000;
        pkt_features[17] = 32'h00000000;
        pkt_features[18] = 32'h00000000;
        pkt_features[19] = 32'h00000000;
        pkt_features[20] = 32'h00000000;
        pkt_features[21] = 32'h00000000;
        pkt_features[22] = 32'h00000200;
        pkt_features[23] = 32'h00000200;
        pkt_features[24] = 32'h00000000;
        pkt_features[25] = 32'h00000000;
        pkt_features[26] = 32'h00000000;
        pkt_features[27] = 32'h00000000;
        
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
                $fwrite(fp, "Test %0d: PASS\n", test_count);
            end else begin
                fail_count++;
                $display("Test %0d: FAIL - Got(attack=%0d, major=%10d, minor=%10d) Expected(attack=%0d, major=%10d, minor=%10d)",
                        test_count, attack_detected, major_score, minor_score,
                        expected_attack, expected_major, expected_minor);
                $fwrite(fp, "Test %0d: FAIL\n", test_count);
                $fwrite(fp, "  Attack: Got=%0d, Expected=%0d, Match=%0d\n", 
                       attack_detected, expected_attack, attack_match);
                $fwrite(fp, "  Major:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       major_score, expected_major, major_diff, major_match);
                $fwrite(fp, "  Minor:  Got=%10d, Expected=%10d, Diff=%10d, Match=%0d\n",
                       minor_score, expected_minor, minor_diff, minor_match);
            end
        end
        
        repeat(2) @(posedge clk);

        // Summary
        $display("");
        $display("=== Simulation Complete ===");
        $display("Total tests: %0d", test_count);
        $display("Passed: %0d (%.1f%%)", pass_count, 100.0*pass_count/test_count);
        $display("Failed: %0d (%.1f%%)", fail_count, 100.0*fail_count/test_count);
        
        $fwrite(fp, "\n=== Summary ===\n");
        $fwrite(fp, "Total tests: %0d\n", test_count);
        $fwrite(fp, "Passed: %0d (%.1f%%)\n", pass_count, 100.0*pass_count/test_count);
        $fwrite(fp, "Failed: %0d (%.1f%%)\n", fail_count, 100.0*fail_count/test_count);
        
        $fclose(fp);
        
        if (fail_count == 0) begin
            $display("\n*** ALL TESTS PASSED ***\n");
        end else begin
            $display("\n*** %0d TESTS FAILED ***\n", fail_count);
        end
        
        $finish;
    end

endmodule
