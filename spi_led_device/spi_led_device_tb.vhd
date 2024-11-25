library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity spi_led_device_tb is
end spi_led_device_tb;

architecture spi_led_device_tb_arch of spi_led_device_tb is
component spi_led_device is port (
		ext_spi_clk: in std_logic;
		ext_spi_mosi: in std_logic;
		ext_spi_miso: out std_logic;
		ext_spi_cs: in std_logic;
		ledport: out std_logic_vector(4 downto 0)
	);
end component;

signal spi_clk:  STD_LOGIC;
signal spi_mosi:  STD_LOGIC;
signal spi_miso:  STD_LOGIC;
signal spi_cs:  STD_LOGIC;
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;

signal led_out: std_logic_vector(4 downto 0);
signal cmd_buf: std_logic_vector(15 downto 0);

procedure spiMasterTx(
	signal fclk: out std_logic; 
	signal fss_out: out std_logic;
	signal fmosi_out: out std_logic;
	signal fcmd_buf: in std_logic_vector(15 downto 0)
) is
begin
	fss_out <= '0';
	wait for clk_period;
	for i in fcmd_buf'range loop
		fmosi_out <= fcmd_buf(i);
		fclk <= '0';
		wait for clk_period/2;
		fclk <= '1';
		wait for clk_period/2;
	end loop;
	fclk <= '0';
	wait for clk_period;
	fss_out <= '1';
end procedure spiMasterTx;

begin
--	UNIT UNDER TEST
uut: spi_led_device port map (
	ext_spi_clk => spi_clk,
	ext_spi_mosi => spi_mosi,
	ext_spi_miso => spi_miso,
	ext_spi_cs => spi_cs,
	ledport => led_out
);

--	TEST SIGNALS
stim_process : process
begin
	wait for 30 ns;
	-- INSERT TEST CODE HERE ---
	cmd_buf <= "1000000000000001";
	spiMasterTx(spi_clk, spi_cs, spi_mosi, cmd_buf);	
	wait for 30 ns;
	cmd_buf <= "1001000000000001";
	spiMasterTx(spi_clk, spi_cs, spi_mosi, cmd_buf);	
	wait for 30 ns;
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end spi_led_device_tb_arch;

