library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity spi_out_test_tb is
end spi_out_test_tb;

architecture spi_out_test_tb_arch of spi_out_test_tb is
component spi_out_test is port (
	clk : in std_logic;
	   mosi: out STD_LOGIC;
	   miso: in STD_LOGIC;
	   spi_clk: out STD_LOGIC;
	   cs: out STD_LOGIC
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 5 ns;

signal ext_clk: std_logic;
signal ext_miso: std_logic;
signal ext_mosi: std_logic;
signal ext_cs: std_logic;

begin
--	UNIT UNDER TEST
uut: spi_out_test port map (
	clk => clk,
	spi_clk => ext_clk,
	miso => ext_miso,
	mosi => ext_mosi,
	cs => ext_cs	
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
	wait for 10 us;
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end spi_out_test_tb_arch;

