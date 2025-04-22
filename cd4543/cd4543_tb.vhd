library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd4543_tb is
end cd4543_tb;

architecture cd4543_tb_arch of cd4543_tb is
component cd4543 is port (
		le_n : in std_logic;
		d: in std_logic_vector(3 downto 0);
		ph: in std_logic;
		bl: in std_logic;
		q: out std_logic_vector(6 downto 0)
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;
signal latch: std_logic := '0';
signal bcd: std_logic_vector(3 downto 0);
signal seg: std_logic_vector(6 downto 0);
signal ph_sig: std_logic := '0';
signal blank: std_logic := '0';


begin
--	UNIT UNDER TEST
uut: cd4543 port map (
	le_n => latch,
	d => bcd,
	ph => ph_sig,
	bl => blank,
	q => seg
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
	bcd <= "0000";
	wait for 30 ns;
	latch <= '1';
	wait for 30 ns;
	bcd <= "0001";
	wait for 30 ns;
	bcd <= "0010";
	wait for 30 ns;
	bcd <= "0011";
	wait for 30 ns;
	bcd <= "0100";
	wait for 30 ns;
	bcd <= "0101";
	wait for 30 ns;
	bcd <= "0110";
	wait for 30 ns;
	bcd <= "0111";
	wait for 30 ns;
	bcd <= "1000";
	wait for 30 ns;
	bcd <= "1001";
	wait for 30 ns;
	blank<= '1';
	wait for 30 ns;
	ph_sig<= '1';
	wait for 30 ns;
	blank<= '0';

	latch <= '0';
	wait for 30 ns;
	bcd <= "0000";
	wait for 30 ns;
	bcd <= "0001";
	wait for 30 ns;
	bcd <= "0010";
	wait for 30 ns;
	latch <= '1';
	wait for 30 ns;
	bcd <= "0011";
	wait for 30 ns;
	bcd <= "0100";
	wait for 30 ns;
	bcd <= "0101";
	wait for 30 ns;
	bcd <= "0110";
	wait for 30 ns;
	bcd <= "0111";
	wait for 30 ns;
	bcd <= "1000";
	wait for 30 ns;
	bcd <= "1001";
	wait for 30 ns;

	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end cd4543_tb_arch;

