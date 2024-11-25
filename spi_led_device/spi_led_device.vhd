library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity spi_led_device is
    Port (
		ext_spi_clk: in std_logic;
		ext_spi_mosi: in std_logic;
		ext_spi_miso: out std_logic;
		ext_spi_cs: in std_logic;
		ledport: out std_logic_vector(4 downto 0) := "11111"
	 );
end spi_led_device;

architecture spi_led_device_arch of spi_led_device is
component spi_slave_drv is port (
	clk : in std_logic;
	mosi: in std_logic;
	miso: out std_logic;
	ss: in std_logic;
	master_rcv: out std_logic_vector(15 downto 0);
	slave_trx: in std_logic_vector(15 downto 0);
	cmd_bit_len: in natural range 0 to 14;
	cmd_ready: out std_logic;
	done: out std_logic
	);
end component;

signal incoming_cmd: std_logic;
signal incoming_data: std_logic_vector(15 downto 0);
signal outcoming_data: std_logic_vector(15 downto 0) := x"0000";
signal end_transmission: std_logic;
signal trx_done:  std_logic;
signal display_data: std_logic_vector(1 downto 0) := "00";

constant cmd_len: natural := 3;
begin
	drv : spi_slave_drv port map(
	clk => ext_spi_clk,
	mosi => ext_spi_mosi,
	miso => ext_spi_miso,
	ss => ext_spi_cs,
	master_rcv => incoming_data,
	slave_trx => outcoming_data,
	cmd_ready => incoming_cmd,
	done => end_transmission,
	cmd_bit_len => cmd_len
);

	process(incoming_cmd) begin
		if rising_edge(incoming_cmd) then
			case incoming_data(15 downto 12) is
				when "1000" => -- lit all
						display_data <= "01";
						outcoming_data <= x"000A";
				when "1001" => 	-- lit on only requested
						display_data <= "10";
						outcoming_data <= x"000B";
				when others => 
						display_data <= "00";
						outcoming_data <= x"0DED";
			end case;
		end if;
	end process;

	process(end_transmission) begin
		if rising_edge(end_transmission) then
			case display_data is
				when "01" => ledport <= "00000";
				when "10" => ledport <= not incoming_data(4 downto 0);
				when others => ledport <= "11111";
			end case;
		end if;
	end process;
end spi_led_device_arch;

