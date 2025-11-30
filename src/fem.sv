// Feature Extraction Module (FEM)
// Implements hash-based sketch for flow aggregation
// Optimized for DE10-Standard (Cyclone V)

module fem #(
    parameter DATA_WIDTH = 32,
    parameter N_FEATURES = 28,
    parameter N_HASH = 4,
    parameter SKETCH_DEPTH = 256
) (
    input  logic clk,
    input  logic rst_n,
    
    // Input packet features
    input  logic [DATA_WIDTH-1:0] pkt_features [N_FEATURES-1:0],
    input  logic pkt_valid,
    
    // Output aggregated features
    output logic [DATA_WIDTH-1:0] agg_features [N_FEATURES-1:0],
    output logic agg_valid
);

    // Simple pass-through for now (can be extended with hash/sketch)
    // In full implementation, this would aggregate flows using hash tables
    
    logic [DATA_WIDTH-1:0] feature_reg [N_FEATURES-1:0];
    logic valid_reg;
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_reg <= 1'b0;
            for (int i = 0; i < N_FEATURES; i++) begin
                feature_reg[i] <= '0;
            end
        end else begin
            valid_reg <= pkt_valid;
            if (pkt_valid) begin
                for (int i = 0; i < N_FEATURES; i++) begin
                    feature_reg[i] <= pkt_features[i];
                end
            end
        end
    end
    
    assign agg_features = feature_reg;
    assign agg_valid = valid_reg;

endmodule
