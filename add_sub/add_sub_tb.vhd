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
		carryin: in std_logic;
		carryout: out std_logic;
		result: out std_logic_vector(3 downto 0)
	);
end component;
component add_sub_bcd is
    port ( 
		mode : in std_logic; -- '0' - add/ '1' - sub
		a: in std_logic_vector(3 downto 0);
		b: in std_logic_vector(3 downto 0);
		carryin: in std_logic;
		carryout: out std_logic;
		result: out std_logic_vector(3 downto 0)
	 );
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;

signal op1, op2, r: std_logic_vector(3 downto 0);
signal opl1, opl2, rl: std_logic_vector(7 downto 0);
signal op_bcd1_0, op_bcd1_1, op_bcd2_0, op_bcd2_1, r_bcd_0, r_bcd_1: std_logic_vector(3 downto 0);
signal op_type, op_type_bcd: std_logic := '0'; --sum
signal carry_flag, carry_flag_bcd0, carry_flag_bcd1, carry_flag_l1, carry_flag_l2: std_logic; --sum

begin
--	UNIT UNDER TEST
uut: add_sub4 port map (
	mode => op_type,
	a => op1,
	b=>op2,
	result=>r,
	carryin=>op_type,
	carryout=>carry_flag
);

uut1: add_sub_bcd port map (
	mode => op_type_bcd,
	a => op_bcd1_0,
	b => op_bcd2_0,
	result => r_bcd_0,
	carryin => op_type_bcd,
	carryout => carry_flag_bcd0
);
uut2: add_sub_bcd port map (
	mode => op_type_bcd,
	a => op_bcd1_1,
	b => op_bcd2_1,
	result => r_bcd_1,
	carryin => carry_flag_bcd0,
	carryout => carry_flag_bcd1
);
uutl1: add_sub4 port map (
	mode => op_type,
	a => opl1(3 downto 0),
	b=>opl2(3 downto 0),
	result=>rl(3 downto 0),
	carryin => op_type,
	carryout=>carry_flag_l1
);
uutl2: add_sub4 port map (
	mode => op_type,
	a => opl1(7 downto 4),
	b=>opl2(7 downto 4),
	result=>rl(7 downto 4),
	carryin => carry_flag_l1,
	carryout=>carry_flag_l2
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

stim_process_l : process
begin
	wait for 30 ns;
	opl1<=std_logic_vector(to_unsigned(101, 8));
	opl2<=std_logic_vector(to_unsigned(13, 8));
	wait for 30 ns;
	opl1<=std_logic_vector(to_unsigned(90, 8));
	opl2<=std_logic_vector(to_unsigned(120, 8));
	wait for 30 ns;
	opl1<=std_logic_vector(to_unsigned(231, 8));
	opl2<=std_logic_vector(to_unsigned(77, 8));
	wait for 30 ns;
	opl1<=std_logic_vector(to_unsigned(150, 8));
	opl2<=std_logic_vector(to_unsigned(150, 8));	
	wait;
end process;

stim2_process : process
begin
	wait for 30 ns;
	op_bcd1_0<=std_logic_vector(to_unsigned(5, 4));
	op_bcd1_1<=std_logic_vector(to_unsigned(2, 4)); --25 
	-- PLUS
	op_bcd2_0<=std_logic_vector(to_unsigned(3, 4));
	op_bcd2_1<=std_logic_vector(to_unsigned(0, 4)); --3
	wait for 30 ns;
	op_bcd1_0<=std_logic_vector(to_unsigned(4, 4));
	op_bcd1_1<=std_logic_vector(to_unsigned(1, 4)); --14 
	-- PLUS
	op_bcd2_0<=std_logic_vector(to_unsigned(9, 4));
	op_bcd2_1<=std_logic_vector(to_unsigned(1, 4)); --19
	wait for 30 ns;
	op_type_bcd<='1'; --substraction
	op_bcd1_0<=std_logic_vector(to_unsigned(3, 4));
	op_bcd1_1<=std_logic_vector(to_unsigned(4, 4)); --43
	-- MINUS
	op_bcd2_0<=std_logic_vector(to_unsigned(8, 4));
	op_bcd2_1<=std_logic_vector(to_unsigned(0, 4)); --8
	wait for 30 ns;
	op_bcd1_0<=std_logic_vector(to_unsigned(1, 4));
	op_bcd1_1<=std_logic_vector(to_unsigned(3, 4)); --31
	-- MINUS
	op_bcd2_0<=std_logic_vector(to_unsigned(1, 4));
	op_bcd2_1<=std_logic_vector(to_unsigned(3, 4)); --31
wait;
end process;

end add_sub_tb_arch;

