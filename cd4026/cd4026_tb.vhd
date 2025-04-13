library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd4026_tb is
end cd4026_tb;

architecture cd4026_tb_arch of cd4026_tb is
component cd4026 is port (
	clk : in std_logic;
	rst: in std_logic;
	inhibit: in std_logic;
	disp_en_in: in std_logic;
	disp_en_out: out std_logic;
	segments: out std_logic_vector(6 downto 0); --  0-a, 1-b, ... 6-g
	carry: out std_logic;
	ung_c: out std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;
signal reset_line:  STD_LOGIC := '0';
signal inhibit_line:  STD_LOGIC := '0';
signal display_line:  STD_LOGIC := '1';
signal led: std_logic_vector(6 downto 0);
signal carry_line:  STD_LOGIC;
signal ingated_c_line:  STD_LOGIC;


begin
--	UNIT UNDER TEST
uut: cd4026 port map (
	clk => clk,
	rst=> reset_line,
	inhibit=>inhibit_line,
	disp_en_in=>display_line,
	segments=>led,
	carry=>carry_line,
	ung_c=>ingated_c_line
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
	wait for 30 ns;
	reset_line <= '0';
	wait for 1200 ns;
	display_line<= '0';
	wait for 700 ns;
	display_line<='1';
	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end cd4026_tb_arch;

