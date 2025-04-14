library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity add_sub_tb is
end add_sub_tb;

architecture add_sub_tb_arch of add_sub_tb is
component add_sub4 is port (
		mode : in std_logic; -- '0' - add/ '1' - sub
		a: in std_logic_vector(3 downto 0);
		b: in std_logic_vector(3 downto 0);
		carry: out std_logic;
		result: out std_logic_vector(3 downto 0)
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;

signal op1, op2, r: std_logic_vector(3 downto 0);
signal op_type: std_logic := '0'; --sum
signal carry_flag: std_logic; --sum
begin
--	UNIT UNDER TEST
uut: add_sub4 port map (
	mode => op_type,
	a => op1,
	b=>op2,
	result=>r,
	carry=>carry_flag
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
	op1<=std_logic_vector(to_unsigned(5, 4));
	op2<=std_logic_vector(to_unsigned(3, 4));
	wait for 30 ns;
	op1<=std_logic_vector(to_unsigned(14, 4));
	op2<=std_logic_vector(to_unsigned(4, 4));
	wait for 30 ns;
	op_type<='1'; --substraction
	op1<=std_logic_vector(to_unsigned(7, 4));
	op2<=std_logic_vector(to_unsigned(6, 4));
	wait for 30 ns;
	op1<=std_logic_vector(to_unsigned(2, 4));
	op2<=std_logic_vector(to_unsigned(5, 4));
	

	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end add_sub_tb_arch;

