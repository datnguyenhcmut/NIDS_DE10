`timescale 1ns / 1ps

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
    logic [31:0] expected_features [0:52][0:27];
    int          expected_attack [0:52];
    logic signed [31:0] expected_major [0:52];
    logic signed [31:0] expected_minor [0:52];
    string       test_names [0:52];
    
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
        // Test 0: All zeros
        test_names[0] = "All zeros";
        expected_attack[0] = 0;
        expected_major[0] = 32'sd174;
        expected_minor[0] = 32'sd0;
        expected_features[0][0] = 32'd0;
        expected_features[0][1] = 32'd0;
        expected_features[0][2] = 32'd0;
        expected_features[0][3] = 32'd0;
        expected_features[0][4] = 32'd0;
        expected_features[0][5] = 32'd0;
        expected_features[0][6] = 32'd0;
        expected_features[0][7] = 32'd0;
        expected_features[0][8] = 32'd0;
        expected_features[0][9] = 32'd0;
        expected_features[0][10] = 32'd0;
        expected_features[0][11] = 32'd0;
        expected_features[0][12] = 32'd0;
        expected_features[0][13] = 32'd0;
        expected_features[0][14] = 32'd0;
        expected_features[0][15] = 32'd0;
        expected_features[0][16] = 32'd0;
        expected_features[0][17] = 32'd0;
        expected_features[0][18] = 32'd0;
        expected_features[0][19] = 32'd0;
        expected_features[0][20] = 32'd0;
        expected_features[0][21] = 32'd0;
        expected_features[0][22] = 32'd0;
        expected_features[0][23] = 32'd0;
        expected_features[0][24] = 32'd0;
        expected_features[0][25] = 32'd0;
        expected_features[0][26] = 32'd0;
        expected_features[0][27] = 32'd0;

        // Test 1: Small values
        test_names[1] = "Small values";
        expected_attack[1] = 1;
        expected_major[1] = 32'sd31877;
        expected_minor[1] = 32'sd0;
        expected_features[1][0] = 32'd26;
        expected_features[1][1] = 32'd0;
        expected_features[1][2] = 32'd0;
        expected_features[1][3] = 32'd0;
        expected_features[1][4] = 32'd2560;
        expected_features[1][5] = 32'd1280;
        expected_features[1][6] = 32'd0;
        expected_features[1][7] = 32'd0;
        expected_features[1][8] = 32'd0;
        expected_features[1][9] = 32'd0;
        expected_features[1][10] = 32'd0;
        expected_features[1][11] = 32'd128;
        expected_features[1][12] = 32'd0;
        expected_features[1][13] = 32'd0;
        expected_features[1][14] = 32'd0;
        expected_features[1][15] = 32'd0;
        expected_features[1][16] = 32'd0;
        expected_features[1][17] = 32'd0;
        expected_features[1][18] = 32'd0;
        expected_features[1][19] = 32'd0;
        expected_features[1][20] = 32'd0;
        expected_features[1][21] = 32'd0;
        expected_features[1][22] = 32'd0;
        expected_features[1][23] = 32'd0;
        expected_features[1][24] = 32'd0;
        expected_features[1][25] = 32'd0;
        expected_features[1][26] = 32'd0;
        expected_features[1][27] = 32'd0;

        // Test 2: Large src_bytes
        test_names[2] = "Large src_bytes";
        expected_attack[2] = 1;
        expected_major[2] = 32'sd51738738;
        expected_minor[2] = 32'sd0;
        expected_features[2][0] = 32'd1280;
        expected_features[2][1] = 32'd0;
        expected_features[2][2] = 32'd0;
        expected_features[2][3] = 32'd0;
        expected_features[2][4] = 32'd12800000;
        expected_features[2][5] = 32'd25600;
        expected_features[2][6] = 32'd0;
        expected_features[2][7] = 32'd0;
        expected_features[2][8] = 32'd0;
        expected_features[2][9] = 32'd0;
        expected_features[2][10] = 32'd0;
        expected_features[2][11] = 32'd256;
        expected_features[2][12] = 32'd0;
        expected_features[2][13] = 32'd0;
        expected_features[2][14] = 32'd0;
        expected_features[2][15] = 32'd0;
        expected_features[2][16] = 32'd0;
        expected_features[2][17] = 32'd0;
        expected_features[2][18] = 32'd0;
        expected_features[2][19] = 32'd0;
        expected_features[2][20] = 32'd0;
        expected_features[2][21] = 32'd0;
        expected_features[2][22] = 32'd0;
        expected_features[2][23] = 32'd0;
        expected_features[2][24] = 32'd0;
        expected_features[2][25] = 32'd0;
        expected_features[2][26] = 32'd0;
        expected_features[2][27] = 32'd0;

        // Test 3: High connection rate
        test_names[3] = "High connection rate";
        expected_attack[3] = 1;
        expected_major[3] = 32'sd3199175;
        expected_minor[3] = 32'sd0;
        expected_features[3][0] = 32'd26;
        expected_features[3][1] = 32'd0;
        expected_features[3][2] = 32'd0;
        expected_features[3][3] = 32'd0;
        expected_features[3][4] = 32'd25600;
        expected_features[3][5] = 32'd12800;
        expected_features[3][6] = 32'd0;
        expected_features[3][7] = 32'd0;
        expected_features[3][8] = 32'd0;
        expected_features[3][9] = 32'd0;
        expected_features[3][10] = 32'd0;
        expected_features[3][11] = 32'd256;
        expected_features[3][12] = 32'd0;
        expected_features[3][13] = 32'd0;
        expected_features[3][14] = 32'd0;
        expected_features[3][15] = 32'd0;
        expected_features[3][16] = 32'd0;
        expected_features[3][17] = 32'd0;
        expected_features[3][18] = 32'd0;
        expected_features[3][19] = 32'd0;
        expected_features[3][20] = 32'd243;
        expected_features[3][21] = 32'd243;
        expected_features[3][22] = 32'd0;
        expected_features[3][23] = 32'd0;
        expected_features[3][24] = 32'd205;
        expected_features[3][25] = 32'd230;
        expected_features[3][26] = 32'd0;
        expected_features[3][27] = 32'd0;

        // Test 4: Failed logins
        test_names[4] = "Failed logins";
        expected_attack[4] = 1;
        expected_major[4] = 32'sd12835174;
        expected_minor[4] = 32'sd7;
        expected_features[4][0] = 32'd2560;
        expected_features[4][1] = 32'd0;
        expected_features[4][2] = 32'd0;
        expected_features[4][3] = 32'd0;
        expected_features[4][4] = 32'd51200;
        expected_features[4][5] = 32'd25600;
        expected_features[4][6] = 32'd0;
        expected_features[4][7] = 32'd0;
        expected_features[4][8] = 32'd0;
        expected_features[4][9] = 32'd1280;
        expected_features[4][10] = 32'd0;
        expected_features[4][11] = 32'd0;
        expected_features[4][12] = 32'd1280;
        expected_features[4][13] = 32'd0;
        expected_features[4][14] = 32'd0;
        expected_features[4][15] = 32'd0;
        expected_features[4][16] = 32'd0;
        expected_features[4][17] = 32'd0;
        expected_features[4][18] = 32'd0;
        expected_features[4][19] = 32'd0;
        expected_features[4][20] = 32'd0;
        expected_features[4][21] = 32'd0;
        expected_features[4][22] = 32'd0;
        expected_features[4][23] = 32'd0;
        expected_features[4][24] = 32'd0;
        expected_features[4][25] = 32'd0;
        expected_features[4][26] = 32'd0;
        expected_features[4][27] = 32'd0;

        // Test 5: Boundary value
        test_names[5] = "Boundary value";
        expected_attack[5] = 1;
        expected_major[5] = 32'sd319983539;
        expected_minor[5] = 32'sd0;
        expected_features[5][0] = 32'd256;
        expected_features[5][1] = 32'd0;
        expected_features[5][2] = 32'd0;
        expected_features[5][3] = 32'd0;
        expected_features[5][4] = 32'd256000;
        expected_features[5][5] = 32'd128000;
        expected_features[5][6] = 32'd0;
        expected_features[5][7] = 32'd0;
        expected_features[5][8] = 32'd0;
        expected_features[5][9] = 32'd0;
        expected_features[5][10] = 32'd0;
        expected_features[5][11] = 32'd205;
        expected_features[5][12] = 32'd0;
        expected_features[5][13] = 32'd0;
        expected_features[5][14] = 32'd0;
        expected_features[5][15] = 32'd0;
        expected_features[5][16] = 32'd0;
        expected_features[5][17] = 32'd0;
        expected_features[5][18] = 32'd0;
        expected_features[5][19] = 32'd0;
        expected_features[5][20] = 32'd128;
        expected_features[5][21] = 32'd128;
        expected_features[5][22] = 32'd0;
        expected_features[5][23] = 32'd0;
        expected_features[5][24] = 32'd128;
        expected_features[5][25] = 32'd128;
        expected_features[5][26] = 32'd0;
        expected_features[5][27] = 32'd0;

        // Test 6: Random normal
        test_names[6] = "Random normal";
        expected_attack[6] = 1;
        expected_major[6] = 32'sd7787958;
        expected_minor[6] = 32'sd0;
        expected_features[6][0] = 32'd96;
        expected_features[6][1] = 32'd243;
        expected_features[6][2] = 32'd187;
        expected_features[6][3] = 32'd153;
        expected_features[6][4] = 32'd39941;
        expected_features[6][5] = 32'd19967;
        expected_features[6][6] = 32'd15;
        expected_features[6][7] = 32'd222;
        expected_features[6][8] = 32'd154;
        expected_features[6][9] = 32'd181;
        expected_features[6][10] = 32'd5;
        expected_features[6][11] = 32'd248;
        expected_features[6][12] = 32'd213;
        expected_features[6][13] = 32'd54;
        expected_features[6][14] = 32'd47;
        expected_features[6][15] = 32'd47;
        expected_features[6][16] = 32'd78;
        expected_features[6][17] = 32'd134;
        expected_features[6][18] = 32'd111;
        expected_features[6][19] = 32'd75;
        expected_features[6][20] = 32'd157;
        expected_features[6][21] = 32'd36;
        expected_features[6][22] = 32'd75;
        expected_features[6][23] = 32'd94;
        expected_features[6][24] = 32'd117;
        expected_features[6][25] = 32'd201;
        expected_features[6][26] = 32'd51;
        expected_features[6][27] = 32'd132;

        // Test 7: Random attack
        test_names[7] = "Random attack";
        expected_attack[7] = 1;
        expected_major[7] = 32'sd539306504;
        expected_minor[7] = 32'sd0;
        expected_features[7][0] = 32'd152;
        expected_features[7][1] = 32'd12;
        expected_features[7][2] = 32'd156;
        expected_features[7][3] = 32'd44;
        expected_features[7][4] = 32'd3226128;
        expected_features[7][5] = 32'd2494573;
        expected_features[7][6] = 32'd247;
        expected_features[7][7] = 32'd207;
        expected_features[7][8] = 32'd78;
        expected_features[7][9] = 32'd25;
        expected_features[7][10] = 32'd175;
        expected_features[7][11] = 32'd113;
        expected_features[7][12] = 32'd31;
        expected_features[7][13] = 32'd127;
        expected_features[7][14] = 32'd9;
        expected_features[7][15] = 32'd233;
        expected_features[7][16] = 32'd66;
        expected_features[7][17] = 32'd170;
        expected_features[7][18] = 32'd80;
        expected_features[7][19] = 32'd133;
        expected_features[7][20] = 32'd140;
        expected_features[7][21] = 32'd193;
        expected_features[7][22] = 32'd254;
        expected_features[7][23] = 32'd239;
        expected_features[7][24] = 32'd251;
        expected_features[7][25] = 32'd248;
        expected_features[7][26] = 32'd225;
        expected_features[7][27] = 32'd250;

        // Test 8: Max positive values
        test_names[8] = "Max positive values";
        expected_attack[8] = 1;
        expected_major[8] = 32'sd250225544;
        expected_minor[8] = 32'sd0;
        expected_features[8][0] = 32'd25600;
        expected_features[8][1] = 32'd0;
        expected_features[8][2] = 32'd0;
        expected_features[8][3] = 32'd0;
        expected_features[8][4] = 32'd25600000;
        expected_features[8][5] = 32'd12800000;
        expected_features[8][6] = 32'd0;
        expected_features[8][7] = 32'd0;
        expected_features[8][8] = 32'd0;
        expected_features[8][9] = 32'd0;
        expected_features[8][10] = 32'd0;
        expected_features[8][11] = 32'd256;
        expected_features[8][12] = 32'd0;
        expected_features[8][13] = 32'd0;
        expected_features[8][14] = 32'd0;
        expected_features[8][15] = 32'd0;
        expected_features[8][16] = 32'd0;
        expected_features[8][17] = 32'd0;
        expected_features[8][18] = 32'd0;
        expected_features[8][19] = 32'd0;
        expected_features[8][20] = 32'd256;
        expected_features[8][21] = 32'd256;
        expected_features[8][22] = 32'd0;
        expected_features[8][23] = 32'd0;
        expected_features[8][24] = 32'd256;
        expected_features[8][25] = 32'd256;
        expected_features[8][26] = 32'd0;
        expected_features[8][27] = 32'd0;

        // Test 9: Very small values
        test_names[9] = "Very small values";
        expected_attack[9] = 0;
        expected_major[9] = 32'sd174;
        expected_minor[9] = 32'sd0;
        expected_features[9][0] = 32'd0;
        expected_features[9][1] = 32'd0;
        expected_features[9][2] = 32'd0;
        expected_features[9][3] = 32'd0;
        expected_features[9][4] = 32'd0;
        expected_features[9][5] = 32'd0;
        expected_features[9][6] = 32'd0;
        expected_features[9][7] = 32'd0;
        expected_features[9][8] = 32'd0;
        expected_features[9][9] = 32'd0;
        expected_features[9][10] = 32'd0;
        expected_features[9][11] = 32'd0;
        expected_features[9][12] = 32'd0;
        expected_features[9][13] = 32'd0;
        expected_features[9][14] = 32'd0;
        expected_features[9][15] = 32'd0;
        expected_features[9][16] = 32'd0;
        expected_features[9][17] = 32'd0;
        expected_features[9][18] = 32'd0;
        expected_features[9][19] = 32'd0;
        expected_features[9][20] = 32'd0;
        expected_features[9][21] = 32'd0;
        expected_features[9][22] = 32'd0;
        expected_features[9][23] = 32'd0;
        expected_features[9][24] = 32'd0;
        expected_features[9][25] = 32'd0;
        expected_features[9][26] = 32'd0;
        expected_features[9][27] = 32'd0;

        // Test 10: Mixed high rate
        test_names[10] = "Mixed high rate";
        expected_attack[10] = 1;
        expected_major[10] = -32'sd590017551;
        expected_minor[10] = 32'sd0;
        expected_features[10][0] = 32'd512;
        expected_features[10][1] = 32'd0;
        expected_features[10][2] = 32'd0;
        expected_features[10][3] = 32'd0;
        expected_features[10][4] = 32'd1280000;
        expected_features[10][5] = 32'd640000;
        expected_features[10][6] = 32'd0;
        expected_features[10][7] = 32'd0;
        expected_features[10][8] = 32'd0;
        expected_features[10][9] = 32'd0;
        expected_features[10][10] = 32'd0;
        expected_features[10][11] = 32'd256;
        expected_features[10][12] = 32'd0;
        expected_features[10][13] = 32'd0;
        expected_features[10][14] = 32'd0;
        expected_features[10][15] = 32'd0;
        expected_features[10][16] = 32'd0;
        expected_features[10][17] = 32'd0;
        expected_features[10][18] = 32'd0;
        expected_features[10][19] = 32'd0;
        expected_features[10][20] = 32'd253;
        expected_features[10][21] = 32'd253;
        expected_features[10][22] = 32'd0;
        expected_features[10][23] = 32'd0;
        expected_features[10][24] = 32'd243;
        expected_features[10][25] = 32'd251;
        expected_features[10][26] = 32'd0;
        expected_features[10][27] = 32'd0;

        // Test 11: Alternating pattern
        test_names[11] = "Alternating pattern";
        expected_attack[11] = 1;
        expected_major[11] = 32'sd35826974;
        expected_minor[11] = 32'sd0;
        expected_features[11][0] = 32'd25600;
        expected_features[11][1] = 32'd0;
        expected_features[11][2] = 32'd25600;
        expected_features[11][3] = 32'd0;
        expected_features[11][4] = 32'd25600;
        expected_features[11][5] = 32'd0;
        expected_features[11][6] = 32'd25600;
        expected_features[11][7] = 32'd0;
        expected_features[11][8] = 32'd25600;
        expected_features[11][9] = 32'd0;
        expected_features[11][10] = 32'd25600;
        expected_features[11][11] = 32'd0;
        expected_features[11][12] = 32'd25600;
        expected_features[11][13] = 32'd0;
        expected_features[11][14] = 32'd25600;
        expected_features[11][15] = 32'd0;
        expected_features[11][16] = 32'd25600;
        expected_features[11][17] = 32'd0;
        expected_features[11][18] = 32'd25600;
        expected_features[11][19] = 32'd0;
        expected_features[11][20] = 32'd25600;
        expected_features[11][21] = 32'd0;
        expected_features[11][22] = 32'd25600;
        expected_features[11][23] = 32'd0;
        expected_features[11][24] = 32'd25600;
        expected_features[11][25] = 32'd0;
        expected_features[11][26] = 32'd25600;
        expected_features[11][27] = 32'd0;

        // Test 12: Gaussian normal
        test_names[12] = "Gaussian normal";
        expected_attack[12] = 1;
        expected_major[12] = 32'sd79991719;
        expected_minor[12] = 32'sd0;
        expected_features[12][0] = 32'd128;
        expected_features[12][1] = 32'd0;
        expected_features[12][2] = 32'd0;
        expected_features[12][3] = 32'd0;
        expected_features[12][4] = 32'd128000;
        expected_features[12][5] = 32'd64000;
        expected_features[12][6] = 32'd0;
        expected_features[12][7] = 32'd0;
        expected_features[12][8] = 32'd0;
        expected_features[12][9] = 32'd0;
        expected_features[12][10] = 32'd0;
        expected_features[12][11] = 32'd179;
        expected_features[12][12] = 32'd0;
        expected_features[12][13] = 32'd0;
        expected_features[12][14] = 32'd0;
        expected_features[12][15] = 32'd0;
        expected_features[12][16] = 32'd0;
        expected_features[12][17] = 32'd0;
        expected_features[12][18] = 32'd0;
        expected_features[12][19] = 32'd0;
        expected_features[12][20] = 32'd77;
        expected_features[12][21] = 32'd77;
        expected_features[12][22] = 32'd0;
        expected_features[12][23] = 32'd0;
        expected_features[12][24] = 32'd102;
        expected_features[12][25] = 32'd102;
        expected_features[12][26] = 32'd0;
        expected_features[12][27] = 32'd0;

        // Test 13: Random seed 100
        test_names[13] = "Random seed 100";
        expected_attack[13] = 1;
        expected_major[13] = 32'sd95153109;
        expected_minor[13] = 32'sd1;
        expected_features[13][0] = 32'd139;
        expected_features[13][1] = 32'd71;
        expected_features[13][2] = 32'd109;
        expected_features[13][3] = 32'd216;
        expected_features[13][4] = 32'd12080;
        expected_features[13][5] = 32'd155608;
        expected_features[13][6] = 32'd172;
        expected_features[13][7] = 32'd211;
        expected_features[13][8] = 32'd35;
        expected_features[13][9] = 32'd147;
        expected_features[13][10] = 32'd228;
        expected_features[13][11] = 32'd54;
        expected_features[13][12] = 32'd47;
        expected_features[13][13] = 32'd28;
        expected_features[13][14] = 32'd56;
        expected_features[13][15] = 32'd251;
        expected_features[13][16] = 32'd208;
        expected_features[13][17] = 32'd44;
        expected_features[13][18] = 32'd209;
        expected_features[13][19] = 32'd70;
        expected_features[13][20] = 32'd111;
        expected_features[13][21] = 32'd241;
        expected_features[13][22] = 32'd209;
        expected_features[13][23] = 32'd86;
        expected_features[13][24] = 32'd45;
        expected_features[13][25] = 32'd95;
        expected_features[13][26] = 32'd1;
        expected_features[13][27] = 32'd65;

        // Test 14: Random seed 101
        test_names[14] = "Random seed 101";
        expected_attack[14] = 1;
        expected_major[14] = -32'sd707655349;
        expected_minor[14] = 32'sd0;
        expected_features[14][0] = 32'd132;
        expected_features[14][1] = 32'd146;
        expected_features[14][2] = 32'd7;
        expected_features[14][3] = 32'd44;
        expected_features[14][4] = 32'd1754309;
        expected_features[14][5] = 32'd1067388;
        expected_features[14][6] = 32'd79;
        expected_features[14][7] = 32'd229;
        expected_features[14][8] = 32'd185;
        expected_features[14][9] = 32'd49;
        expected_features[14][10] = 32'd142;
        expected_features[14][11] = 32'd90;
        expected_features[14][12] = 32'd47;
        expected_features[14][13] = 32'd201;
        expected_features[14][14] = 32'd247;
        expected_features[14][15] = 32'd59;
        expected_features[14][16] = 32'd21;
        expected_features[14][17] = 32'd155;
        expected_features[14][18] = 32'd187;
        expected_features[14][19] = 32'd71;
        expected_features[14][20] = 32'd175;
        expected_features[14][21] = 32'd133;
        expected_features[14][22] = 32'd12;
        expected_features[14][23] = 32'd35;
        expected_features[14][24] = 32'd48;
        expected_features[14][25] = 32'd255;
        expected_features[14][26] = 32'd133;
        expected_features[14][27] = 32'd148;

        // Test 15: Random seed 102
        test_names[15] = "Random seed 102";
        expected_attack[15] = 1;
        expected_major[15] = -32'sd121693837;
        expected_minor[15] = 32'sd0;
        expected_features[15][0] = 32'd153;
        expected_features[15][1] = 32'd173;
        expected_features[15][2] = 32'd77;
        expected_features[15][3] = 32'd187;
        expected_features[15][4] = 32'd1481573;
        expected_features[15][5] = 32'd1035543;
        expected_features[15][6] = 32'd43;
        expected_features[15][7] = 32'd80;
        expected_features[15][8] = 32'd92;
        expected_features[15][9] = 32'd126;
        expected_features[15][10] = 32'd125;
        expected_features[15][11] = 32'd229;
        expected_features[15][12] = 32'd47;
        expected_features[15][13] = 32'd92;
        expected_features[15][14] = 32'd208;
        expected_features[15][15] = 32'd85;
        expected_features[15][16] = 32'd133;
        expected_features[15][17] = 32'd67;
        expected_features[15][18] = 32'd34;
        expected_features[15][19] = 32'd31;
        expected_features[15][20] = 32'd141;
        expected_features[15][21] = 32'd8;
        expected_features[15][22] = 32'd154;
        expected_features[15][23] = 32'd192;
        expected_features[15][24] = 32'd64;
        expected_features[15][25] = 32'd51;
        expected_features[15][26] = 32'd147;
        expected_features[15][27] = 32'd231;

        // Test 16: Random seed 103
        test_names[16] = "Random seed 103";
        expected_attack[16] = 1;
        expected_major[16] = 32'sd1586519039;
        expected_minor[16] = 32'sd0;
        expected_features[16][0] = 32'd111;
        expected_features[16][1] = 32'd45;
        expected_features[16][2] = 32'd44;
        expected_features[16][3] = 32'd212;
        expected_features[16][4] = 32'd1503158;
        expected_features[16][5] = 32'd587973;
        expected_features[16][6] = 32'd211;
        expected_features[16][7] = 32'd210;
        expected_features[16][8] = 32'd79;
        expected_features[16][9] = 32'd51;
        expected_features[16][10] = 32'd103;
        expected_features[16][11] = 32'd243;
        expected_features[16][12] = 32'd173;
        expected_features[16][13] = 32'd156;
        expected_features[16][14] = 32'd172;
        expected_features[16][15] = 32'd2;
        expected_features[16][16] = 32'd86;
        expected_features[16][17] = 32'd91;
        expected_features[16][18] = 32'd124;
        expected_features[16][19] = 32'd225;
        expected_features[16][20] = 32'd193;
        expected_features[16][21] = 32'd161;
        expected_features[16][22] = 32'd96;
        expected_features[16][23] = 32'd151;
        expected_features[16][24] = 32'd189;
        expected_features[16][25] = 32'd153;
        expected_features[16][26] = 32'd24;
        expected_features[16][27] = 32'd103;

        // Test 17: Random seed 104
        test_names[17] = "Random seed 104";
        expected_attack[17] = 1;
        expected_major[17] = 32'sd403508314;
        expected_minor[17] = 32'sd0;
        expected_features[17][0] = 32'd38;
        expected_features[17][1] = 32'd58;
        expected_features[17][2] = 32'd207;
        expected_features[17][3] = 32'd76;
        expected_features[17][4] = 32'd475409;
        expected_features[17][5] = 32'd988336;
        expected_features[17][6] = 32'd104;
        expected_features[17][7] = 32'd255;
        expected_features[17][8] = 32'd124;
        expected_features[17][9] = 32'd167;
        expected_features[17][10] = 32'd154;
        expected_features[17][11] = 32'd6;
        expected_features[17][12] = 32'd84;
        expected_features[17][13] = 32'd210;
        expected_features[17][14] = 32'd113;
        expected_features[17][15] = 32'd61;
        expected_features[17][16] = 32'd107;
        expected_features[17][17] = 32'd238;
        expected_features[17][18] = 32'd43;
        expected_features[17][19] = 32'd194;
        expected_features[17][20] = 32'd32;
        expected_features[17][21] = 32'd171;
        expected_features[17][22] = 32'd180;
        expected_features[17][23] = 32'd168;
        expected_features[17][24] = 32'd197;
        expected_features[17][25] = 32'd239;
        expected_features[17][26] = 32'd110;
        expected_features[17][27] = 32'd68;

        // Test 18: Port scan rate 0.5
        test_names[18] = "Port scan rate 0.5";
        expected_attack[18] = 1;
        expected_major[18] = 32'sd12796945;
        expected_minor[18] = 32'sd0;
        expected_features[18][0] = 32'd128;
        expected_features[18][1] = 32'd0;
        expected_features[18][2] = 32'd0;
        expected_features[18][3] = 32'd0;
        expected_features[18][4] = 32'd51200;
        expected_features[18][5] = 32'd25600;
        expected_features[18][6] = 32'd0;
        expected_features[18][7] = 32'd0;
        expected_features[18][8] = 32'd0;
        expected_features[18][9] = 32'd0;
        expected_features[18][10] = 32'd0;
        expected_features[18][11] = 32'd128;
        expected_features[18][12] = 32'd0;
        expected_features[18][13] = 32'd0;
        expected_features[18][14] = 32'd0;
        expected_features[18][15] = 32'd0;
        expected_features[18][16] = 32'd0;
        expected_features[18][17] = 32'd0;
        expected_features[18][18] = 32'd0;
        expected_features[18][19] = 32'd0;
        expected_features[18][20] = 32'd128;
        expected_features[18][21] = 32'd128;
        expected_features[18][22] = 32'd0;
        expected_features[18][23] = 32'd0;
        expected_features[18][24] = 32'd115;
        expected_features[18][25] = 32'd122;
        expected_features[18][26] = 32'd0;
        expected_features[18][27] = 32'd0;

        // Test 19: Port scan rate 0.6
        test_names[19] = "Port scan rate 0.6";
        expected_attack[19] = 1;
        expected_major[19] = 32'sd12797050;
        expected_minor[19] = 32'sd0;
        expected_features[19][0] = 32'd128;
        expected_features[19][1] = 32'd0;
        expected_features[19][2] = 32'd0;
        expected_features[19][3] = 32'd0;
        expected_features[19][4] = 32'd51200;
        expected_features[19][5] = 32'd25600;
        expected_features[19][6] = 32'd0;
        expected_features[19][7] = 32'd0;
        expected_features[19][8] = 32'd0;
        expected_features[19][9] = 32'd0;
        expected_features[19][10] = 32'd0;
        expected_features[19][11] = 32'd128;
        expected_features[19][12] = 32'd0;
        expected_features[19][13] = 32'd0;
        expected_features[19][14] = 32'd0;
        expected_features[19][15] = 32'd0;
        expected_features[19][16] = 32'd0;
        expected_features[19][17] = 32'd0;
        expected_features[19][18] = 32'd0;
        expected_features[19][19] = 32'd0;
        expected_features[19][20] = 32'd154;
        expected_features[19][21] = 32'd154;
        expected_features[19][22] = 32'd0;
        expected_features[19][23] = 32'd0;
        expected_features[19][24] = 32'd138;
        expected_features[19][25] = 32'd146;
        expected_features[19][26] = 32'd0;
        expected_features[19][27] = 32'd0;

        // Test 20: Port scan rate 0.7
        test_names[20] = "Port scan rate 0.7";
        expected_attack[20] = 1;
        expected_major[20] = 32'sd12797171;
        expected_minor[20] = 32'sd0;
        expected_features[20][0] = 32'd128;
        expected_features[20][1] = 32'd0;
        expected_features[20][2] = 32'd0;
        expected_features[20][3] = 32'd0;
        expected_features[20][4] = 32'd51200;
        expected_features[20][5] = 32'd25600;
        expected_features[20][6] = 32'd0;
        expected_features[20][7] = 32'd0;
        expected_features[20][8] = 32'd0;
        expected_features[20][9] = 32'd0;
        expected_features[20][10] = 32'd0;
        expected_features[20][11] = 32'd128;
        expected_features[20][12] = 32'd0;
        expected_features[20][13] = 32'd0;
        expected_features[20][14] = 32'd0;
        expected_features[20][15] = 32'd0;
        expected_features[20][16] = 32'd0;
        expected_features[20][17] = 32'd0;
        expected_features[20][18] = 32'd0;
        expected_features[20][19] = 32'd0;
        expected_features[20][20] = 32'd179;
        expected_features[20][21] = 32'd179;
        expected_features[20][22] = 32'd0;
        expected_features[20][23] = 32'd0;
        expected_features[20][24] = 32'd161;
        expected_features[20][25] = 32'd170;
        expected_features[20][26] = 32'd0;
        expected_features[20][27] = 32'd0;

        // Test 21: Port scan rate 0.85
        test_names[21] = "Port scan rate 0.85";
        expected_attack[21] = 1;
        expected_major[21] = 32'sd12797395;
        expected_minor[21] = 32'sd0;
        expected_features[21][0] = 32'd128;
        expected_features[21][1] = 32'd0;
        expected_features[21][2] = 32'd0;
        expected_features[21][3] = 32'd0;
        expected_features[21][4] = 32'd51200;
        expected_features[21][5] = 32'd25600;
        expected_features[21][6] = 32'd0;
        expected_features[21][7] = 32'd0;
        expected_features[21][8] = 32'd0;
        expected_features[21][9] = 32'd0;
        expected_features[21][10] = 32'd0;
        expected_features[21][11] = 32'd128;
        expected_features[21][12] = 32'd0;
        expected_features[21][13] = 32'd0;
        expected_features[21][14] = 32'd0;
        expected_features[21][15] = 32'd0;
        expected_features[21][16] = 32'd0;
        expected_features[21][17] = 32'd0;
        expected_features[21][18] = 32'd0;
        expected_features[21][19] = 32'd0;
        expected_features[21][20] = 32'd218;
        expected_features[21][21] = 32'd218;
        expected_features[21][22] = 32'd0;
        expected_features[21][23] = 32'd0;
        expected_features[21][24] = 32'd196;
        expected_features[21][25] = 32'd207;
        expected_features[21][26] = 32'd0;
        expected_features[21][27] = 32'd0;

        // Test 22: Port scan rate 0.95
        test_names[22] = "Port scan rate 0.95";
        expected_attack[22] = 1;
        expected_major[22] = 32'sd12797564;
        expected_minor[22] = 32'sd0;
        expected_features[22][0] = 32'd128;
        expected_features[22][1] = 32'd0;
        expected_features[22][2] = 32'd0;
        expected_features[22][3] = 32'd0;
        expected_features[22][4] = 32'd51200;
        expected_features[22][5] = 32'd25600;
        expected_features[22][6] = 32'd0;
        expected_features[22][7] = 32'd0;
        expected_features[22][8] = 32'd0;
        expected_features[22][9] = 32'd0;
        expected_features[22][10] = 32'd0;
        expected_features[22][11] = 32'd128;
        expected_features[22][12] = 32'd0;
        expected_features[22][13] = 32'd0;
        expected_features[22][14] = 32'd0;
        expected_features[22][15] = 32'd0;
        expected_features[22][16] = 32'd0;
        expected_features[22][17] = 32'd0;
        expected_features[22][18] = 32'd0;
        expected_features[22][19] = 32'd0;
        expected_features[22][20] = 32'd243;
        expected_features[22][21] = 32'd243;
        expected_features[22][22] = 32'd0;
        expected_features[22][23] = 32'd0;
        expected_features[22][24] = 32'd219;
        expected_features[22][25] = 32'd231;
        expected_features[22][26] = 32'd0;
        expected_features[22][27] = 32'd0;

        // Test 23: Bytes 100
        test_names[23] = "Bytes 100";
        expected_attack[23] = 1;
        expected_major[23] = 32'sd3198650;
        expected_minor[23] = 32'sd0;
        expected_features[23][0] = 32'd256;
        expected_features[23][1] = 32'd0;
        expected_features[23][2] = 32'd0;
        expected_features[23][3] = 32'd0;
        expected_features[23][4] = 32'd25600;
        expected_features[23][5] = 32'd12800;
        expected_features[23][6] = 32'd0;
        expected_features[23][7] = 32'd0;
        expected_features[23][8] = 32'd0;
        expected_features[23][9] = 32'd0;
        expected_features[23][10] = 32'd0;
        expected_features[23][11] = 32'd205;
        expected_features[23][12] = 32'd0;
        expected_features[23][13] = 32'd0;
        expected_features[23][14] = 32'd0;
        expected_features[23][15] = 32'd0;
        expected_features[23][16] = 32'd0;
        expected_features[23][17] = 32'd0;
        expected_features[23][18] = 32'd0;
        expected_features[23][19] = 32'd0;
        expected_features[23][20] = 32'd51;
        expected_features[23][21] = 32'd51;
        expected_features[23][22] = 32'd0;
        expected_features[23][23] = 32'd0;
        expected_features[23][24] = 32'd77;
        expected_features[23][25] = 32'd77;
        expected_features[23][26] = 32'd0;
        expected_features[23][27] = 32'd0;

        // Test 24: Bytes 1000
        test_names[24] = "Bytes 1000";
        expected_attack[24] = 1;
        expected_major[24] = 32'sd319983350;
        expected_minor[24] = 32'sd0;
        expected_features[24][0] = 32'd256;
        expected_features[24][1] = 32'd0;
        expected_features[24][2] = 32'd0;
        expected_features[24][3] = 32'd0;
        expected_features[24][4] = 32'd256000;
        expected_features[24][5] = 32'd128000;
        expected_features[24][6] = 32'd0;
        expected_features[24][7] = 32'd0;
        expected_features[24][8] = 32'd0;
        expected_features[24][9] = 32'd0;
        expected_features[24][10] = 32'd0;
        expected_features[24][11] = 32'd205;
        expected_features[24][12] = 32'd0;
        expected_features[24][13] = 32'd0;
        expected_features[24][14] = 32'd0;
        expected_features[24][15] = 32'd0;
        expected_features[24][16] = 32'd0;
        expected_features[24][17] = 32'd0;
        expected_features[24][18] = 32'd0;
        expected_features[24][19] = 32'd0;
        expected_features[24][20] = 32'd51;
        expected_features[24][21] = 32'd51;
        expected_features[24][22] = 32'd0;
        expected_features[24][23] = 32'd0;
        expected_features[24][24] = 32'd77;
        expected_features[24][25] = 32'd77;
        expected_features[24][26] = 32'd0;
        expected_features[24][27] = 32'd0;

        // Test 25: Bytes 5000
        test_names[25] = "Bytes 5000";
        expected_attack[25] = 1;
        expected_major[25] = -32'sd590019242;
        expected_minor[25] = 32'sd0;
        expected_features[25][0] = 32'd256;
        expected_features[25][1] = 32'd0;
        expected_features[25][2] = 32'd0;
        expected_features[25][3] = 32'd0;
        expected_features[25][4] = 32'd1280000;
        expected_features[25][5] = 32'd640000;
        expected_features[25][6] = 32'd0;
        expected_features[25][7] = 32'd0;
        expected_features[25][8] = 32'd0;
        expected_features[25][9] = 32'd0;
        expected_features[25][10] = 32'd0;
        expected_features[25][11] = 32'd205;
        expected_features[25][12] = 32'd0;
        expected_features[25][13] = 32'd0;
        expected_features[25][14] = 32'd0;
        expected_features[25][15] = 32'd0;
        expected_features[25][16] = 32'd0;
        expected_features[25][17] = 32'd0;
        expected_features[25][18] = 32'd0;
        expected_features[25][19] = 32'd0;
        expected_features[25][20] = 32'd51;
        expected_features[25][21] = 32'd51;
        expected_features[25][22] = 32'd0;
        expected_features[25][23] = 32'd0;
        expected_features[25][24] = 32'd77;
        expected_features[25][25] = 32'd77;
        expected_features[25][26] = 32'd0;
        expected_features[25][27] = 32'd0;

        // Test 26: Bytes 20000
        test_names[26] = "Bytes 20000";
        expected_attack[26] = 1;
        expected_major[26] = -32'sd849358530;
        expected_minor[26] = 32'sd0;
        expected_features[26][0] = 32'd256;
        expected_features[26][1] = 32'd0;
        expected_features[26][2] = 32'd0;
        expected_features[26][3] = 32'd0;
        expected_features[26][4] = 32'd5120000;
        expected_features[26][5] = 32'd2560000;
        expected_features[26][6] = 32'd0;
        expected_features[26][7] = 32'd0;
        expected_features[26][8] = 32'd0;
        expected_features[26][9] = 32'd0;
        expected_features[26][10] = 32'd0;
        expected_features[26][11] = 32'd205;
        expected_features[26][12] = 32'd0;
        expected_features[26][13] = 32'd0;
        expected_features[26][14] = 32'd0;
        expected_features[26][15] = 32'd0;
        expected_features[26][16] = 32'd0;
        expected_features[26][17] = 32'd0;
        expected_features[26][18] = 32'd0;
        expected_features[26][19] = 32'd0;
        expected_features[26][20] = 32'd51;
        expected_features[26][21] = 32'd51;
        expected_features[26][22] = 32'd0;
        expected_features[26][23] = 32'd0;
        expected_features[26][24] = 32'd77;
        expected_features[26][25] = 32'd77;
        expected_features[26][26] = 32'd0;
        expected_features[26][27] = 32'd0;

        // Test 27: Bytes 80000
        test_names[27] = "Bytes 80000";
        expected_attack[27] = 1;
        expected_major[27] = -32'sd700759842;
        expected_minor[27] = 32'sd0;
        expected_features[27][0] = 32'd256;
        expected_features[27][1] = 32'd0;
        expected_features[27][2] = 32'd0;
        expected_features[27][3] = 32'd0;
        expected_features[27][4] = 32'd20480000;
        expected_features[27][5] = 32'd10240000;
        expected_features[27][6] = 32'd0;
        expected_features[27][7] = 32'd0;
        expected_features[27][8] = 32'd0;
        expected_features[27][9] = 32'd0;
        expected_features[27][10] = 32'd0;
        expected_features[27][11] = 32'd205;
        expected_features[27][12] = 32'd0;
        expected_features[27][13] = 32'd0;
        expected_features[27][14] = 32'd0;
        expected_features[27][15] = 32'd0;
        expected_features[27][16] = 32'd0;
        expected_features[27][17] = 32'd0;
        expected_features[27][18] = 32'd0;
        expected_features[27][19] = 32'd0;
        expected_features[27][20] = 32'd51;
        expected_features[27][21] = 32'd51;
        expected_features[27][22] = 32'd0;
        expected_features[27][23] = 32'd0;
        expected_features[27][24] = 32'd77;
        expected_features[27][25] = 32'd77;
        expected_features[27][26] = 32'd0;
        expected_features[27][27] = 32'd0;

        // Test 28: Failed logins 1
        test_names[28] = "Failed logins 1";
        expected_attack[28] = 1;
        expected_major[28] = 32'sd7204404;
        expected_minor[28] = 32'sd0;
        expected_features[28][0] = 32'd1280;
        expected_features[28][1] = 32'd0;
        expected_features[28][2] = 32'd0;
        expected_features[28][3] = 32'd0;
        expected_features[28][4] = 32'd38400;
        expected_features[28][5] = 32'd19200;
        expected_features[28][6] = 32'd0;
        expected_features[28][7] = 32'd0;
        expected_features[28][8] = 32'd0;
        expected_features[28][9] = 32'd256;
        expected_features[28][10] = 32'd0;
        expected_features[28][11] = 32'd256;
        expected_features[28][12] = 32'd256;
        expected_features[28][13] = 32'd0;
        expected_features[28][14] = 32'd0;
        expected_features[28][15] = 32'd0;
        expected_features[28][16] = 32'd0;
        expected_features[28][17] = 32'd0;
        expected_features[28][18] = 32'd0;
        expected_features[28][19] = 32'd0;
        expected_features[28][20] = 32'd0;
        expected_features[28][21] = 32'd0;
        expected_features[28][22] = 32'd0;
        expected_features[28][23] = 32'd0;
        expected_features[28][24] = 32'd0;
        expected_features[28][25] = 32'd0;
        expected_features[28][26] = 32'd0;
        expected_features[28][27] = 32'd0;

        // Test 29: Failed logins 3
        test_names[29] = "Failed logins 3";
        expected_attack[29] = 1;
        expected_major[29] = 32'sd7208500;
        expected_minor[29] = 32'sd2;
        expected_features[29][0] = 32'd1280;
        expected_features[29][1] = 32'd0;
        expected_features[29][2] = 32'd0;
        expected_features[29][3] = 32'd0;
        expected_features[29][4] = 32'd38400;
        expected_features[29][5] = 32'd19200;
        expected_features[29][6] = 32'd0;
        expected_features[29][7] = 32'd0;
        expected_features[29][8] = 32'd0;
        expected_features[29][9] = 32'd768;
        expected_features[29][10] = 32'd0;
        expected_features[29][11] = 32'd256;
        expected_features[29][12] = 32'd768;
        expected_features[29][13] = 32'd0;
        expected_features[29][14] = 32'd0;
        expected_features[29][15] = 32'd0;
        expected_features[29][16] = 32'd0;
        expected_features[29][17] = 32'd0;
        expected_features[29][18] = 32'd0;
        expected_features[29][19] = 32'd0;
        expected_features[29][20] = 32'd0;
        expected_features[29][21] = 32'd0;
        expected_features[29][22] = 32'd0;
        expected_features[29][23] = 32'd0;
        expected_features[29][24] = 32'd0;
        expected_features[29][25] = 32'd0;
        expected_features[29][26] = 32'd0;
        expected_features[29][27] = 32'd0;

        // Test 30: Failed logins 5
        test_names[30] = "Failed logins 5";
        expected_attack[30] = 1;
        expected_major[30] = 32'sd7216692;
        expected_minor[30] = 32'sd7;
        expected_features[30][0] = 32'd1280;
        expected_features[30][1] = 32'd0;
        expected_features[30][2] = 32'd0;
        expected_features[30][3] = 32'd0;
        expected_features[30][4] = 32'd38400;
        expected_features[30][5] = 32'd19200;
        expected_features[30][6] = 32'd0;
        expected_features[30][7] = 32'd0;
        expected_features[30][8] = 32'd0;
        expected_features[30][9] = 32'd1280;
        expected_features[30][10] = 32'd0;
        expected_features[30][11] = 32'd256;
        expected_features[30][12] = 32'd1280;
        expected_features[30][13] = 32'd0;
        expected_features[30][14] = 32'd0;
        expected_features[30][15] = 32'd0;
        expected_features[30][16] = 32'd0;
        expected_features[30][17] = 32'd0;
        expected_features[30][18] = 32'd0;
        expected_features[30][19] = 32'd0;
        expected_features[30][20] = 32'd0;
        expected_features[30][21] = 32'd0;
        expected_features[30][22] = 32'd0;
        expected_features[30][23] = 32'd0;
        expected_features[30][24] = 32'd0;
        expected_features[30][25] = 32'd0;
        expected_features[30][26] = 32'd0;
        expected_features[30][27] = 32'd0;

        // Test 31: Failed logins 10
        test_names[31] = "Failed logins 10";
        expected_attack[31] = 1;
        expected_major[31] = 32'sd7255224;
        expected_minor[31] = 32'sd30;
        expected_features[31][0] = 32'd1280;
        expected_features[31][1] = 32'd0;
        expected_features[31][2] = 32'd0;
        expected_features[31][3] = 32'd0;
        expected_features[31][4] = 32'd38400;
        expected_features[31][5] = 32'd19200;
        expected_features[31][6] = 32'd0;
        expected_features[31][7] = 32'd0;
        expected_features[31][8] = 32'd0;
        expected_features[31][9] = 32'd2560;
        expected_features[31][10] = 32'd0;
        expected_features[31][11] = 32'd0;
        expected_features[31][12] = 32'd2560;
        expected_features[31][13] = 32'd0;
        expected_features[31][14] = 32'd0;
        expected_features[31][15] = 32'd0;
        expected_features[31][16] = 32'd0;
        expected_features[31][17] = 32'd0;
        expected_features[31][18] = 32'd0;
        expected_features[31][19] = 32'd0;
        expected_features[31][20] = 32'd0;
        expected_features[31][21] = 32'd0;
        expected_features[31][22] = 32'd0;
        expected_features[31][23] = 32'd0;
        expected_features[31][24] = 32'd0;
        expected_features[31][25] = 32'd0;
        expected_features[31][26] = 32'd0;
        expected_features[31][27] = 32'd0;

        // Test 32: Failed logins 20
        test_names[32] = "Failed logins 20";
        expected_attack[32] = 1;
        expected_major[32] = 32'sd7408824;
        expected_minor[32] = 32'sd125;
        expected_features[32][0] = 32'd1280;
        expected_features[32][1] = 32'd0;
        expected_features[32][2] = 32'd0;
        expected_features[32][3] = 32'd0;
        expected_features[32][4] = 32'd38400;
        expected_features[32][5] = 32'd19200;
        expected_features[32][6] = 32'd0;
        expected_features[32][7] = 32'd0;
        expected_features[32][8] = 32'd0;
        expected_features[32][9] = 32'd5120;
        expected_features[32][10] = 32'd0;
        expected_features[32][11] = 32'd0;
        expected_features[32][12] = 32'd5120;
        expected_features[32][13] = 32'd0;
        expected_features[32][14] = 32'd0;
        expected_features[32][15] = 32'd0;
        expected_features[32][16] = 32'd0;
        expected_features[32][17] = 32'd0;
        expected_features[32][18] = 32'd0;
        expected_features[32][19] = 32'd0;
        expected_features[32][20] = 32'd0;
        expected_features[32][21] = 32'd0;
        expected_features[32][22] = 32'd0;
        expected_features[32][23] = 32'd0;
        expected_features[32][24] = 32'd0;
        expected_features[32][25] = 32'd0;
        expected_features[32][26] = 32'd0;
        expected_features[32][27] = 32'd0;

        // Test 33: Normal traffic 1
        test_names[33] = "Normal traffic 1";
        expected_attack[33] = 0;
        expected_major[33] = 32'sd174;
        expected_minor[33] = 32'sd0;
        expected_features[33][0] = 32'd0;
        expected_features[33][1] = 32'd0;
        expected_features[33][2] = 32'd0;
        expected_features[33][3] = 32'd0;
        expected_features[33][4] = 32'd0;
        expected_features[33][5] = 32'd1;
        expected_features[33][6] = 32'd0;
        expected_features[33][7] = 32'd0;
        expected_features[33][8] = 32'd0;
        expected_features[33][9] = 32'd0;
        expected_features[33][10] = 32'd0;
        expected_features[33][11] = 32'd0;
        expected_features[33][12] = 32'd0;
        expected_features[33][13] = 32'd0;
        expected_features[33][14] = 32'd0;
        expected_features[33][15] = 32'd0;
        expected_features[33][16] = 32'd0;
        expected_features[33][17] = 32'd0;
        expected_features[33][18] = 32'd0;
        expected_features[33][19] = 32'd0;
        expected_features[33][20] = 32'd0;
        expected_features[33][21] = 32'd0;
        expected_features[33][22] = 32'd0;
        expected_features[33][23] = 32'd0;
        expected_features[33][24] = 32'd0;
        expected_features[33][25] = 32'd0;
        expected_features[33][26] = 32'd0;
        expected_features[33][27] = 32'd0;

        // Test 34: Normal traffic 2
        test_names[34] = "Normal traffic 2";
        expected_attack[34] = 0;
        expected_major[34] = 32'sd174;
        expected_minor[34] = 32'sd0;
        expected_features[34][0] = 32'd0;
        expected_features[34][1] = 32'd0;
        expected_features[34][2] = 32'd0;
        expected_features[34][3] = 32'd0;
        expected_features[34][4] = 32'd9;
        expected_features[34][5] = 32'd4;
        expected_features[34][6] = 32'd0;
        expected_features[34][7] = 32'd0;
        expected_features[34][8] = 32'd0;
        expected_features[34][9] = 32'd0;
        expected_features[34][10] = 32'd0;
        expected_features[34][11] = 32'd0;
        expected_features[34][12] = 32'd0;
        expected_features[34][13] = 32'd0;
        expected_features[34][14] = 32'd0;
        expected_features[34][15] = 32'd0;
        expected_features[34][16] = 32'd0;
        expected_features[34][17] = 32'd0;
        expected_features[34][18] = 32'd0;
        expected_features[34][19] = 32'd0;
        expected_features[34][20] = 32'd0;
        expected_features[34][21] = 32'd0;
        expected_features[34][22] = 32'd0;
        expected_features[34][23] = 32'd0;
        expected_features[34][24] = 32'd0;
        expected_features[34][25] = 32'd0;
        expected_features[34][26] = 32'd0;
        expected_features[34][27] = 32'd0;

        // Test 35: Normal traffic 3
        test_names[35] = "Normal traffic 3";
        expected_attack[35] = 0;
        expected_major[35] = 32'sd174;
        expected_minor[35] = 32'sd0;
        expected_features[35][0] = 32'd0;
        expected_features[35][1] = 32'd0;
        expected_features[35][2] = 32'd0;
        expected_features[35][3] = 32'd0;
        expected_features[35][4] = 32'd7;
        expected_features[35][5] = 32'd4;
        expected_features[35][6] = 32'd0;
        expected_features[35][7] = 32'd0;
        expected_features[35][8] = 32'd0;
        expected_features[35][9] = 32'd0;
        expected_features[35][10] = 32'd0;
        expected_features[35][11] = 32'd0;
        expected_features[35][12] = 32'd0;
        expected_features[35][13] = 32'd0;
        expected_features[35][14] = 32'd0;
        expected_features[35][15] = 32'd0;
        expected_features[35][16] = 32'd0;
        expected_features[35][17] = 32'd0;
        expected_features[35][18] = 32'd0;
        expected_features[35][19] = 32'd0;
        expected_features[35][20] = 32'd0;
        expected_features[35][21] = 32'd0;
        expected_features[35][22] = 32'd0;
        expected_features[35][23] = 32'd0;
        expected_features[35][24] = 32'd0;
        expected_features[35][25] = 32'd0;
        expected_features[35][26] = 32'd0;
        expected_features[35][27] = 32'd0;

        // Test 36: Normal traffic 4
        test_names[36] = "Normal traffic 4";
        expected_attack[36] = 0;
        expected_major[36] = 32'sd174;
        expected_minor[36] = 32'sd0;
        expected_features[36][0] = 32'd0;
        expected_features[36][1] = 32'd0;
        expected_features[36][2] = 32'd0;
        expected_features[36][3] = 32'd0;
        expected_features[36][4] = 32'd8;
        expected_features[36][5] = 32'd2;
        expected_features[36][6] = 32'd0;
        expected_features[36][7] = 32'd0;
        expected_features[36][8] = 32'd0;
        expected_features[36][9] = 32'd0;
        expected_features[36][10] = 32'd0;
        expected_features[36][11] = 32'd0;
        expected_features[36][12] = 32'd0;
        expected_features[36][13] = 32'd0;
        expected_features[36][14] = 32'd0;
        expected_features[36][15] = 32'd0;
        expected_features[36][16] = 32'd0;
        expected_features[36][17] = 32'd0;
        expected_features[36][18] = 32'd0;
        expected_features[36][19] = 32'd0;
        expected_features[36][20] = 32'd0;
        expected_features[36][21] = 32'd0;
        expected_features[36][22] = 32'd0;
        expected_features[36][23] = 32'd0;
        expected_features[36][24] = 32'd0;
        expected_features[36][25] = 32'd0;
        expected_features[36][26] = 32'd0;
        expected_features[36][27] = 32'd0;

        // Test 37: Normal traffic 5
        test_names[37] = "Normal traffic 5";
        expected_attack[37] = 0;
        expected_major[37] = 32'sd174;
        expected_minor[37] = 32'sd0;
        expected_features[37][0] = 32'd0;
        expected_features[37][1] = 32'd0;
        expected_features[37][2] = 32'd0;
        expected_features[37][3] = 32'd0;
        expected_features[37][4] = 32'd2;
        expected_features[37][5] = 32'd4;
        expected_features[37][6] = 32'd0;
        expected_features[37][7] = 32'd0;
        expected_features[37][8] = 32'd0;
        expected_features[37][9] = 32'd0;
        expected_features[37][10] = 32'd0;
        expected_features[37][11] = 32'd0;
        expected_features[37][12] = 32'd0;
        expected_features[37][13] = 32'd0;
        expected_features[37][14] = 32'd0;
        expected_features[37][15] = 32'd0;
        expected_features[37][16] = 32'd0;
        expected_features[37][17] = 32'd0;
        expected_features[37][18] = 32'd0;
        expected_features[37][19] = 32'd0;
        expected_features[37][20] = 32'd0;
        expected_features[37][21] = 32'd0;
        expected_features[37][22] = 32'd0;
        expected_features[37][23] = 32'd0;
        expected_features[37][24] = 32'd0;
        expected_features[37][25] = 32'd0;
        expected_features[37][26] = 32'd0;
        expected_features[37][27] = 32'd0;

        // Test 38: Normal traffic 6
        test_names[38] = "Normal traffic 6";
        expected_attack[38] = 0;
        expected_major[38] = 32'sd174;
        expected_minor[38] = 32'sd0;
        expected_features[38][0] = 32'd0;
        expected_features[38][1] = 32'd0;
        expected_features[38][2] = 32'd0;
        expected_features[38][3] = 32'd0;
        expected_features[38][4] = 32'd7;
        expected_features[38][5] = 32'd0;
        expected_features[38][6] = 32'd0;
        expected_features[38][7] = 32'd0;
        expected_features[38][8] = 32'd0;
        expected_features[38][9] = 32'd0;
        expected_features[38][10] = 32'd0;
        expected_features[38][11] = 32'd0;
        expected_features[38][12] = 32'd0;
        expected_features[38][13] = 32'd0;
        expected_features[38][14] = 32'd0;
        expected_features[38][15] = 32'd0;
        expected_features[38][16] = 32'd0;
        expected_features[38][17] = 32'd0;
        expected_features[38][18] = 32'd0;
        expected_features[38][19] = 32'd0;
        expected_features[38][20] = 32'd0;
        expected_features[38][21] = 32'd0;
        expected_features[38][22] = 32'd0;
        expected_features[38][23] = 32'd0;
        expected_features[38][24] = 32'd0;
        expected_features[38][25] = 32'd0;
        expected_features[38][26] = 32'd0;
        expected_features[38][27] = 32'd0;

        // Test 39: Normal traffic 7
        test_names[39] = "Normal traffic 7";
        expected_attack[39] = 0;
        expected_major[39] = 32'sd174;
        expected_minor[39] = 32'sd0;
        expected_features[39][0] = 32'd0;
        expected_features[39][1] = 32'd0;
        expected_features[39][2] = 32'd0;
        expected_features[39][3] = 32'd0;
        expected_features[39][4] = 32'd11;
        expected_features[39][5] = 32'd4;
        expected_features[39][6] = 32'd0;
        expected_features[39][7] = 32'd0;
        expected_features[39][8] = 32'd0;
        expected_features[39][9] = 32'd0;
        expected_features[39][10] = 32'd0;
        expected_features[39][11] = 32'd0;
        expected_features[39][12] = 32'd0;
        expected_features[39][13] = 32'd0;
        expected_features[39][14] = 32'd0;
        expected_features[39][15] = 32'd0;
        expected_features[39][16] = 32'd0;
        expected_features[39][17] = 32'd0;
        expected_features[39][18] = 32'd0;
        expected_features[39][19] = 32'd0;
        expected_features[39][20] = 32'd0;
        expected_features[39][21] = 32'd0;
        expected_features[39][22] = 32'd0;
        expected_features[39][23] = 32'd0;
        expected_features[39][24] = 32'd0;
        expected_features[39][25] = 32'd0;
        expected_features[39][26] = 32'd0;
        expected_features[39][27] = 32'd0;

        // Test 40: Normal traffic 8
        test_names[40] = "Normal traffic 8";
        expected_attack[40] = 0;
        expected_major[40] = 32'sd174;
        expected_minor[40] = 32'sd0;
        expected_features[40][0] = 32'd0;
        expected_features[40][1] = 32'd0;
        expected_features[40][2] = 32'd0;
        expected_features[40][3] = 32'd0;
        expected_features[40][4] = 32'd4;
        expected_features[40][5] = 32'd1;
        expected_features[40][6] = 32'd0;
        expected_features[40][7] = 32'd0;
        expected_features[40][8] = 32'd0;
        expected_features[40][9] = 32'd0;
        expected_features[40][10] = 32'd0;
        expected_features[40][11] = 32'd0;
        expected_features[40][12] = 32'd0;
        expected_features[40][13] = 32'd0;
        expected_features[40][14] = 32'd0;
        expected_features[40][15] = 32'd0;
        expected_features[40][16] = 32'd0;
        expected_features[40][17] = 32'd0;
        expected_features[40][18] = 32'd0;
        expected_features[40][19] = 32'd0;
        expected_features[40][20] = 32'd0;
        expected_features[40][21] = 32'd0;
        expected_features[40][22] = 32'd0;
        expected_features[40][23] = 32'd0;
        expected_features[40][24] = 32'd0;
        expected_features[40][25] = 32'd0;
        expected_features[40][26] = 32'd0;
        expected_features[40][27] = 32'd0;

        // Test 41: Normal traffic 9
        test_names[41] = "Normal traffic 9";
        expected_attack[41] = 0;
        expected_major[41] = 32'sd174;
        expected_minor[41] = 32'sd0;
        expected_features[41][0] = 32'd0;
        expected_features[41][1] = 32'd0;
        expected_features[41][2] = 32'd0;
        expected_features[41][3] = 32'd0;
        expected_features[41][4] = 32'd9;
        expected_features[41][5] = 32'd4;
        expected_features[41][6] = 32'd0;
        expected_features[41][7] = 32'd0;
        expected_features[41][8] = 32'd0;
        expected_features[41][9] = 32'd0;
        expected_features[41][10] = 32'd0;
        expected_features[41][11] = 32'd0;
        expected_features[41][12] = 32'd0;
        expected_features[41][13] = 32'd0;
        expected_features[41][14] = 32'd0;
        expected_features[41][15] = 32'd0;
        expected_features[41][16] = 32'd0;
        expected_features[41][17] = 32'd0;
        expected_features[41][18] = 32'd0;
        expected_features[41][19] = 32'd0;
        expected_features[41][20] = 32'd0;
        expected_features[41][21] = 32'd0;
        expected_features[41][22] = 32'd0;
        expected_features[41][23] = 32'd0;
        expected_features[41][24] = 32'd0;
        expected_features[41][25] = 32'd0;
        expected_features[41][26] = 32'd0;
        expected_features[41][27] = 32'd0;

        // Test 42: Normal traffic 10
        test_names[42] = "Normal traffic 10";
        expected_attack[42] = 0;
        expected_major[42] = 32'sd174;
        expected_minor[42] = 32'sd0;
        expected_features[42][0] = 32'd0;
        expected_features[42][1] = 32'd0;
        expected_features[42][2] = 32'd0;
        expected_features[42][3] = 32'd0;
        expected_features[42][4] = 32'd10;
        expected_features[42][5] = 32'd4;
        expected_features[42][6] = 32'd0;
        expected_features[42][7] = 32'd0;
        expected_features[42][8] = 32'd0;
        expected_features[42][9] = 32'd0;
        expected_features[42][10] = 32'd0;
        expected_features[42][11] = 32'd0;
        expected_features[42][12] = 32'd0;
        expected_features[42][13] = 32'd0;
        expected_features[42][14] = 32'd0;
        expected_features[42][15] = 32'd0;
        expected_features[42][16] = 32'd0;
        expected_features[42][17] = 32'd0;
        expected_features[42][18] = 32'd0;
        expected_features[42][19] = 32'd0;
        expected_features[42][20] = 32'd0;
        expected_features[42][21] = 32'd0;
        expected_features[42][22] = 32'd0;
        expected_features[42][23] = 32'd0;
        expected_features[42][24] = 32'd0;
        expected_features[42][25] = 32'd0;
        expected_features[42][26] = 32'd0;
        expected_features[42][27] = 32'd0;

        // Test 43: Attack pattern 1
        test_names[43] = "Attack pattern 1";
        expected_attack[43] = 1;
        expected_major[43] = 32'sd72801;
        expected_minor[43] = 32'sd0;
        expected_features[43][0] = 32'd492;
        expected_features[43][1] = 32'd29;
        expected_features[43][2] = 32'd76;
        expected_features[43][3] = 32'd55;
        expected_features[43][4] = 32'd4214;
        expected_features[43][5] = 32'd518;
        expected_features[43][6] = 32'd46;
        expected_features[43][7] = 32'd116;
        expected_features[43][8] = 32'd58;
        expected_features[43][9] = 32'd126;
        expected_features[43][10] = 32'd111;
        expected_features[43][11] = 32'd126;
        expected_features[43][12] = 32'd118;
        expected_features[43][13] = 32'd39;
        expected_features[43][14] = 32'd108;
        expected_features[43][15] = 32'd16;
        expected_features[43][16] = 32'd101;
        expected_features[43][17] = 32'd32;
        expected_features[43][18] = 32'd12;
        expected_features[43][19] = 32'd121;
        expected_features[43][20] = 32'd106;
        expected_features[43][21] = 32'd219;
        expected_features[43][22] = 32'd246;
        expected_features[43][23] = 32'd224;
        expected_features[43][24] = 32'd214;
        expected_features[43][25] = 32'd231;
        expected_features[43][26] = 32'd211;
        expected_features[43][27] = 32'd228;

        // Test 44: Attack pattern 2
        test_names[44] = "Attack pattern 2";
        expected_attack[44] = 1;
        expected_major[44] = 32'sd67068;
        expected_minor[44] = 32'sd0;
        expected_features[44][0] = 32'd172;
        expected_features[44][1] = 32'd96;
        expected_features[44][2] = 32'd78;
        expected_features[44][3] = 32'd104;
        expected_features[44][4] = 32'd4017;
        expected_features[44][5] = 32'd799;
        expected_features[44][6] = 32'd34;
        expected_features[44][7] = 32'd19;
        expected_features[44][8] = 32'd29;
        expected_features[44][9] = 32'd30;
        expected_features[44][10] = 32'd88;
        expected_features[44][11] = 32'd19;
        expected_features[44][12] = 32'd57;
        expected_features[44][13] = 32'd90;
        expected_features[44][14] = 32'd12;
        expected_features[44][15] = 32'd113;
        expected_features[44][16] = 32'd111;
        expected_features[44][17] = 32'd108;
        expected_features[44][18] = 32'd35;
        expected_features[44][19] = 32'd101;
        expected_features[44][20] = 32'd90;
        expected_features[44][21] = 32'd217;
        expected_features[44][22] = 32'd243;
        expected_features[44][23] = 32'd210;
        expected_features[44][24] = 32'd193;
        expected_features[44][25] = 32'd207;
        expected_features[44][26] = 32'd256;
        expected_features[44][27] = 32'd205;

        // Test 45: Attack pattern 3
        test_names[45] = "Attack pattern 3";
        expected_attack[45] = 1;
        expected_major[45] = 32'sd114167;
        expected_minor[45] = 32'sd0;
        expected_features[45][0] = 32'd214;
        expected_features[45][1] = 32'd34;
        expected_features[45][2] = 32'd125;
        expected_features[45][3] = 32'd127;
        expected_features[45][4] = 32'd5101;
        expected_features[45][5] = 32'd1682;
        expected_features[45][6] = 32'd77;
        expected_features[45][7] = 32'd15;
        expected_features[45][8] = 32'd104;
        expected_features[45][9] = 32'd30;
        expected_features[45][10] = 32'd127;
        expected_features[45][11] = 32'd71;
        expected_features[45][12] = 32'd56;
        expected_features[45][13] = 32'd11;
        expected_features[45][14] = 32'd56;
        expected_features[45][15] = 32'd112;
        expected_features[45][16] = 32'd53;
        expected_features[45][17] = 32'd95;
        expected_features[45][18] = 32'd28;
        expected_features[45][19] = 32'd112;
        expected_features[45][20] = 32'd71;
        expected_features[45][21] = 32'd194;
        expected_features[45][22] = 32'd212;
        expected_features[45][23] = 32'd237;
        expected_features[45][24] = 32'd215;
        expected_features[45][25] = 32'd201;
        expected_features[45][26] = 32'd247;
        expected_features[45][27] = 32'd206;

        // Test 46: Attack pattern 4
        test_names[46] = "Attack pattern 4";
        expected_attack[46] = 1;
        expected_major[46] = 32'sd103353;
        expected_minor[46] = 32'sd1;
        expected_features[46][0] = 32'd454;
        expected_features[46][1] = 32'd24;
        expected_features[46][2] = 32'd58;
        expected_features[46][3] = 32'd80;
        expected_features[46][4] = 32'd5004;
        expected_features[46][5] = 32'd938;
        expected_features[46][6] = 32'd76;
        expected_features[46][7] = 32'd117;
        expected_features[46][8] = 32'd31;
        expected_features[46][9] = 32'd99;
        expected_features[46][10] = 32'd81;
        expected_features[46][11] = 32'd101;
        expected_features[46][12] = 32'd113;
        expected_features[46][13] = 32'd47;
        expected_features[46][14] = 32'd76;
        expected_features[46][15] = 32'd65;
        expected_features[46][16] = 32'd80;
        expected_features[46][17] = 32'd84;
        expected_features[46][18] = 32'd2;
        expected_features[46][19] = 32'd67;
        expected_features[46][20] = 32'd89;
        expected_features[46][21] = 32'd250;
        expected_features[46][22] = 32'd215;
        expected_features[46][23] = 32'd199;
        expected_features[46][24] = 32'd190;
        expected_features[46][25] = 32'd254;
        expected_features[46][26] = 32'd247;
        expected_features[46][27] = 32'd185;

        // Test 47: Attack pattern 5
        test_names[47] = "Attack pattern 5";
        expected_attack[47] = 1;
        expected_major[47] = 32'sd105964;
        expected_minor[47] = 32'sd0;
        expected_features[47][0] = 32'd485;
        expected_features[47][1] = 32'd49;
        expected_features[47][2] = 32'd85;
        expected_features[47][3] = 32'd128;
        expected_features[47][4] = 32'd4710;
        expected_features[47][5] = 32'd2087;
        expected_features[47][6] = 32'd49;
        expected_features[47][7] = 32'd78;
        expected_features[47][8] = 32'd34;
        expected_features[47][9] = 32'd63;
        expected_features[47][10] = 32'd33;
        expected_features[47][11] = 32'd31;
        expected_features[47][12] = 32'd115;
        expected_features[47][13] = 32'd81;
        expected_features[47][14] = 32'd20;
        expected_features[47][15] = 32'd22;
        expected_features[47][16] = 32'd81;
        expected_features[47][17] = 32'd31;
        expected_features[47][18] = 32'd125;
        expected_features[47][19] = 32'd70;
        expected_features[47][20] = 32'd111;
        expected_features[47][21] = 32'd222;
        expected_features[47][22] = 32'd203;
        expected_features[47][23] = 32'd211;
        expected_features[47][24] = 32'd229;
        expected_features[47][25] = 32'd250;
        expected_features[47][26] = 32'd180;
        expected_features[47][27] = 32'd250;

        // Test 48: Attack pattern 6
        test_names[48] = "Attack pattern 6";
        expected_attack[48] = 1;
        expected_major[48] = 32'sd102110;
        expected_minor[48] = 32'sd0;
        expected_features[48][0] = 32'd497;
        expected_features[48][1] = 32'd72;
        expected_features[48][2] = 32'd127;
        expected_features[48][3] = 32'd105;
        expected_features[48][4] = 32'd4862;
        expected_features[48][5] = 32'd1387;
        expected_features[48][6] = 32'd35;
        expected_features[48][7] = 32'd81;
        expected_features[48][8] = 32'd112;
        expected_features[48][9] = 32'd40;
        expected_features[48][10] = 32'd51;
        expected_features[48][11] = 32'd86;
        expected_features[48][12] = 32'd6;
        expected_features[48][13] = 32'd89;
        expected_features[48][14] = 32'd37;
        expected_features[48][15] = 32'd16;
        expected_features[48][16] = 32'd13;
        expected_features[48][17] = 32'd86;
        expected_features[48][18] = 32'd34;
        expected_features[48][19] = 32'd3;
        expected_features[48][20] = 32'd106;
        expected_features[48][21] = 32'd217;
        expected_features[48][22] = 32'd237;
        expected_features[48][23] = 32'd247;
        expected_features[48][24] = 32'd244;
        expected_features[48][25] = 32'd202;
        expected_features[48][26] = 32'd196;
        expected_features[48][27] = 32'd238;

        // Test 49: Attack pattern 7
        test_names[49] = "Attack pattern 7";
        expected_attack[49] = 1;
        expected_major[49] = 32'sd99390;
        expected_minor[49] = 32'sd0;
        expected_features[49][0] = 32'd292;
        expected_features[49][1] = 32'd62;
        expected_features[49][2] = 32'd6;
        expected_features[49][3] = 32'd74;
        expected_features[49][4] = 32'd4678;
        expected_features[49][5] = 32'd1790;
        expected_features[49][6] = 32'd22;
        expected_features[49][7] = 32'd86;
        expected_features[49][8] = 32'd58;
        expected_features[49][9] = 32'd33;
        expected_features[49][10] = 32'd120;
        expected_features[49][11] = 32'd60;
        expected_features[49][12] = 32'd42;
        expected_features[49][13] = 32'd30;
        expected_features[49][14] = 32'd2;
        expected_features[49][15] = 32'd25;
        expected_features[49][16] = 32'd97;
        expected_features[49][17] = 32'd39;
        expected_features[49][18] = 32'd89;
        expected_features[49][19] = 32'd72;
        expected_features[49][20] = 32'd33;
        expected_features[49][21] = 32'd216;
        expected_features[49][22] = 32'd231;
        expected_features[49][23] = 32'd213;
        expected_features[49][24] = 32'd199;
        expected_features[49][25] = 32'd202;
        expected_features[49][26] = 32'd214;
        expected_features[49][27] = 32'd198;

        // Test 50: Attack pattern 8
        test_names[50] = "Attack pattern 8";
        expected_attack[50] = 1;
        expected_major[50] = 32'sd65957;
        expected_minor[50] = 32'sd0;
        expected_features[50][0] = 32'd321;
        expected_features[50][1] = 32'd47;
        expected_features[50][2] = 32'd57;
        expected_features[50][3] = 32'd46;
        expected_features[50][4] = 32'd3721;
        expected_features[50][5] = 32'd1617;
        expected_features[50][6] = 32'd45;
        expected_features[50][7] = 32'd2;
        expected_features[50][8] = 32'd69;
        expected_features[50][9] = 32'd3;
        expected_features[50][10] = 32'd13;
        expected_features[50][11] = 32'd108;
        expected_features[50][12] = 32'd106;
        expected_features[50][13] = 32'd113;
        expected_features[50][14] = 32'd75;
        expected_features[50][15] = 32'd4;
        expected_features[50][16] = 32'd76;
        expected_features[50][17] = 32'd23;
        expected_features[50][18] = 32'd80;
        expected_features[50][19] = 32'd25;
        expected_features[50][20] = 32'd33;
        expected_features[50][21] = 32'd255;
        expected_features[50][22] = 32'd210;
        expected_features[50][23] = 32'd221;
        expected_features[50][24] = 32'd191;
        expected_features[50][25] = 32'd230;
        expected_features[50][26] = 32'd252;
        expected_features[50][27] = 32'd226;

        // Test 51: Attack pattern 9
        test_names[51] = "Attack pattern 9";
        expected_attack[51] = 1;
        expected_major[51] = 32'sd106976;
        expected_minor[51] = 32'sd0;
        expected_features[51][0] = 32'd171;
        expected_features[51][1] = 32'd103;
        expected_features[51][2] = 32'd9;
        expected_features[51][3] = 32'd123;
        expected_features[51][4] = 32'd5043;
        expected_features[51][5] = 32'd1253;
        expected_features[51][6] = 32'd25;
        expected_features[51][7] = 32'd18;
        expected_features[51][8] = 32'd29;
        expected_features[51][9] = 32'd75;
        expected_features[51][10] = 32'd102;
        expected_features[51][11] = 32'd43;
        expected_features[51][12] = 32'd70;
        expected_features[51][13] = 32'd29;
        expected_features[51][14] = 32'd21;
        expected_features[51][15] = 32'd78;
        expected_features[51][16] = 32'd121;
        expected_features[51][17] = 32'd113;
        expected_features[51][18] = 32'd47;
        expected_features[51][19] = 32'd55;
        expected_features[51][20] = 32'd56;
        expected_features[51][21] = 32'd253;
        expected_features[51][22] = 32'd198;
        expected_features[51][23] = 32'd241;
        expected_features[51][24] = 32'd198;
        expected_features[51][25] = 32'd251;
        expected_features[51][26] = 32'd190;
        expected_features[51][27] = 32'd254;

        // Test 52: Attack pattern 10
        test_names[52] = "Attack pattern 10";
        expected_attack[52] = 1;
        expected_major[52] = 32'sd43998;
        expected_minor[52] = 32'sd0;
        expected_features[52][0] = 32'd452;
        expected_features[52][1] = 32'd43;
        expected_features[52][2] = 32'd105;
        expected_features[52][3] = 32'd80;
        expected_features[52][4] = 32'd2621;
        expected_features[52][5] = 32'd1963;
        expected_features[52][6] = 32'd38;
        expected_features[52][7] = 32'd12;
        expected_features[52][8] = 32'd108;
        expected_features[52][9] = 32'd46;
        expected_features[52][10] = 32'd54;
        expected_features[52][11] = 32'd118;
        expected_features[52][12] = 32'd34;
        expected_features[52][13] = 32'd4;
        expected_features[52][14] = 32'd126;
        expected_features[52][15] = 32'd96;
        expected_features[52][16] = 32'd12;
        expected_features[52][17] = 32'd82;
        expected_features[52][18] = 32'd46;
        expected_features[52][19] = 32'd95;
        expected_features[52][20] = 32'd40;
        expected_features[52][21] = 32'd241;
        expected_features[52][22] = 32'd239;
        expected_features[52][23] = 32'd184;
        expected_features[52][24] = 32'd239;
        expected_features[52][25] = 32'd201;
        expected_features[52][26] = 32'd187;
        expected_features[52][27] = 32'd240;

    end
    
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
        for (test_num = 0; test_num < 53; test_num++) begin : test_loop
            int tolerance;
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
