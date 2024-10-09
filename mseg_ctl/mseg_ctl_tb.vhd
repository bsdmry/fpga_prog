library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mseg_ctl_tb is
end mseg_ctl_tb;

architecture mseg_ctl_tb_arch of mseg_ctl_tb is
component mseg_ctl is port (
	clk : in std_logic;
	spi_clk_div: in std_logic_vector(3 downto 0);
	spi_clk: out std_logic;
	spi_data: out std_logic;
	spi_cs: out std_logic;
	symbol: in std_logic_vector(15 downto 0);
	dot: in std_logic;
	position: in std_logic_vector(2 downto 0);
	clear: in std_logic;
	set: in std_logic
    	--dbg_state: out std_logic_vector(2 downto 0);
	--dbg_index: out natural range 0 to 31
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 6 ns;
constant led_symbol: std_logic_vector(15 downto 0) := x"dd50";
constant scale_factor: std_logic_vector(3 downto 0) := "0001";
signal set_signal: std_logic := '0';
signal clear_signal: std_logic := '0';

signal out_spi_clk: std_logic;
signal out_spi_data: std_logic;
signal out_spi_cs: std_logic;

begin
--	UNIT UNDER TEST
uut: mseg_ctl port map (
	clk => clk,
	spi_clk_div => scale_factor,
	symbol => led_symbol,
	dot => '0',
	position => "001",
	set => set_signal,
	clear => clear_signal,
	spi_clk => out_spi_clk,
	spi_data => out_spi_data,
	spi_cs => out_spi_cs
);
--	CLK GENERATOR
clk_process : process 
begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
	if sym_stop = '1' then
		wait;
	end if;
end process;

--	TEST SIGNALS
stim_process : process
begin
	wait for 30 ns;
	-- INSERT TEST CODE HERE ---
	clear_signal <= '1';
	set_signal <= '1';
	wait for 30 ns;
	clear_signal <= '0';
	set_signal <= '0';
	wait for 30 ns;

	set_signal <= '1';
	wait for 30 ns;
	set_signal <= '0';
	wait for 10 us;
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end mseg_ctl_tb_arch;

