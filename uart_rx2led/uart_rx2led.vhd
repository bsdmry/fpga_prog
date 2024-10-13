library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity uart_rx2led is
    Port ( clk : in  STD_LOGIC; --2304 kHz for 115200
	   rx_pin: in std_logic;
	   tx_pin: out std_logic;
	   ascii2led: out std_logic_vector(7 downto 0);
	   button_tx: in std_logic
	 );
end uart_rx2led;

architecture uart_rx2led_arch of uart_rx2led is
component uart is port(
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

signal div_clk: std_logic := '1';
signal rx_ready: std_logic;
constant tx_byte_in: std_logic_vector := x"2a";
signal tx_ready: std_logic;
signal tx_send: std_logic := '0';

begin

device:	uart port map (
	clk => div_clk,
	rx => rx_pin,
	tx => tx_pin,
	rx_byte_out  => ascii2led,
	rx_ready => rx_ready,
	tx_byte_in => tx_byte_in,
	tx_ready => tx_ready,
	tx_send => tx_send	
);
	process(div_clk) begin
		if rising_edge(div_clk) then
			if button_tx = '0' then
				if tx_ready = '1' then
					tx_send <= '1';
				end if;
			else
				tx_send <= '0';
			end if;
		end if;
	end process;
	
	process(clk) 
	variable div: natural range 0 to 4 := 0;
	begin
		if rising_edge(clk) then
			if div = 4 then
				div := 0;
				div_clk <= div_clk xor '1';
			else
				div := div +1;
			end if;
		end if;
	end process;

end uart_rx2led_arch;

