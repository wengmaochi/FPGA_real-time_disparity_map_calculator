	component fp_qsys is
		port (
			altpll_100k_clk   : out std_logic;        -- clk
			altpll_100m_clk   : out std_logic;        -- clk
			altpll_100m_1_clk : out std_logic;        -- clk
			altpll_12_5m_clk  : out std_logic;        -- clk
			altpll_25m_clk    : out std_logic;        -- clk
			clk_clk           : in  std_logic := 'X'; -- clk
			reset_reset_n     : in  std_logic := 'X'  -- reset_n
		);
	end component fp_qsys;

	u0 : component fp_qsys
		port map (
			altpll_100k_clk   => CONNECTED_TO_altpll_100k_clk,   --   altpll_100k.clk
			altpll_100m_clk   => CONNECTED_TO_altpll_100m_clk,   --   altpll_100m.clk
			altpll_100m_1_clk => CONNECTED_TO_altpll_100m_1_clk, -- altpll_100m_1.clk
			altpll_12_5m_clk  => CONNECTED_TO_altpll_12_5m_clk,  --  altpll_12_5m.clk
			altpll_25m_clk    => CONNECTED_TO_altpll_25m_clk,    --    altpll_25m.clk
			clk_clk           => CONNECTED_TO_clk_clk,           --           clk.clk
			reset_reset_n     => CONNECTED_TO_reset_reset_n      --         reset.reset_n
		);

