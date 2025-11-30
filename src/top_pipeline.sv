// Top-level NIDS Pipeline
// Connects FEM -> PCA Detector
// Optimized for DE10-Standard (Cyclone V SoC)

module top_pipeline #(
    parameter DATA_WIDTH = 32,
    parameter N_FEATURES = 28
) (
    input  logic clk,
    input  logic rst_n,
    
    // Input packet features
    input  logic [DATA_WIDTH-1:0] pkt_features [N_FEATURES-1:0],
    input  logic pkt_valid,
    
    // Output detection results
    output logic attack_detected,
    output logic [31:0] major_score,
    output logic [31:0] minor_score,
    output logic valid_out
);

    // Interconnect signals
    logic [DATA_WIDTH-1:0] agg_features [N_FEATURES-1:0];
    logic agg_valid;
    
    // Feature Extraction Module
    fem #(
        .DATA_WIDTH(DATA_WIDTH),
        .N_FEATURES(N_FEATURES)
    ) u_fem (
        .clk(clk),
        .rst_n(rst_n),
        .pkt_features(pkt_features),
        .pkt_valid(pkt_valid),
        .agg_features(agg_features),
        .agg_valid(agg_valid)
    );
    
    // PCA Detector
    pca_detector #(
        .DATA_WIDTH(DATA_WIDTH),
        .N_FEATURES(N_FEATURES)
    ) u_pca (
        .clk(clk),
        .rst_n(rst_n),
        .features(agg_features),
        .valid_in(agg_valid),
        .major_score(major_score),
        .minor_score(minor_score),
        .attack_detected(attack_detected),
        .valid_out(valid_out)
    );

endmodule
