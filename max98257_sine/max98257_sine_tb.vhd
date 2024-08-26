library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity max98257_sine_tb is

end max98257_sine_tb;

architecture max98257_sine_tb_arch of max98257_sine_tb is
component max98257_sine is
    Port ( 
	drv_clk : in  STD_LOGIC;
	max98257_bclk : out  STD_LOGIC := '0';
	max98257_lrclk: out STD_LOGIC := '0';
	max98257_data: out STD_LOGIC := '0';
	max98257_enable: out STD_LOGIC := '0'
);

end component;

signal clk:  STD_LOGIC := '1';
signal bclk: std_logic := '0';
signal lrclk: std_logic := '0';
signal data: std_logic := '0';
signal en: std_logic := '0';

constant clk_period : time := 1953 ns;
signal sym_stop: STD_LOGIC := '0';

begin
uut: max98257_sine port map (
	drv_clk => clk,
	max98257_bclk => bclk,
	max98257_lrclk => lrclk,
	max98257_data => data,	
	max98257_enable => en
);

clk_process: process
begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
	if sym_stop = '1' then
		wait;
	end if;
end process;

delay_process : process
begin
	wait for 30 ns;
	wait for 20 ms;
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;


end max98257_sine_tb_arch;

