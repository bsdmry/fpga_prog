library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity 16seg_led_example_tb is
end 16seg_led_example_tb;

architecture 16seg_led_example_tb_arch of 16seg_led_example_tb is
component 16seg_led_example is port (
	clk : in std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;

begin
--	UNIT UNDER TEST
uut: 16seg_led_example port map (
	clk => clk
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
	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end 16seg_led_example_tb_arch;

