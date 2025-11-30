
module hps (
	hps_0_f2h_axi_slave_awid,
	hps_0_f2h_axi_slave_awaddr,
	hps_0_f2h_axi_slave_awlen,
	hps_0_f2h_axi_slave_awsize,
	hps_0_f2h_axi_slave_awburst,
	hps_0_f2h_axi_slave_awlock,
	hps_0_f2h_axi_slave_awcache,
	hps_0_f2h_axi_slave_awprot,
	hps_0_f2h_axi_slave_awvalid,
	hps_0_f2h_axi_slave_awready,
	hps_0_f2h_axi_slave_awuser,
	hps_0_f2h_axi_slave_wid,
	hps_0_f2h_axi_slave_wdata,
	hps_0_f2h_axi_slave_wstrb,
	hps_0_f2h_axi_slave_wlast,
	hps_0_f2h_axi_slave_wvalid,
	hps_0_f2h_axi_slave_wready,
	hps_0_f2h_axi_slave_bid,
	hps_0_f2h_axi_slave_bresp,
	hps_0_f2h_axi_slave_bvalid,
	hps_0_f2h_axi_slave_bready,
	hps_0_f2h_axi_slave_arid,
	hps_0_f2h_axi_slave_araddr,
	hps_0_f2h_axi_slave_arlen,
	hps_0_f2h_axi_slave_arsize,
	hps_0_f2h_axi_slave_arburst,
	hps_0_f2h_axi_slave_arlock,
	hps_0_f2h_axi_slave_arcache,
	hps_0_f2h_axi_slave_arprot,
	hps_0_f2h_axi_slave_arvalid,
	hps_0_f2h_axi_slave_arready,
	hps_0_f2h_axi_slave_aruser,
	hps_0_f2h_axi_slave_rid,
	hps_0_f2h_axi_slave_rdata,
	hps_0_f2h_axi_slave_rresp,
	hps_0_f2h_axi_slave_rlast,
	hps_0_f2h_axi_slave_rvalid,
	hps_0_f2h_axi_slave_rready,
	memory_mem_a,
	memory_mem_ba,
	memory_mem_ck,
	memory_mem_ck_n,
	memory_mem_cke,
	memory_mem_cs_n,
	memory_mem_ras_n,
	memory_mem_cas_n,
	memory_mem_we_n,
	memory_mem_reset_n,
	memory_mem_dq,
	memory_mem_dqs,
	memory_mem_dqs_n,
	memory_mem_odt,
	memory_mem_dm,
	memory_oct_rzqin,
	hps_0_emac1_phy_txd_o,
	hps_0_emac1_phy_txen_o,
	hps_0_emac1_phy_txer_o,
	hps_0_emac1_phy_rxdv_i,
	hps_0_emac1_phy_rxer_i,
	hps_0_emac1_phy_rxd_i,
	hps_0_emac1_phy_col_i,
	hps_0_emac1_phy_crs_i,
	hps_0_emac1_gmii_mdo_o,
	hps_0_emac1_gmii_mdo_o_e,
	hps_0_emac1_gmii_mdi_i,
	hps_0_emac1_ptp_pps_o,
	hps_0_emac1_ptp_aux_ts_trig_i,
	hps_0_h2f_loan_io_in,
	hps_0_h2f_loan_io_out,
	hps_0_h2f_loan_io_oe);	

	input	[7:0]	hps_0_f2h_axi_slave_awid;
	input	[31:0]	hps_0_f2h_axi_slave_awaddr;
	input	[3:0]	hps_0_f2h_axi_slave_awlen;
	input	[2:0]	hps_0_f2h_axi_slave_awsize;
	input	[1:0]	hps_0_f2h_axi_slave_awburst;
	input	[1:0]	hps_0_f2h_axi_slave_awlock;
	input	[3:0]	hps_0_f2h_axi_slave_awcache;
	input	[2:0]	hps_0_f2h_axi_slave_awprot;
	input		hps_0_f2h_axi_slave_awvalid;
	output		hps_0_f2h_axi_slave_awready;
	input	[4:0]	hps_0_f2h_axi_slave_awuser;
	input	[7:0]	hps_0_f2h_axi_slave_wid;
	input	[63:0]	hps_0_f2h_axi_slave_wdata;
	input	[7:0]	hps_0_f2h_axi_slave_wstrb;
	input		hps_0_f2h_axi_slave_wlast;
	input		hps_0_f2h_axi_slave_wvalid;
	output		hps_0_f2h_axi_slave_wready;
	output	[7:0]	hps_0_f2h_axi_slave_bid;
	output	[1:0]	hps_0_f2h_axi_slave_bresp;
	output		hps_0_f2h_axi_slave_bvalid;
	input		hps_0_f2h_axi_slave_bready;
	input	[7:0]	hps_0_f2h_axi_slave_arid;
	input	[31:0]	hps_0_f2h_axi_slave_araddr;
	input	[3:0]	hps_0_f2h_axi_slave_arlen;
	input	[2:0]	hps_0_f2h_axi_slave_arsize;
	input	[1:0]	hps_0_f2h_axi_slave_arburst;
	input	[1:0]	hps_0_f2h_axi_slave_arlock;
	input	[3:0]	hps_0_f2h_axi_slave_arcache;
	input	[2:0]	hps_0_f2h_axi_slave_arprot;
	input		hps_0_f2h_axi_slave_arvalid;
	output		hps_0_f2h_axi_slave_arready;
	input	[4:0]	hps_0_f2h_axi_slave_aruser;
	output	[7:0]	hps_0_f2h_axi_slave_rid;
	output	[63:0]	hps_0_f2h_axi_slave_rdata;
	output	[1:0]	hps_0_f2h_axi_slave_rresp;
	output		hps_0_f2h_axi_slave_rlast;
	output		hps_0_f2h_axi_slave_rvalid;
	input		hps_0_f2h_axi_slave_rready;
	output	[12:0]	memory_mem_a;
	output	[2:0]	memory_mem_ba;
	output		memory_mem_ck;
	output		memory_mem_ck_n;
	output		memory_mem_cke;
	output		memory_mem_cs_n;
	output		memory_mem_ras_n;
	output		memory_mem_cas_n;
	output		memory_mem_we_n;
	output		memory_mem_reset_n;
	inout	[7:0]	memory_mem_dq;
	inout		memory_mem_dqs;
	inout		memory_mem_dqs_n;
	output		memory_mem_odt;
	output		memory_mem_dm;
	input		memory_oct_rzqin;
	output	[7:0]	hps_0_emac1_phy_txd_o;
	output		hps_0_emac1_phy_txen_o;
	output		hps_0_emac1_phy_txer_o;
	input		hps_0_emac1_phy_rxdv_i;
	input		hps_0_emac1_phy_rxer_i;
	input	[7:0]	hps_0_emac1_phy_rxd_i;
	input		hps_0_emac1_phy_col_i;
	input		hps_0_emac1_phy_crs_i;
	output		hps_0_emac1_gmii_mdo_o;
	output		hps_0_emac1_gmii_mdo_o_e;
	input		hps_0_emac1_gmii_mdi_i;
	output		hps_0_emac1_ptp_pps_o;
	input		hps_0_emac1_ptp_aux_ts_trig_i;
	output	[66:0]	hps_0_h2f_loan_io_in;
	input	[66:0]	hps_0_h2f_loan_io_out;
	input	[66:0]	hps_0_h2f_loan_io_oe;
endmodule
