library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity spi_out_test is
    Port ( clk : in  STD_LOGIC;
	   mosi: out STD_LOGIC := '0';
	   miso: in STD_LOGIC;
	   spi_clk: out STD_LOGIC := '0';
	   cs: out STD_LOGIC := '1'
	 );
end spi_out_test;

architecture spi_out_test_arch of spi_out_test is
constant data1: std_logic_vector( 7 downto 0) := x"31";
constant data2: std_logic_vector( 7 downto 0) := x"0A";
signal index: natural range 0 to 7 := 0;
signal state: std_logic_vector(1 downto 0) := "00";
signal spi_clk_step: natural range 0 to 3 := 0;
signal divclk: std_logic := '0';
signal divcnt: natural range 0 to 4 := 0;
signal outbyte: std_logic_vector( 7 downto 0) := x"00";
begin
	process(divclk) begin
	if rising_edge(divclk) then
		case state is
			when "00" =>
				cs <= '0';
				outbyte <= data1;
				state <= "01";
			when "01" => 
				mosi <= outbyte(index);
				spi_clk_step <= 0;
				state <= "10";
			when "10" =>
				case spi_clk_step is
					when 0 =>
						spi_clk <= '1';
						spi_clk_step <= 1;
					when 1 =>
						spi_clk_step <= 2;	
					when 2 =>
						spi_clk <= '0';
						if index = 7 then
							index <= 0;
							spi_clk_step <= 0;
							state <= "11";
						else 
							index <= index + 1;
							spi_clk_step <= 3;
						end if;
					when 3 =>
						mosi <= outbyte(index);
						spi_clk_step <= 0;
					when others =>
				end case;
			when "11" => 
				cs <= '1';
				state <= "00";
			when others =>
			end case;
	end if;
	end process;

	process(clk) begin
		if rising_edge(clk) then
			if divcnt = 4 then
				divcnt <= 0;
				divclk <= divclk xor '1';
			else
				divcnt <= divcnt + 1;
			end if;
		end if;
	end process;
end spi_out_test_arch;

