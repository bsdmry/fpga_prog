library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity seven_seg_tester_tb is
end seven_seg_tester_tb;

architecture seven_seg_tester_tb_arch of seven_seg_tester_tb is
component seven_seg_tester is port (
	clk : in std_logic;
    	segs: out std_logic_vector(7 downto 0);
    	pos: out std_logic_vector(3 downto 0)
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 37 ns; -- ~27 Mhz
--constant clk_period : time := 50 ns; --20 Mhz
signal ssegs: std_logic_vector(6 downto 0);
signal sseg_dp: std_logic;
signal sseg_pos: std_logic_vector(3 downto 0);


begin
--	UNIT UNDER TEST
uut: seven_seg_tester port map (
	clk => clk,
	segs(6 downto 0) => ssegs,
	segs(7) => sseg_dp,
	pos => sseg_pos
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
	wait for 1200 ms;
	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end seven_seg_tester_tb_arch;

