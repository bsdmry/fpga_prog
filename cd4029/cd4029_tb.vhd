library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd4029_tb is
end cd4029_tb;

architecture cd4029_tb_arch of cd4029_tb is
component cd4029 is port (
	clk : in std_logic;
    	bindec: in std_logic;
    	updown: in std_logic;
    	preset_en: in std_logic;
    	carry_in: in std_logic;
    	jam: in std_logic_vector(3 downto 0);
    	output: out std_logic_vector(3 downto 0);
    	carry_out: out std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;
signal bin_dec: std_logic := '0'; --decade
signal direction_cnt: std_logic := '1'; --up
signal set_val: std_logic := '0';
signal carry_in_line: std_logic := '0';
constant new_value_dec: std_logic_vector(3 downto 0) := "0111";
constant new_value_hex: std_logic_vector(3 downto 0) := "1101";
signal new_value: std_logic_vector(3 downto 0) := new_value_dec;
signal cnt_out: std_logic_vector(3 downto 0);
signal cnt_out2: std_logic_vector(3 downto 0);
signal carry_out_signal1: std_logic;
signal carry_out_signal2: std_logic;
begin
--	UNIT UNDER TEST
uut: cd4029 port map (
	clk => clk,
	bindec => bin_dec,
	updown => direction_cnt,
	preset_en => set_val,
	carry_in => carry_in_line,
	jam => new_value,
	output => cnt_out,
	carry_out => carry_out_signal1

);
uut2: cd4029 port map (
	clk => clk,
	bindec => bin_dec,
	updown => direction_cnt,
	preset_en => set_val,
	carry_in => carry_out_signal1,
	jam => new_value,
	output => cnt_out2,
	carry_out => carry_out_signal2

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
	wait for 3000 ns;
	direction_cnt <= '0';
	wait for 3000 ns;
	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end cd4029_tb_arch;

