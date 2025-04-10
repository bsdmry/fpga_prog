library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd4020_tb is
end cd4020_tb;

architecture cd4020_tb_arch of cd4020_tb is
component cd4020 is port (
	clk : in std_logic;
	rst: in std_logic;
	q: out std_logic_vector(11 downto 0)
	);
end component;

signal clk:  STD_LOGIC := '1';
signal rst: std_logic := '0';
signal outq: std_logic_vector(11 downto 0);
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;

begin
--	UNIT UNDER TEST
uut: cd4020 port map (
	clk => clk,
	rst => rst,
	q => outq
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
	wait for 200 ns;
	rst <= '1';
	wait for 2000 ns;
	rst <= '0';
	wait for 10 ns;
	rst <= '1';
	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end cd4020_tb_arch;

