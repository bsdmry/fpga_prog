library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd4522_tb is
end cd4522_tb;

architecture cd4522_tb_arch of cd4522_tb is
component cd4522 is port (
	clk : in std_logic;
	rst : in  std_logic;
    	inhibit: in std_logic;
    	preset: in std_logic;
    	carry_in: in std_logic;
    	p: in std_logic_vector(3 downto 0);
    	q: out std_logic_vector(3 downto 0);
    	tc: out std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;
signal reset_line: std_logic := '0';
signal inhibit_line: std_logic := '0';
signal preset_line: std_logic := '0';
signal carry_in_line: std_logic := '1';
signal value: std_logic_vector(3 downto 0) := "1110";
signal cnt_out: std_logic_vector(3 downto 0);
signal tc_line: std_logic;

begin
--	UNIT UNDER TEST
uut: cd4522 port map (
	clk => clk,
	rst => reset_line,
	inhibit => inhibit_line,
	preset => preset_line,
	carry_in => carry_in_line,
	p => value,
	q => cnt_out,
	tc => tc_line
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
	wait for 338 ns;
	reset_line <= '1';
	wait for 30 ns;
	reset_line <= '0';
	wait for 540 ns;
	preset_line <= '1';
	wait for 30 ns;
	preset_line <= '0';
	wait for 1700 ns;
	inhibit_line <= '1';
	wait for 220 ns;
	inhibit_line <= '0';
	wait for 540 ns;

	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end cd4522_tb_arch;

