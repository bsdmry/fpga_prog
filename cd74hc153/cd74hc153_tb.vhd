library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd74hc153_tb is
end cd74hc153_tb;

architecture cd74hc153_tb_arch of cd74hc153_tb is
component cd74hc153 is port (
	mux0in : in std_logic_vector(3 downto 0);
	mux1in : in std_logic_vector(3 downto 0);
    	s0: in std_logic;
    	s1: in std_logic;
    	en0_n: in std_logic;
    	en1_n: in std_logic;
    	out0: out std_logic;
    	out1: out std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;
signal mux0, mux1: std_logic_vector(3 downto 0) := "0000";
signal sel: std_logic_vector(1 downto 0) := "00";
signal en0, en1: std_logic := '0';
signal output1, output0: std_logic;
begin
--	UNIT UNDER TEST
uut: cd74hc153 port map (
	mux0in => mux0,
	mux1in => mux1,
	s0 => sel(0),
	s1 => sel(1),
	en0_n => en0,
	en1_n => en1,
	out0 => output0,
	out1 => output1
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
	mux0 <= "1010";
	mux1 <= "0101";
	wait for 30 ns;
	sel <= "01";
	wait for 30 ns;
	sel <= "10";
	wait for 30 ns;
	sel <= "11";
	wait for 30 ns;
	mux0 <= "1111";
	mux1 <= "1111";
	wait for 30 ns;
	en0 <= '1';
	en1 <= '1';
	wait for 30 ns;
	
	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end cd74hc153_tb_arch;

