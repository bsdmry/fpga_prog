library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mul10x_tb is
end mul10x_tb;

architecture mul10x_tb_arch of mul10x_tb is
component mul10x is port (
	inval: in std_logic_vector(3 downto 0);
	outval: out std_logic_vector(7 downto 0)
	);
end component;
component mul100x is port (
	inval: in std_logic_vector(3 downto 0);
	outval: out std_logic_vector(11 downto 0)
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;
signal val: std_logic_vector(3 downto 0) := "0000";
signal result: std_logic_vector(7 downto 0) := x"00";
signal result100: std_logic_vector(11 downto 0) := "000000000000";

begin
--	UNIT UNDER TEST
uut: mul10x port map (
	inval => val,
	outval => result
);
uut1: mul100x port map (
	inval => val,
	outval => result100
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
	val <= std_logic_vector(to_unsigned(15, 4));
	wait for 30 ns;
	val <= std_logic_vector(to_unsigned(6, 4));
	wait for 30 ns;
	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end mul10x_tb_arch;

