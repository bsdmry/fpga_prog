library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Gowin_rPLL is
    port (
        clkout: out std_logic;
        lock: out std_logic;
        clkoutd3: out std_logic;
        clkin: in std_logic
    );
end Gowin_rPLL;

architecture Gowin_rPLL_arch of Gowin_rPLL is
    signal clkoutp_o: std_logic;
    signal clkoutd_o: std_logic;
    signal gw_gnd: std_logic;
    signal FBDSEL_i: std_logic_vector(5 downto 0);
    signal IDSEL_i: std_logic_vector(5 downto 0);
    signal ODSEL_i: std_logic_vector(5 downto 0);
    signal PSDA_i: std_logic_vector(3 downto 0);
    signal DUTYDA_i: std_logic_vector(3 downto 0);
    signal FDLY_i: std_logic_vector(3 downto 0);

    component rPLL
        generic (
            FCLKIN: in string := "27";
            DEVICE: in string := "GW2A-18";
            DYN_IDIV_SEL: in string := "false";
            IDIV_SEL: in integer := 0;
            DYN_FBDIV_SEL: in string := "false";
            FBDIV_SEL: in integer := 0;
            DYN_ODIV_SEL: in string := "false";
            ODIV_SEL: in integer := 8;
            PSDA_SEL: in string := "0000";
            DYN_DA_EN: in string := "false";
            DUTYDA_SEL: in string := "1000";
            CLKOUT_FT_DIR: in bit := '1';
            CLKOUTP_FT_DIR: in bit := '1';
            CLKOUT_DLY_STEP: in integer := 0;
            CLKOUTP_DLY_STEP: in integer := 0;
            CLKOUTD3_SRC: in string := "CLKOUT";
            CLKFB_SEL: in string := "internal";
            CLKOUT_BYPASS: in string := "false";
            CLKOUTP_BYPASS: in string := "false";
            CLKOUTD_BYPASS: in string := "false";
            CLKOUTD_SRC: in string := "CLKOUT";
            DYN_SDIV_SEL: in integer := 2
        );
	-- https://www.gowinsemi.com/upload/database_doc/1844/document/66b611c9e1881.pdf
	-- The PLL reference clock source can come from an external PLL pin or
	-- from internal routing GCLK, HCLK, or general data signal. PLL feedback
	-- signal can come from the external PLL feedback input or from internal
	-- routing GCLK, HCLK, or general data signal

	-- CLKIN 	I	Reference clock input
	-- CLKFB 	I 	Feedback clock input
	-- RESET 	I 	PLL reset
	-- RESET_P 	I 	PLL Power Down
	-- IDSEL [5:0] 	I 	Dynamic IDIV control: 1~64
	-- FBDSEL [5:0] I 	Dynamic FBDIV control:1~64
	-- PSDA [3:0] 	I 	Dynamic phase control (rising edge effective)
	-- DUTYDA [3:0] I 	Dynamic duty cycle control (falling edge effective)
	-- FDLY[3:0] 	I 	CLKOUTP dynamic delay control
	-- CLKOUT 	O 	Clock output with no phase and duty cycle adjustment
	-- CLKOUTP 	O 	Clock output with phase and duty cycle adjustment
	-- CLKOUTD 	O 	Clock divider from CLKOUT and CLKOUTP (controlled by SDIV)
	-- CLKOUTD3 	O	clock divider from CLKOUT and CLKOUTP (controlled by DIV3 with the constant division value 3)
	-- LOCK 	O	PLL lock status: 1 - locked, 0 - unlocked

	
        port (
            CLKOUT: out std_logic;
            LOCK: out std_logic;
            CLKOUTP: out std_logic;
            CLKOUTD: out std_logic;
            CLKOUTD3: out std_logic;
            RESET: in std_logic;
            RESET_P: in std_logic;
            CLKIN: in std_logic;
            CLKFB: in std_logic;
            FBDSEL: in std_logic_vector(5 downto 0);
            IDSEL: in std_logic_vector(5 downto 0);
            ODSEL: in std_logic_vector(5 downto 0);
            PSDA: in std_logic_vector(3 downto 0);
            DUTYDA: in std_logic_vector(3 downto 0);
            FDLY: in std_logic_vector(3 downto 0)
        );
    end component;


begin
    gw_gnd <= '0';

    FBDSEL_i <= gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd;
    IDSEL_i <= gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd;
    ODSEL_i <= gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd & gw_gnd;
    PSDA_i <= gw_gnd & gw_gnd & gw_gnd & gw_gnd;
    DUTYDA_i <= gw_gnd & gw_gnd & gw_gnd & gw_gnd;
    FDLY_i <= gw_gnd & gw_gnd & gw_gnd & gw_gnd;
    -- Gens 9 Mhz from 27 Mhz 
    -- CLKOUT = FCLKIN * (FBDIV_SEL+1) / (IDIV_SEL+1) 
    rpll_inst: rPLL
        generic map (
            FCLKIN => "27", 		-- Input frequency
            DEVICE => "GW2A-18C",
            DYN_IDIV_SEL => "false", 	-- no on-fly IDIV coefficent change
            IDIV_SEL => 2,		-- STATIC IDIV 0~63
            DYN_FBDIV_SEL => "false", 	-- no on-fly FBDIV coefficent change
            FBDIV_SEL => 0,		-- STATIC FBDIV 0~63
            DYN_ODIV_SEL => "false", 	-- no on-fly ODIV coefficent change
            ODIV_SEL => 64,		-- STATIC ODIV  2,4,8,16,32,48,64,80,96,112,128
            PSDA_SEL => "0000",		-- STATIC phase adj
            DYN_DA_EN => "true",	-- on-fly phase and duty cycle adj
            DUTYDA_SEL => "1000",	-- STATIC duty cycle
            CLKOUT_FT_DIR => '1',	-- CLKOUT trim direction (1 - decrease)
            CLKOUTP_FT_DIR => '1',	-- CLKOUTP trim direction setting (1 - decrease)
            CLKOUT_DLY_STEP => 0,	-- CLKOUT trim coefficient CLKOUT_DLY_STEP*delay (delay=50ps)
            CLKOUTP_DLY_STEP => 0,	-- CLKOUTP trim coefficient CLKOUTP_DLY_STEP*delay (delay=50ps)
            CLKFB_SEL => "internal",	-- CLKFB source selection "internal" - Feedback from internal CLKOUT
            CLKOUT_BYPASS => "false",	-- Pass CLKIN to CLKOUT	
            CLKOUTP_BYPASS => "false",	-- Pass CLKIN to CLKOUTP
            CLKOUTD_BYPASS => "false",	-- Pass CLKIN to CLKOUTD
            DYN_SDIV_SEL => 2,		-- STATIC SDIV
            CLKOUTD_SRC => "CLKOUT",	-- CLKOUTD source selection
            CLKOUTD3_SRC => "CLKOUT"	-- CLKOUTD3 source selection
        )
        port map (
            CLKOUT => clkout,
            LOCK => lock,
            CLKOUTP => clkoutp_o,
            CLKOUTD => clkoutd_o,
            CLKOUTD3 => clkoutd3,
            RESET => gw_gnd,
            RESET_P => gw_gnd,
            CLKIN => clkin,
            CLKFB => gw_gnd,
            FBDSEL => FBDSEL_i,
            IDSEL => IDSEL_i,
            ODSEL => ODSEL_i,
            PSDA => PSDA_i,
            DUTYDA => DUTYDA_i,
            FDLY => FDLY_i
        );

end Gowin_rPLL_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity gowin_pll_test is
    port (
        clkout: out std_logic;
        lock: out std_logic;
        clkoutd: out std_logic;
        clkin: in std_logic
    );
end gowin_pll_test;

architecture gowin_pll_test_arch of gowin_pll_test is
component Gowin_rPLL
    port (
        clkout: out std_logic;
        lock: out std_logic;
        clkoutd3: out std_logic;
        clkin: in std_logic
    );
end component;
 
begin
inst: Gowin_rPLL
port map(
	clkout => clkout,
	lock => lock,
	clkoutd3 => clkoutd,
	clkin => clkin
);
end gowin_pll_test_arch;

