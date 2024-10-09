library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mseg_ctl is
    Port ( clk : in  STD_LOGIC;
	spi_clk_div: in std_logic_vector(3 downto 0);
	spi_clk: out std_logic := '0';
	spi_data: out std_logic := '0';
	spi_cs: out std_logic := '1';
	symbol: in std_logic_vector(15 downto 0);
	dot: in std_logic;
	position: in std_logic_vector(2 downto 0);
	clear: in std_logic;
	set: in std_logic
    	--dbg_state: out std_logic_vector(2 downto 0);
	--dbg_index: out natural range 0 to 31
	 );
end mseg_ctl;

architecture mseg_ctl_arch of mseg_ctl is
type char_mem8_32 is array(0 to 7) of std_logic_vector(31 downto 0);
signal symbols: char_mem8_32 := (x"FFFFFF01", x"FFFFFF02", x"FFFFFF04", x"FFFFFF08", 
				 x"FFFFFF10", x"FFFFFF20", x"FFFFFF40", x"FFFFFF80" );
signal divider: std_logic_vector(3 downto 0) := "0000";
signal int_spi_clk: std_logic := '0';

begin
	process(clk)
	variable div_cnt: natural range 0 to 15 := 0;
	variable divided_clk: std_logic := '0';
	begin
		if rising_edge(clk) then
			case div_cnt is
				when 0 => 
					div_cnt := to_integer(unsigned(divider));
					divided_clk := divided_clk xor '1';
					spi_clk <= divided_clk; 
					int_spi_clk <= divided_clk; 
				when others =>
					div_cnt := div_cnt - 1;
			end case;
		end if;
	end process;

	process(int_spi_clk)
	variable symbol_index: natural range 0 to 7 := 0;
	variable bit_index: natural range 0 to 31 := 31;
	variable tx_state: std_logic_vector(2 downto 0) := "000";
	begin
		if falling_edge(int_spi_clk) then
			--dbg_state <= tx_state;
			--dbg_index <= bit_index;
			case tx_state is
				when "000" => 
					spi_cs <= '0'; 
					tx_state := "001";
					spi_data <= symbols(symbol_index)(bit_index);
					bit_index := bit_index - 1;
				when "001" =>
					case bit_index is
						when 0 => 
							spi_data <= symbols(symbol_index)(bit_index);
							bit_index := 31;
							tx_state := "010";

							case symbol_index is
								when  7 => symbol_index := 0;
								when others => symbol_index := symbol_index + 1;
							end case;
						when others => 
							spi_data <= symbols(symbol_index)(bit_index);
							bit_index := bit_index - 1;
					end case;
				when "010" => spi_cs <= '1'; tx_state := "000";
				when others => tx_state := "000";
			end case;
		end if;
	end process;

	process(set) begin
		if rising_edge(set) then
			if clear = '0' then 
				divider <= spi_clk_div;
				symbols(to_integer(unsigned( position)))(31 downto 25) <= "1111111";
				symbols(to_integer(unsigned( position)))(24) <= not dot;

				--symbols(to_integer(unsigned( position)))(23 downto 8) <= not symbol; --WTF? low byte comes first
				symbols(to_integer(unsigned( position)))(23 downto 16) <= not symbol(7 downto 0);
				symbols(to_integer(unsigned( position)))(15 downto 8) <= not symbol(15 downto 8);
			else
				symbols(0) <= x"FFFFFF01";
				symbols(1) <= x"FFFFFF02";
				symbols(2) <= x"FFFFFF04";
				symbols(3) <= x"FFFFFF08";
				symbols(4) <= x"FFFFFF10";
				symbols(5) <= x"FFFFFF20";
				symbols(6) <= x"FFFFFF40";
				symbols(7) <= x"FFFFFF80";
			end if;
		end if;
	end process;
end mseg_ctl_arch;

