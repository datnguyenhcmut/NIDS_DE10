// HPS-to-FPGA Lightweight Bridge Interface
// Receives packet features from HPS and sends to NIDS pipeline

module hps_nids_bridge (
    // HPS Lightweight AXI interface (slave)
    input  logic        clk,
    input  logic        reset_n,
    
    // AXI-Lite slave interface from HPS
    input  logic [31:0] avs_address,
    input  logic        avs_write,
    input  logic        avs_read,
    input  logic [31:0] avs_writedata,
    output logic [31:0] avs_readdata,
    output logic        avs_waitrequest,
    
    // NIDS pipeline interface
    output logic [31:0] pkt_features [27:0],
    output logic        pkt_valid,
    input  logic        attack_detected,
    input  logic [31:0] major_score,
    input  logic [31:0] minor_score,
    input  logic        valid_out
);

    // Address map:
    // 0x00-0x6F: Feature registers (28 features x 4 bytes = 112 bytes)
    // 0x70: Control register (bit 0 = trigger processing)
    // 0x74: Status register (bit 0 = busy, bit 1 = attack detected)
    // 0x78: Major score
    // 0x7C: Minor score
    
    localparam ADDR_FEATURES_BASE = 8'h00;
    localparam ADDR_CONTROL       = 8'h70;
    localparam ADDR_STATUS        = 8'h74;
    localparam ADDR_MAJOR_SCORE   = 8'h78;
    localparam ADDR_MINOR_SCORE   = 8'h7C;
    
    // Internal registers
    logic [31:0] features_reg [27:0];
    logic        trigger;
    logic        busy;
    logic        attack_reg;
    logic [31:0] major_score_reg;
    logic [31:0] minor_score_reg;
    
    // Feature buffer write
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            for (int i = 0; i < 28; i++) begin
                features_reg[i] <= 32'h0;
            end
            trigger <= 1'b0;
        end else begin
            trigger <= 1'b0;  // Auto-clear
            
            if (avs_write && !avs_waitrequest) begin
                if (avs_address[7:0] >= ADDR_FEATURES_BASE && 
                    avs_address[7:0] < ADDR_CONTROL) begin
                    // Write to feature register
                    int idx = avs_address[7:2];  // Divide by 4 for word addressing
                    if (idx < 28) begin
                        features_reg[idx] <= avs_writedata;
                    end
                end else if (avs_address[7:0] == ADDR_CONTROL) begin
                    // Write to control register
                    trigger <= avs_writedata[0];
                end
            end
        end
    end
    
    // Read interface
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            avs_readdata <= 32'h0;
        end else if (avs_read) begin
            if (avs_address[7:0] >= ADDR_FEATURES_BASE && 
                avs_address[7:0] < ADDR_CONTROL) begin
                int idx = avs_address[7:2];
                if (idx < 28) begin
                    avs_readdata <= features_reg[idx];
                end else begin
                    avs_readdata <= 32'h0;
                end
            end else begin
                case (avs_address[7:0])
                    ADDR_CONTROL: avs_readdata <= {31'h0, trigger};
                    ADDR_STATUS: avs_readdata <= {30'h0, attack_reg, busy};
                    ADDR_MAJOR_SCORE: avs_readdata <= major_score_reg;
                    ADDR_MINOR_SCORE: avs_readdata <= minor_score_reg;
                    default: avs_readdata <= 32'h0;
                endcase
            end
        end
    end
    
    assign avs_waitrequest = 1'b0;  // Always ready
    
    // NIDS pipeline control
    typedef enum logic [1:0] {
        IDLE,
        PROCESSING,
        DONE
    } state_t;
    
    state_t state;
    
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= IDLE;
            busy <= 1'b0;
            pkt_valid <= 1'b0;
            attack_reg <= 1'b0;
            major_score_reg <= 32'h0;
            minor_score_reg <= 32'h0;
        end else begin
            case (state)
                IDLE: begin
                    pkt_valid <= 1'b0;
                    if (trigger) begin
                        // Copy features to output
                        for (int i = 0; i < 28; i++) begin
                            pkt_features[i] <= features_reg[i];
                        end
                        pkt_valid <= 1'b1;
                        busy <= 1'b1;
                        state <= PROCESSING;
                    end
                end
                
                PROCESSING: begin
                    pkt_valid <= 1'b0;
                    if (valid_out) begin
                        // Capture results
                        attack_reg <= attack_detected;
                        major_score_reg <= major_score;
                        minor_score_reg <= minor_score;
                        busy <= 1'b0;
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
