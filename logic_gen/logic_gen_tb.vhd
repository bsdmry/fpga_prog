library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity logic_gen_tb is
end logic_gen_tb;

architecture logic_gen_tb_arch of logic_gen_tb is
component logic_gen is port (
	clk : in std_logic;
    	up: in std_logic;
    	down: in std_logic;
    	divclk: out std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
signal up_btn: std_logic := '0';
signal down_btn: std_logic := '0';
signal div_clk: std_logic;
constant clk_period : time := 50 ns;

begin
--	UNIT UNDER TEST
uut: logic_gen port map (
	clk => clk,
	up => up_btn,
	down => down_btn,
	divclk => div_clk
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
	wait for 800 ns;
	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end logic_gen_tb_arch;

