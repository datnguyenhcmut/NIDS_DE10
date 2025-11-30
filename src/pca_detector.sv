// PCA-based Anomaly Detector
// Implements Major Component (MajC) and Minor Component (MinC) analysis
// Optimized for DE10-Standard (Cyclone V)
// Fixed-point arithmetic: Q24.8

import pca_coeffs_pkg::*;

module pca_detector #(
    parameter DATA_WIDTH = 32,
    parameter FRAC_BITS = 8,
    parameter N_FEATURES = 28,
    parameter Q = 4,  // Major components
    parameter R = 2   // Minor components
) (
    input  logic clk,
    input  logic rst_n,
    
    // Input features (already aggregated by FEM)
    input  logic [DATA_WIDTH-1:0] features [N_FEATURES-1:0],
    input  logic valid_in,
    
    // Output detection results
    output logic [31:0] major_score,  // SPE in major subspace
    output logic [31:0] minor_score,  // Score in minor subspace
    output logic attack_detected,
    output logic valid_out
);

    // PCA parameters from package (auto-generated from trained model)
    logic signed [DATA_WIDTH-1:0] mean [N_FEATURES-1:0] = MEAN;
    logic signed [DATA_WIDTH-1:0] major_components [Q-1:0][N_FEATURES-1:0] = MAJOR_COMPONENTS;
    logic signed [DATA_WIDTH-1:0] minor_components [R-1:0][N_FEATURES-1:0] = MINOR_COMPONENTS;
    
    // Pipeline stages
    typedef enum logic [2:0] {
        IDLE,
        CENTER,
        PROJ_MAJOR,
        PROJ_MINOR,
        COMPUTE_SCORES,
        DONE
    } state_t;
    
    state_t state, next_state;
    
    // Registers
    logic signed [DATA_WIDTH-1:0] features_reg [N_FEATURES-1:0];
    logic signed [DATA_WIDTH-1:0] centered [N_FEATURES-1:0];
    logic signed [31:0] major_proj [Q-1:0];
    logic signed [31:0] minor_proj [R-1:0];
    logic signed [31:0] major_recon [N_FEATURES-1:0];
    logic signed [31:0] major_score_acc;
    logic signed [31:0] minor_score_acc;
    logic [31:0] threshold;
    logic signed [31:0] major_abs, minor_abs;  // For absolute value check
    
    integer i, j;
    logic signed [63:0] mult_result_64;
    logic signed [31:0] mult_result;
    logic signed [63:0] acc_64;
    
    // State machine
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    always_comb begin
        next_state = state;
        case (state)
            IDLE: if (valid_in) next_state = CENTER;
            CENTER: next_state = PROJ_MAJOR;
            PROJ_MAJOR: next_state = PROJ_MINOR;
            PROJ_MINOR: next_state = COMPUTE_SCORES;
            COMPUTE_SCORES: next_state = DONE;
            DONE: next_state = IDLE;
        endcase
    end
    
    // Datapath
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < N_FEATURES; i++) begin
                centered[i] <= '0;
                major_recon[i] <= '0;
            end
            for (i = 0; i < Q; i++) begin
                major_proj[i] <= '0;
            end
            for (i = 0; i < R; i++) begin
                minor_proj[i] <= '0;
            end
            major_score_acc <= '0;
            minor_score_acc <= '0;
            valid_out <= 1'b0;
            attack_detected <= 1'b0;
        end else begin
            case (state)
                CENTER: begin
                    // Store features as signed and center: x - mean
                    for (i = 0; i < N_FEATURES; i++) begin
                        features_reg[i] <= signed'(features[i]);
                        centered[i] <= signed'(features[i]) - mean[i];
                    end
                    valid_out <= 1'b0;
                end
                
                PROJ_MAJOR: begin
                    // Project onto major components
                    for (i = 0; i < Q; i++) begin
                        acc_64 = 0;
                        for (j = 0; j < N_FEATURES; j++) begin
                            // Fixed-point multiply with 64-bit intermediate
                            mult_result_64 = centered[j] * major_components[i][j];
                            mult_result = mult_result_64 >>> FRAC_BITS;
                            acc_64 = acc_64 + mult_result;
                        end
                        major_proj[i] <= acc_64[31:0];
                    end
                end
                
                PROJ_MINOR: begin
                    // Project onto minor components
                    for (i = 0; i < R; i++) begin
                        acc_64 = 0;
                        for (j = 0; j < N_FEATURES; j++) begin
                            mult_result_64 = centered[j] * minor_components[i][j];
                            mult_result = mult_result_64 >>> FRAC_BITS;
                            acc_64 = acc_64 + mult_result;
                        end
                        minor_proj[i] <= acc_64[31:0];
                    end
                    
                    // Reconstruct from major components
                    for (j = 0; j < N_FEATURES; j++) begin
                        acc_64 = 0;
                        for (i = 0; i < Q; i++) begin
                            mult_result_64 = major_proj[i] * major_components[i][j];
                            mult_result = mult_result_64 >>> FRAC_BITS;
                            acc_64 = acc_64 + mult_result;
                        end
                        major_recon[j] <= acc_64[31:0];
                    end
                end
                
                COMPUTE_SCORES: begin
                    // Major score: sum of squared residuals
                    major_score_acc = 0;
                    for (i = 0; i < N_FEATURES; i++) begin
                        logic signed [31:0] residual;
                        residual = centered[i] - major_recon[i];
                        // Square with 64-bit intermediate
                        mult_result_64 = residual * residual;
                        mult_result = mult_result_64 >>> FRAC_BITS;
                        major_score_acc = major_score_acc + mult_result;
                    end
                    
                    // Minor score: sum of squared projections
                    minor_score_acc = 0;
                    for (i = 0; i < R; i++) begin
                        mult_result_64 = minor_proj[i] * minor_proj[i];
                        mult_result = mult_result_64 >>> FRAC_BITS;
                        minor_score_acc = minor_score_acc + mult_result;
                    end
                end
                
                DONE: begin
                    major_score <= major_score_acc;
                    minor_score <= minor_score_acc;
                    
                    // Simple threshold-based detection
                    // Threshold = 100 in fixed-point (100 << FRAC_BITS)
                    // Use absolute value to handle overflow cases with negative scores
                    threshold = 100 << FRAC_BITS;
                    
                    // Check absolute value for both major and minor scores
                    major_abs = (major_score_acc < 0) ? -major_score_acc : major_score_acc;
                    minor_abs = (minor_score_acc < 0) ? -minor_score_acc : minor_score_acc;
                    
                    if (major_abs > threshold || minor_abs > threshold) begin
                        attack_detected <= 1'b1;
                    end else begin
                        attack_detected <= 1'b0;
                    end
                    
                    valid_out <= 1'b1;
                end
                
                default: begin
                    valid_out <= 1'b0;
                end
            endcase
        end
    end

endmodule
