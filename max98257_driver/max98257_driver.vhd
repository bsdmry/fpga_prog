library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity max98257_driver is
    Port ( 
	parallel_in : in  STD_LOGIC_VECTOR (15 downto 0);
	driver_enable: in STD_LOGIC;
	load_ready: out STD_LOGIC := '0';
	drv_clk : in  STD_LOGIC; --512 kHz for 8kHz/16 bit
	max98257_bclk : out  STD_LOGIC := '0';
	max98257_lrclk: out STD_LOGIC := '0';
	max98257_data: out STD_LOGIC := '0';
	max98257_enable: out STD_LOGIC := '0'
);
end max98257_driver;

architecture max98257_driver_arch of max98257_driver is
signal reg: std_logic_vector(31 downto 0) := x"00000000";
signal index:  natural range 0 to 31 := 0;
begin
	max98257_enable <= '1';	
	process(drv_clk) 
	variable div: std_logic := '0';
	begin
		if rising_edge(drv_clk) then
		if driver_enable = '1' then
				max98257_data <= reg(index);
				if div = '1' then
					case index is
						when 31 =>
							load_ready <= '0';
							index <= index -1;	
						when 30 => 
							index <= index -1;	
						when 17 => 
							max98257_lrclk <= '1';
							index <= index -1;	
						when 1 => 
							load_ready <= '1';
							max98257_lrclk <= '0';
							index <= index -1;	
						when 0 =>
							reg(31 downto 16) <= parallel_in;
							reg(15 downto 0) <= x"0000";
							index <=  31;
						when others =>
							index <= index -1;	
					end case;
				end if;	
				div := div xor '1';
				max98257_bclk <= div;
		end if;
		end if;
	end process;
end max98257_driver_arch;
