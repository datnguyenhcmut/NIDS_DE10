	component hps is
		port (
			hps_0_f2h_axi_slave_awid      : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- awid
			hps_0_f2h_axi_slave_awaddr    : in    std_logic_vector(31 downto 0) := (others => 'X'); -- awaddr
			hps_0_f2h_axi_slave_awlen     : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- awlen
			hps_0_f2h_axi_slave_awsize    : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- awsize
			hps_0_f2h_axi_slave_awburst   : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- awburst
			hps_0_f2h_axi_slave_awlock    : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- awlock
			hps_0_f2h_axi_slave_awcache   : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- awcache
			hps_0_f2h_axi_slave_awprot    : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- awprot
			hps_0_f2h_axi_slave_awvalid   : in    std_logic                     := 'X';             -- awvalid
			hps_0_f2h_axi_slave_awready   : out   std_logic;                                        -- awready
			hps_0_f2h_axi_slave_awuser    : in    std_logic_vector(4 downto 0)  := (others => 'X'); -- awuser
			hps_0_f2h_axi_slave_wid       : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- wid
			hps_0_f2h_axi_slave_wdata     : in    std_logic_vector(63 downto 0) := (others => 'X'); -- wdata
			hps_0_f2h_axi_slave_wstrb     : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- wstrb
			hps_0_f2h_axi_slave_wlast     : in    std_logic                     := 'X';             -- wlast
			hps_0_f2h_axi_slave_wvalid    : in    std_logic                     := 'X';             -- wvalid
			hps_0_f2h_axi_slave_wready    : out   std_logic;                                        -- wready
			hps_0_f2h_axi_slave_bid       : out   std_logic_vector(7 downto 0);                     -- bid
			hps_0_f2h_axi_slave_bresp     : out   std_logic_vector(1 downto 0);                     -- bresp
			hps_0_f2h_axi_slave_bvalid    : out   std_logic;                                        -- bvalid
			hps_0_f2h_axi_slave_bready    : in    std_logic                     := 'X';             -- bready
			hps_0_f2h_axi_slave_arid      : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- arid
			hps_0_f2h_axi_slave_araddr    : in    std_logic_vector(31 downto 0) := (others => 'X'); -- araddr
			hps_0_f2h_axi_slave_arlen     : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- arlen
			hps_0_f2h_axi_slave_arsize    : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- arsize
			hps_0_f2h_axi_slave_arburst   : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- arburst
			hps_0_f2h_axi_slave_arlock    : in    std_logic_vector(1 downto 0)  := (others => 'X'); -- arlock
			hps_0_f2h_axi_slave_arcache   : in    std_logic_vector(3 downto 0)  := (others => 'X'); -- arcache
			hps_0_f2h_axi_slave_arprot    : in    std_logic_vector(2 downto 0)  := (others => 'X'); -- arprot
			hps_0_f2h_axi_slave_arvalid   : in    std_logic                     := 'X';             -- arvalid
			hps_0_f2h_axi_slave_arready   : out   std_logic;                                        -- arready
			hps_0_f2h_axi_slave_aruser    : in    std_logic_vector(4 downto 0)  := (others => 'X'); -- aruser
			hps_0_f2h_axi_slave_rid       : out   std_logic_vector(7 downto 0);                     -- rid
			hps_0_f2h_axi_slave_rdata     : out   std_logic_vector(63 downto 0);                    -- rdata
			hps_0_f2h_axi_slave_rresp     : out   std_logic_vector(1 downto 0);                     -- rresp
			hps_0_f2h_axi_slave_rlast     : out   std_logic;                                        -- rlast
			hps_0_f2h_axi_slave_rvalid    : out   std_logic;                                        -- rvalid
			hps_0_f2h_axi_slave_rready    : in    std_logic                     := 'X';             -- rready
			memory_mem_a                  : out   std_logic_vector(12 downto 0);                    -- mem_a
			memory_mem_ba                 : out   std_logic_vector(2 downto 0);                     -- mem_ba
			memory_mem_ck                 : out   std_logic;                                        -- mem_ck
			memory_mem_ck_n               : out   std_logic;                                        -- mem_ck_n
			memory_mem_cke                : out   std_logic;                                        -- mem_cke
			memory_mem_cs_n               : out   std_logic;                                        -- mem_cs_n
			memory_mem_ras_n              : out   std_logic;                                        -- mem_ras_n
			memory_mem_cas_n              : out   std_logic;                                        -- mem_cas_n
			memory_mem_we_n               : out   std_logic;                                        -- mem_we_n
			memory_mem_reset_n            : out   std_logic;                                        -- mem_reset_n
			memory_mem_dq                 : inout std_logic_vector(7 downto 0)  := (others => 'X'); -- mem_dq
			memory_mem_dqs                : inout std_logic                     := 'X';             -- mem_dqs
			memory_mem_dqs_n              : inout std_logic                     := 'X';             -- mem_dqs_n
			memory_mem_odt                : out   std_logic;                                        -- mem_odt
			memory_mem_dm                 : out   std_logic;                                        -- mem_dm
			memory_oct_rzqin              : in    std_logic                     := 'X';             -- oct_rzqin
			hps_0_emac1_phy_txd_o         : out   std_logic_vector(7 downto 0);                     -- phy_txd_o
			hps_0_emac1_phy_txen_o        : out   std_logic;                                        -- phy_txen_o
			hps_0_emac1_phy_txer_o        : out   std_logic;                                        -- phy_txer_o
			hps_0_emac1_phy_rxdv_i        : in    std_logic                     := 'X';             -- phy_rxdv_i
			hps_0_emac1_phy_rxer_i        : in    std_logic                     := 'X';             -- phy_rxer_i
			hps_0_emac1_phy_rxd_i         : in    std_logic_vector(7 downto 0)  := (others => 'X'); -- phy_rxd_i
			hps_0_emac1_phy_col_i         : in    std_logic                     := 'X';             -- phy_col_i
			hps_0_emac1_phy_crs_i         : in    std_logic                     := 'X';             -- phy_crs_i
			hps_0_emac1_gmii_mdo_o        : out   std_logic;                                        -- gmii_mdo_o
			hps_0_emac1_gmii_mdo_o_e      : out   std_logic;                                        -- gmii_mdo_o_e
			hps_0_emac1_gmii_mdi_i        : in    std_logic                     := 'X';             -- gmii_mdi_i
			hps_0_emac1_ptp_pps_o         : out   std_logic;                                        -- ptp_pps_o
			hps_0_emac1_ptp_aux_ts_trig_i : in    std_logic                     := 'X';             -- ptp_aux_ts_trig_i
			hps_0_h2f_loan_io_in          : out   std_logic_vector(66 downto 0);                    -- in
			hps_0_h2f_loan_io_out         : in    std_logic_vector(66 downto 0) := (others => 'X'); -- out
			hps_0_h2f_loan_io_oe          : in    std_logic_vector(66 downto 0) := (others => 'X')  -- oe
		);
	end component hps;

	u0 : component hps
		port map (
			hps_0_f2h_axi_slave_awid      => CONNECTED_TO_hps_0_f2h_axi_slave_awid,      -- hps_0_f2h_axi_slave.awid
			hps_0_f2h_axi_slave_awaddr    => CONNECTED_TO_hps_0_f2h_axi_slave_awaddr,    --                    .awaddr
			hps_0_f2h_axi_slave_awlen     => CONNECTED_TO_hps_0_f2h_axi_slave_awlen,     --                    .awlen
			hps_0_f2h_axi_slave_awsize    => CONNECTED_TO_hps_0_f2h_axi_slave_awsize,    --                    .awsize
			hps_0_f2h_axi_slave_awburst   => CONNECTED_TO_hps_0_f2h_axi_slave_awburst,   --                    .awburst
			hps_0_f2h_axi_slave_awlock    => CONNECTED_TO_hps_0_f2h_axi_slave_awlock,    --                    .awlock
			hps_0_f2h_axi_slave_awcache   => CONNECTED_TO_hps_0_f2h_axi_slave_awcache,   --                    .awcache
			hps_0_f2h_axi_slave_awprot    => CONNECTED_TO_hps_0_f2h_axi_slave_awprot,    --                    .awprot
			hps_0_f2h_axi_slave_awvalid   => CONNECTED_TO_hps_0_f2h_axi_slave_awvalid,   --                    .awvalid
			hps_0_f2h_axi_slave_awready   => CONNECTED_TO_hps_0_f2h_axi_slave_awready,   --                    .awready
			hps_0_f2h_axi_slave_awuser    => CONNECTED_TO_hps_0_f2h_axi_slave_awuser,    --                    .awuser
			hps_0_f2h_axi_slave_wid       => CONNECTED_TO_hps_0_f2h_axi_slave_wid,       --                    .wid
			hps_0_f2h_axi_slave_wdata     => CONNECTED_TO_hps_0_f2h_axi_slave_wdata,     --                    .wdata
			hps_0_f2h_axi_slave_wstrb     => CONNECTED_TO_hps_0_f2h_axi_slave_wstrb,     --                    .wstrb
			hps_0_f2h_axi_slave_wlast     => CONNECTED_TO_hps_0_f2h_axi_slave_wlast,     --                    .wlast
			hps_0_f2h_axi_slave_wvalid    => CONNECTED_TO_hps_0_f2h_axi_slave_wvalid,    --                    .wvalid
			hps_0_f2h_axi_slave_wready    => CONNECTED_TO_hps_0_f2h_axi_slave_wready,    --                    .wready
			hps_0_f2h_axi_slave_bid       => CONNECTED_TO_hps_0_f2h_axi_slave_bid,       --                    .bid
			hps_0_f2h_axi_slave_bresp     => CONNECTED_TO_hps_0_f2h_axi_slave_bresp,     --                    .bresp
			hps_0_f2h_axi_slave_bvalid    => CONNECTED_TO_hps_0_f2h_axi_slave_bvalid,    --                    .bvalid
			hps_0_f2h_axi_slave_bready    => CONNECTED_TO_hps_0_f2h_axi_slave_bready,    --                    .bready
			hps_0_f2h_axi_slave_arid      => CONNECTED_TO_hps_0_f2h_axi_slave_arid,      --                    .arid
			hps_0_f2h_axi_slave_araddr    => CONNECTED_TO_hps_0_f2h_axi_slave_araddr,    --                    .araddr
			hps_0_f2h_axi_slave_arlen     => CONNECTED_TO_hps_0_f2h_axi_slave_arlen,     --                    .arlen
			hps_0_f2h_axi_slave_arsize    => CONNECTED_TO_hps_0_f2h_axi_slave_arsize,    --                    .arsize
			hps_0_f2h_axi_slave_arburst   => CONNECTED_TO_hps_0_f2h_axi_slave_arburst,   --                    .arburst
			hps_0_f2h_axi_slave_arlock    => CONNECTED_TO_hps_0_f2h_axi_slave_arlock,    --                    .arlock
			hps_0_f2h_axi_slave_arcache   => CONNECTED_TO_hps_0_f2h_axi_slave_arcache,   --                    .arcache
			hps_0_f2h_axi_slave_arprot    => CONNECTED_TO_hps_0_f2h_axi_slave_arprot,    --                    .arprot
			hps_0_f2h_axi_slave_arvalid   => CONNECTED_TO_hps_0_f2h_axi_slave_arvalid,   --                    .arvalid
			hps_0_f2h_axi_slave_arready   => CONNECTED_TO_hps_0_f2h_axi_slave_arready,   --                    .arready
			hps_0_f2h_axi_slave_aruser    => CONNECTED_TO_hps_0_f2h_axi_slave_aruser,    --                    .aruser
			hps_0_f2h_axi_slave_rid       => CONNECTED_TO_hps_0_f2h_axi_slave_rid,       --                    .rid
			hps_0_f2h_axi_slave_rdata     => CONNECTED_TO_hps_0_f2h_axi_slave_rdata,     --                    .rdata
			hps_0_f2h_axi_slave_rresp     => CONNECTED_TO_hps_0_f2h_axi_slave_rresp,     --                    .rresp
			hps_0_f2h_axi_slave_rlast     => CONNECTED_TO_hps_0_f2h_axi_slave_rlast,     --                    .rlast
			hps_0_f2h_axi_slave_rvalid    => CONNECTED_TO_hps_0_f2h_axi_slave_rvalid,    --                    .rvalid
			hps_0_f2h_axi_slave_rready    => CONNECTED_TO_hps_0_f2h_axi_slave_rready,    --                    .rready
			memory_mem_a                  => CONNECTED_TO_memory_mem_a,                  --              memory.mem_a
			memory_mem_ba                 => CONNECTED_TO_memory_mem_ba,                 --                    .mem_ba
			memory_mem_ck                 => CONNECTED_TO_memory_mem_ck,                 --                    .mem_ck
			memory_mem_ck_n               => CONNECTED_TO_memory_mem_ck_n,               --                    .mem_ck_n
			memory_mem_cke                => CONNECTED_TO_memory_mem_cke,                --                    .mem_cke
			memory_mem_cs_n               => CONNECTED_TO_memory_mem_cs_n,               --                    .mem_cs_n
			memory_mem_ras_n              => CONNECTED_TO_memory_mem_ras_n,              --                    .mem_ras_n
			memory_mem_cas_n              => CONNECTED_TO_memory_mem_cas_n,              --                    .mem_cas_n
			memory_mem_we_n               => CONNECTED_TO_memory_mem_we_n,               --                    .mem_we_n
			memory_mem_reset_n            => CONNECTED_TO_memory_mem_reset_n,            --                    .mem_reset_n
			memory_mem_dq                 => CONNECTED_TO_memory_mem_dq,                 --                    .mem_dq
			memory_mem_dqs                => CONNECTED_TO_memory_mem_dqs,                --                    .mem_dqs
			memory_mem_dqs_n              => CONNECTED_TO_memory_mem_dqs_n,              --                    .mem_dqs_n
			memory_mem_odt                => CONNECTED_TO_memory_mem_odt,                --                    .mem_odt
			memory_mem_dm                 => CONNECTED_TO_memory_mem_dm,                 --                    .mem_dm
			memory_oct_rzqin              => CONNECTED_TO_memory_oct_rzqin,              --                    .oct_rzqin
			hps_0_emac1_phy_txd_o         => CONNECTED_TO_hps_0_emac1_phy_txd_o,         --         hps_0_emac1.phy_txd_o
			hps_0_emac1_phy_txen_o        => CONNECTED_TO_hps_0_emac1_phy_txen_o,        --                    .phy_txen_o
			hps_0_emac1_phy_txer_o        => CONNECTED_TO_hps_0_emac1_phy_txer_o,        --                    .phy_txer_o
			hps_0_emac1_phy_rxdv_i        => CONNECTED_TO_hps_0_emac1_phy_rxdv_i,        --                    .phy_rxdv_i
			hps_0_emac1_phy_rxer_i        => CONNECTED_TO_hps_0_emac1_phy_rxer_i,        --                    .phy_rxer_i
			hps_0_emac1_phy_rxd_i         => CONNECTED_TO_hps_0_emac1_phy_rxd_i,         --                    .phy_rxd_i
			hps_0_emac1_phy_col_i         => CONNECTED_TO_hps_0_emac1_phy_col_i,         --                    .phy_col_i
			hps_0_emac1_phy_crs_i         => CONNECTED_TO_hps_0_emac1_phy_crs_i,         --                    .phy_crs_i
			hps_0_emac1_gmii_mdo_o        => CONNECTED_TO_hps_0_emac1_gmii_mdo_o,        --                    .gmii_mdo_o
			hps_0_emac1_gmii_mdo_o_e      => CONNECTED_TO_hps_0_emac1_gmii_mdo_o_e,      --                    .gmii_mdo_o_e
			hps_0_emac1_gmii_mdi_i        => CONNECTED_TO_hps_0_emac1_gmii_mdi_i,        --                    .gmii_mdi_i
			hps_0_emac1_ptp_pps_o         => CONNECTED_TO_hps_0_emac1_ptp_pps_o,         --                    .ptp_pps_o
			hps_0_emac1_ptp_aux_ts_trig_i => CONNECTED_TO_hps_0_emac1_ptp_aux_ts_trig_i, --                    .ptp_aux_ts_trig_i
			hps_0_h2f_loan_io_in          => CONNECTED_TO_hps_0_h2f_loan_io_in,          --   hps_0_h2f_loan_io.in
			hps_0_h2f_loan_io_out         => CONNECTED_TO_hps_0_h2f_loan_io_out,         --                    .out
			hps_0_h2f_loan_io_oe          => CONNECTED_TO_hps_0_h2f_loan_io_oe           --                    .oe
		);

