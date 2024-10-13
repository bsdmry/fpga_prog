library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity uart_rx2led_tb is
end uart_rx2led_tb;

architecture uart_rx2led_tb_arch of uart_rx2led_tb is
component uart_rx2led is port (
	clk : in std_logic;
	   rx_pin: in std_logic;
	   tx_pin: out std_logic;
	   ascii2led: out std_logic_vector(7 downto 0);
	   button_tx: in std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;

signal leds: std_logic_vector(7 downto 0) := x"00";
signal rx_line: std_logic := '1';
signal tx_line: std_logic;
signal button: std_logic := '0';

begin
--	UNIT UNDER TEST
uut: uart_rx2led port map (
	clk => clk,
	ascii2led => leds,
	rx_pin => rx_line,
	tx_pin => tx_line,
	button_tx => button
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
	wait for 300 ns;
	-- INSERT TEST CODE HERE ---
	button <= '1';
	wait for 600 ns;
	button <= '0';
	
	wait for 1 ms;
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end uart_rx2led_tb_arch;

