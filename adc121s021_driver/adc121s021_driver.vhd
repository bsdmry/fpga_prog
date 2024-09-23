library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity adc121s021_driver is
    Port (
	clk: in std_logic;
	cs: out std_logic := '1';
	sclk: out std_logic := '1';
	sdata: in std_logic;
	enable: in std_logic;
	adc_data: out std_logic_vector(15 downto 0) :=x"0000";
	data_ready: out std_logic := '0';
	srate_option: in std_logic_vector(1 downto 0)	
	 );
end adc121s021_driver;

architecture adc121s021_driver_arch of adc121s021_driver is
signal reg: std_logic_vector(15 downto 0) := x"0000";
signal index:  natural range 0 to 19 := 0;
signal sclk_int: std_logic := '0';
begin
	process(sclk_int)
		begin
			if rising_edge(sclk_int) then
				if enable = '1' then
					case index is
						when 0 => 
							index <= index +1;
							cs <= '0';
						when 1 => index <= index +1;
						when 2 => index <= index +1;
						when 3 => index <= index +1;
						when 16 => 
							cs <= '1';
							adc_data <= reg;
							data_ready <= '1';
							index <= index +1;
						when 17 => index <= index +1;
						when 18 => index <= index +1;
						when 19 => 
							index <= 0;
							data_ready <= '0';	
						when others => 
							reg(15-index) <= sdata;
							index <= index +1;
					end case;
				else
					adc_data <= x"0000";
					index <= 0;
					data_ready <= '0';
					cs <= '1';
				end if;
			end if;
	end process;

	process(clk)
		begin
			if rising_edge(clk) then
				sclk <= sclk_int;
				sclk_int <= sclk_int xor '1';
			end if;
	end process;
	
end adc121s021_driver_arch;

