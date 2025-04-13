library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity bcd2sseg_tb is
end bcd2sseg_tb;

architecture bcd2sseg_tb_arch of bcd2sseg_tb is
component bcd2sseg is port (
		b0 : in  std_logic;
		b1 : in  std_logic;
		b2 : in  std_logic;
		b3 : in  std_logic;
		a : out  std_logic;
		b : out  std_logic;
		c : out  std_logic;
		d : out  std_logic;
		e : out  std_logic;
		f : out  std_logic;
		g : out  std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
signal val: std_logic_vector(3 downto 0) := "0000";
signal dig: std_logic_vector(6 downto 0) := "0000000";
signal dig_inv: std_logic_vector(6 downto 0) := "0000000";
constant clk_period : time := 50 ns;

begin
dig_inv <= not dig;
--	UNIT UNDER TEST
uut: bcd2sseg port map (
	b0 => val(0),
	b1 => val(1),
	b2 => val(2),
	b3 => val(3),
	a => dig(0),
	b => dig(1),
	c => dig(2),
	d => dig(3),
	e => dig(4),
	f => dig(5),
	g => dig(6)
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
	val <= "0001"; --1
	wait for 50 ns;
	val <= "0010"; --2
	wait for 50 ns;
	val <= "0011"; --3
	wait for 50 ns;
	val <= "0100"; --4
	wait for 50 ns;
	val <= "0101"; --5
	wait for 50 ns;
	val <= "0110"; --6
	wait for 50 ns;
	val <= "0111"; --7
	wait for 50 ns;
	val <= "1000"; --8
	wait for 50 ns;
	val <= "1001"; --9
	wait for 50 ns;
	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end bcd2sseg_tb_arch;

