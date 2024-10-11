library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity uart is
    Port ( clk : in  STD_LOGIC; -- must be 2x from UART speed
	   rx: in std_logic;
	   rx_byte_out: out std_logic_vector( 7 downto 0) := x"00";
	   rx_ready: out std_logic := '0';
	   tx: out std_logic := '1';
	   tx_byte_in: in std_logic_vector( 7 downto 0);
	   tx_ready: out std_logic := '0';
	   tx_send: in std_logic
	 );
end uart;

architecture uart_arch of uart is
signal rx_buffer: std_logic_vector( 7 downto 0) := x"00";
signal rx_fsm_state: std_logic_vector(2 downto 0) := "000"; 
signal tx_buffer: std_logic_vector( 7 downto 0) := x"00";
signal tx_fsm_state: std_logic_vector(2 downto 0) := "000"; 

begin
	process(clk) 
	variable rx_buffer_index: natural range 0 to 7 := 0; 
	begin
	if rising_edge(clk) then
		case rx_fsm_state is
			when "000" => -- Start bit detect
				if rx = '0' then 
					rx_fsm_state <= "001";
					rx_ready <= '0';
					rx_buffer <= x"00"; 
				end if;
			when "001" => --Start bit check
				if rx = '0' then
					rx_fsm_state <= "010";
				else
					rx_fsm_state <= "000";
				end if;
			when "010" => --RX bit start
				rx_fsm_state <= "011";
			when "011" => --RX bit read
				rx_buffer(rx_buffer_index) <= rx;
				if rx_buffer_index = 7 then
					rx_fsm_state <= "100";
					rx_buffer_index := 0;
				else
					rx_fsm_state <= "010";
					rx_buffer_index := rx_buffer_index + 1;
				end if;
			when "100" => --Stop bit detect
				if rx = '1' then
					rx_fsm_state <= "101";
				else
					rx_fsm_state <= "000";
				end if;
			when "101" => --Stop bit check
				if rx = '1' then
					rx_byte_out <= rx_buffer;
					rx_ready <= '1';
				end if;
				rx_fsm_state <= "000";
			when others =>
		end case;	
	end if;
	end process;

	process(clk)
	variable tx_buffer_index: natural range 0 to 7 := 0;
	begin
	if rising_edge(clk) then
		case tx_fsm_state is
			when "000" => --Transmittions start check
				if tx_send = '1' then
					tx_buffer <= tx_byte_in;
					tx_ready <= '0';
					tx <= '0';
					tx_fsm_state <= "001";
				end if;
			when "001" => --Start bit end
				tx_fsm_state <= "010";
				tx_buffer_index := 0;
			when "010" => --Bit send start
				tx <= tx_buffer(tx_buffer_index);
				tx_fsm_state <= "011";
			when "011" => --Bit send end
				if tx_buffer_index = 7 then
					tx_fsm_state <= "100";
					tx_buffer_index := 0;
				else
					tx_buffer_index := tx_buffer_index + 1;
					tx_fsm_state <= "010";
				end if;
			when "100" => -- Stop bit start
				tx <= '1';
				tx_fsm_state <= "101";
			when "101" =>
				tx_ready <= '1';
				tx_buffer <= x"00";
				tx_fsm_state <= "000";
			when others =>
		end case;
	end if;
	end process;
end uart_arch;

