// Top-level wrapper with HPS integration
// For DE10-Standard with HPS Ethernet input

module top_hps_wrapper (
    // HPS Lightweight Bridge (AXI-Lite)
    input  logic        h2f_lw_axi_clk,
    input  logic        h2f_lw_axi_rst_n,
    input  logic [20:0] h2f_lw_axi_awaddr,
    input  logic        h2f_lw_axi_awvalid,
    output logic        h2f_lw_axi_awready,
    input  logic [31:0] h2f_lw_axi_wdata,
    input  logic [3:0]  h2f_lw_axi_wstrb,
    input  logic        h2f_lw_axi_wvalid,
    output logic        h2f_lw_axi_wready,
    output logic [1:0]  h2f_lw_axi_bresp,
    output logic        h2f_lw_axi_bvalid,
    input  logic        h2f_lw_axi_bready,
    input  logic [20:0] h2f_lw_axi_araddr,
    input  logic        h2f_lw_axi_arvalid,
    output logic        h2f_lw_axi_arready,
    output logic [31:0] h2f_lw_axi_rdata,
    output logic [1:0]  h2f_lw_axi_rresp,
    output logic        h2f_lw_axi_rvalid,
    input  logic        h2f_lw_axi_rready,
    
    // Debug outputs
    output logic        attack_led,
    output logic [6:0]  hex0,
    output logic [6:0]  hex1
);

    // FPGA clock domain
    logic fpga_clk;
    logic fpga_rst_n;
    
    assign fpga_clk = h2f_lw_axi_clk;
    assign fpga_rst_n = h2f_lw_axi_rst_n;
    
    // AXI to simple interface converter
    logic [31:0] avs_address;
    logic        avs_write;
    logic        avs_read;
    logic [31:0] avs_writedata;
    logic [31:0] avs_readdata;
    
    // Simplified AXI-Lite to Avalon conversion
    typedef enum logic [2:0] {
        IDLE,
        WRITE_DATA,
        WRITE_RESP,
        READ_ADDR,
        READ_DATA
    } axi_state_t;
    
    axi_state_t axi_state;
    
    always_ff @(posedge fpga_clk or negedge fpga_rst_n) begin
        if (!fpga_rst_n) begin
            axi_state <= IDLE;
            avs_write <= 1'b0;
            avs_read <= 1'b0;
            h2f_lw_axi_awready <= 1'b0;
            h2f_lw_axi_wready <= 1'b0;
            h2f_lw_axi_bvalid <= 1'b0;
            h2f_lw_axi_arready <= 1'b0;
            h2f_lw_axi_rvalid <= 1'b0;
        end else begin
            avs_write <= 1'b0;
            avs_read <= 1'b0;
            
            case (axi_state)
                IDLE: begin
                    if (h2f_lw_axi_awvalid) begin
                        avs_address <= {11'h0, h2f_lw_axi_awaddr};
                        h2f_lw_axi_awready <= 1'b1;
                        axi_state <= WRITE_DATA;
                    end else if (h2f_lw_axi_arvalid) begin
                        avs_address <= {11'h0, h2f_lw_axi_araddr};
                        h2f_lw_axi_arready <= 1'b1;
                        axi_state <= READ_ADDR;
                    end
                end
                
                WRITE_DATA: begin
                    h2f_lw_axi_awready <= 1'b0;
                    if (h2f_lw_axi_wvalid) begin
                        avs_writedata <= h2f_lw_axi_wdata;
                        avs_write <= 1'b1;
                        h2f_lw_axi_wready <= 1'b1;
                        axi_state <= WRITE_RESP;
                    end
                end
                
                WRITE_RESP: begin
                    h2f_lw_axi_wready <= 1'b0;
                    h2f_lw_axi_bvalid <= 1'b1;
                    h2f_lw_axi_bresp <= 2'b00;  // OKAY
                    if (h2f_lw_axi_bready) begin
                        h2f_lw_axi_bvalid <= 1'b0;
                        axi_state <= IDLE;
                    end
                end
                
                READ_ADDR: begin
                    h2f_lw_axi_arready <= 1'b0;
                    avs_read <= 1'b1;
                    axi_state <= READ_DATA;
                end
                
                READ_DATA: begin
                    h2f_lw_axi_rdata <= avs_readdata;
                    h2f_lw_axi_rvalid <= 1'b1;
                    h2f_lw_axi_rresp <= 2'b00;  // OKAY
                    if (h2f_lw_axi_rready) begin
                        h2f_lw_axi_rvalid <= 1'b0;
                        axi_state <= IDLE;
                    end
                end
            endcase
        end
    end
    
    // NIDS signals
    logic [31:0] pkt_features [27:0];
    logic        pkt_valid;
    logic        attack_detected;
    logic [31:0] major_score;
    logic [31:0] minor_score;
    logic        valid_out;
    
    // HPS bridge
    hps_nids_bridge bridge_inst (
        .clk(fpga_clk),
        .reset_n(fpga_rst_n),
        .avs_address(avs_address),
        .avs_write(avs_write),
        .avs_read(avs_read),
        .avs_writedata(avs_writedata),
        .avs_readdata(avs_readdata),
        .avs_waitrequest(),
        .pkt_features(pkt_features),
        .pkt_valid(pkt_valid),
        .attack_detected(attack_detected),
        .major_score(major_score),
        .minor_score(minor_score),
        .valid_out(valid_out)
    );
    
    // NIDS core
    top_pipeline #(
        .DATA_WIDTH(32),
        .N_FEATURES(28)
    ) nids_core (
        .clk(fpga_clk),
        .rst_n(fpga_rst_n),
        .pkt_features(pkt_features),
        .pkt_valid(pkt_valid),
        .attack_detected(attack_detected),
        .major_score(major_score),
        .minor_score(minor_score),
        .valid_out(valid_out)
    );
    
    // Debug outputs
    assign attack_led = attack_detected;
    
    // 7-segment display
    logic [3:0] score_digit0, score_digit1;
    assign score_digit0 = major_score[3:0];
    assign score_digit1 = major_score[7:4];
    
    function automatic logic [6:0] seg7_decode(input logic [3:0] digit);
        case (digit)
            4'h0: return 7'b1000000;
            4'h1: return 7'b1111001;
            4'h2: return 7'b0100100;
            4'h3: return 7'b0110000;
            4'h4: return 7'b0011001;
            4'h5: return 7'b0010010;
            4'h6: return 7'b0000010;
            4'h7: return 7'b1111000;
            4'h8: return 7'b0000000;
            4'h9: return 7'b0010000;
            4'hA: return 7'b0001000;
            4'hB: return 7'b0000011;
            4'hC: return 7'b1000110;
            4'hD: return 7'b0100001;
            4'hE: return 7'b0000110;
            4'hF: return 7'b0001110;
        endcase
    endfunction
    
    assign hex0 = seg7_decode(score_digit0);
    assign hex1 = seg7_decode(score_digit1);

endmodule
