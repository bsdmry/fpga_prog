library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd74hc85_tb is
end cd74hc85_tb;

architecture cd74hc85_tb_arch of cd74hc85_tb is
component cd74hc85 is port (
		a : in  std_logic_vector(3 downto 0);
		b : in  std_logic_vector(3 downto 0);
		agi, bgi, eqi : in std_logic; --A greter B, B greater A, A equal B
		ago, bgo, eqo : out std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;
signal a_val: std_logic_vector(7 downto 0) := "11111000";
signal b_val: std_logic_vector(7 downto 0) := "00011111";

signal int_ag, int_bg, int_eq: STD_LOGIC;
signal out_ag, out_bg, out_eq: STD_LOGIC;

begin
--	UNIT UNDER TEST
uut0: cd74hc85 port map (
	a => a_val(3 downto 0),
	b => b_val(3 downto 0),
	agi => '0',
	bgi => '0',
	eqi => '1',
	ago => int_ag,
	bgo => int_bg,
	eqo => int_eq
);
uut1: cd74hc85 port map (
	a => a_val(7 downto 4),
	b => b_val(7 downto 4),
	agi => int_ag,
	bgi => int_bg,
	eqi => int_eq,
	ago => out_ag,
	bgo => out_bg,
	eqo => out_eq
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
	a_val <= "00011111";
	b_val <= "11111000";
	wait for 30 ns;
	a_val <= "00110011";
	b_val <= "00110011";
	wait for 30 ns;

	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end cd74hc85_tb_arch;

