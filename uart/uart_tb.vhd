library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity uart_tb is
end uart_tb;

architecture uart_tb_arch of uart_tb is
component uart is port (
	clk : in std_logic;
	   rx: in std_logic;
	   rx_byte_out: out std_logic_vector( 7 downto 0);
	   rx_ready: out std_logic;
	   tx: out std_logic;
	   tx_byte_in: in std_logic_vector( 7 downto 0);
	   tx_ready: out std_logic;
	   tx_send: in std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;
constant uart_period : time := clk_period * 2;

signal input_rx: std_logic := '1';
signal byte_from_pc: std_logic_vector( 7 downto 0);
signal rx_ready_flag: std_logic;
signal byte_to_pc: std_logic_vector( 7 downto 0) := x"2a"; -- * sign
signal tx_done: std_logic;
signal send_flag: std_logic := '0';

constant frompc: std_logic_vector(9 downto 0) := "0001000111"; --# sign

begin
--	UNIT UNDER TEST
uut: uart port map (
	clk => clk,
	rx => input_rx,
	rx_byte_out => byte_from_pc,
	rx_ready => rx_ready_flag,
	tx_byte_in => byte_to_pc,
	tx_ready => tx_done,
	tx_send => send_flag
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
tx_process : process
begin
	wait for 70 ns;
	-- INSERT TEST CODE HERE ---
	send_flag <= '1';
	wait for 30 ns;
	send_flag <= '0';

	wait for 5 us;	
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

rx_process: process
begin
	wait for 30 ns;

	input_rx <= '0'; wait for uart_period;
	input_rx <= '1'; wait for uart_period;
	input_rx <= '1'; wait for uart_period;
	input_rx <= '0'; wait for uart_period;
	input_rx <= '0'; wait for uart_period;
	input_rx <= '0'; wait for uart_period;
	input_rx <= '1'; wait for uart_period;
	input_rx <= '0'; wait for uart_period;
	input_rx <= '0'; wait for uart_period;
	input_rx <= '1'; wait for uart_period;
	--for i in 9 to 0 loop
	--	input_rx <= frompc(i);
	--	wait for uart_period;	
	--end loop;
wait;
end process;



end uart_tb_arch;

