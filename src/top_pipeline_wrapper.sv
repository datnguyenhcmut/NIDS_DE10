// Top-level wrapper for FPGA synthesis
// Reduces pin count for DE10-Standard
// Uses minimal I/O for demonstration

module top_pipeline_wrapper (
    input  logic clk,           // 1 pin: 50MHz clock
    input  logic rst_n,         // 1 pin: Reset button
    input  logic enable,        // 1 pin: Enable processing
    output logic attack_led,    // 1 pin: Attack detected LED
    output logic [6:0] hex0,    // 7 pins: 7-segment display for score
    output logic [6:0] hex1     // 7 pins: 7-segment display for score
);
    // Total pins: 1 + 1 + 1 + 1 + 7 + 7 = 18 pins (fits easily!)
    
    // Internal signals
    logic [31:0] pkt_features [27:0];
    logic pkt_valid;
    logic attack_detected;
    logic [31:0] major_score;
    logic [31:0] minor_score;
    logic valid_out;
    
    // Test pattern generator (replaces real packet input)
    logic [7:0] test_counter;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            test_counter <= 8'h00;
            pkt_valid <= 1'b0;
            // Initialize features to zero
            for (int i = 0; i < 28; i++) begin
                pkt_features[i] <= 32'h0;
            end
        end else if (enable) begin
            // Generate test pattern every 256 cycles
            test_counter <= test_counter + 1;
            
            if (test_counter == 8'hFF) begin
                // Load test features (example: simulate attack pattern)
                pkt_features[0] <= 32'h00000000;
                pkt_features[1] <= 32'h00000000;
                pkt_features[2] <= 32'h00006f00;  // Some activity
                pkt_features[3] <= 32'h0000cb00;
                pkt_features[4] <= 32'h0000b500;
                pkt_features[5] <= 32'h00154a00;  // Large value = suspicious
                for (int i = 6; i < 28; i++) begin
                    pkt_features[i] <= 32'h00000000;
                end
                pkt_valid <= 1'b1;
            end else begin
                pkt_valid <= 1'b0;
            end
        end
    end
    
    // Instantiate NIDS pipeline
    top_pipeline #(
        .DATA_WIDTH(32),
        .N_FEATURES(28)
    ) nids_core (
        .clk(clk),
        .rst_n(rst_n),
        .pkt_features(pkt_features),
        .pkt_valid(pkt_valid),
        .attack_detected(attack_detected),
        .major_score(major_score),
        .minor_score(minor_score),
        .valid_out(valid_out)
    );
    
    // Attack LED output
    assign attack_led = attack_detected;
    
    // Display major score on 7-segment displays (lower 2 hex digits)
    logic [3:0] score_digit0, score_digit1;
    assign score_digit0 = major_score[3:0];
    assign score_digit1 = major_score[7:4];
    
    // 7-segment decoder for HEX0
    always_comb begin
        case (score_digit0)
            4'h0: hex0 = 7'b1000000;
            4'h1: hex0 = 7'b1111001;
            4'h2: hex0 = 7'b0100100;
            4'h3: hex0 = 7'b0110000;
            4'h4: hex0 = 7'b0011001;
            4'h5: hex0 = 7'b0010010;
            4'h6: hex0 = 7'b0000010;
            4'h7: hex0 = 7'b1111000;
            4'h8: hex0 = 7'b0000000;
            4'h9: hex0 = 7'b0010000;
            4'hA: hex0 = 7'b0001000;
            4'hB: hex0 = 7'b0000011;
            4'hC: hex0 = 7'b1000110;
            4'hD: hex0 = 7'b0100001;
            4'hE: hex0 = 7'b0000110;
            4'hF: hex0 = 7'b0001110;
        endcase
    end
    
    // 7-segment decoder for HEX1
    always_comb begin
        case (score_digit1)
            4'h0: hex1 = 7'b1000000;
            4'h1: hex1 = 7'b1111001;
            4'h2: hex1 = 7'b0100100;
            4'h3: hex1 = 7'b0110000;
            4'h4: hex1 = 7'b0011001;
            4'h5: hex1 = 7'b0010010;
            4'h6: hex1 = 7'b0000010;
            4'h7: hex1 = 7'b1111000;
            4'h8: hex1 = 7'b0000000;
            4'h9: hex1 = 7'b0010000;
            4'hA: hex1 = 7'b0001000;
            4'hB: hex1 = 7'b0000011;
            4'hC: hex1 = 7'b1000110;
            4'hD: hex1 = 7'b0100001;
            4'hE: hex1 = 7'b0000110;
            4'hF: hex1 = 7'b0001110;
        endcase
    end

endmodule
