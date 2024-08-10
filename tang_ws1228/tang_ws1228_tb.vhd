library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tang_ws1228_tb is
end tang_ws1228_tb;

architecture tang_ws1228_arch_tb of tang_ws1228_tb is
component tang_ws1228 is port (
	inclk_20mhz : in  STD_LOGIC;
	button: in STD_LOGIC;
	output: out STD_LOGIC);
end component;

signal clk:  STD_LOGIC := '1';
signal btn:  STD_LOGIC := '1';
signal outd:  STD_LOGIC;
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;

begin
uut: tang_ws1228 port map (
	inclk_20mhz => clk,
	button => btn,
	output => outd
);

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


stim_process : process
begin
	wait for 60 ns;
	btn <= '0';
	wait for 13 ns;
	btn <= '1';
	wait for 7 ns;
	btn <= '0';

	wait for 400 ns;
	btn <= '1';
	wait for 60 us;
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end;
