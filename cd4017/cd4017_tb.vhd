library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd4017_tb is
end cd4017_tb;

architecture cd4017_tb_arch of cd4017_tb is
component cd4017 is port (
	clk : in std_logic;
	inhibit: in std_logic;
	rst: in std_logic;
	output: out std_logic_vector(9 downto 0);
	carry: out std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal inhibit_line: std_logic := '0';
signal reset_line: std_logic := '0';
signal data_out:  std_logic_vector(9 downto 0);
signal carry_line: std_logic;
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;

begin
--	UNIT UNDER TEST
uut: cd4017 port map (
	clk => clk,
	inhibit => inhibit_line,
	rst => reset_line,
	output => data_out,
	carry => carry_line
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
	reset_line <= '1';
	wait for 75 ns;
	reset_line <= '0';
	
	wait for 1300 ns;
	inhibit_line <= '1';
	wait for 200 ns;
	inhibit_line <= '0';
	wait for 400 ns;
	reset_line <= '1';
	wait for 50 ns;
	reset_line <= '0';
	wait for 400 ns;
	
	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end cd4017_tb_arch;

