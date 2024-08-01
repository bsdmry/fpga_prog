library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ws1228_driver is
    Port ( drv_clk_20mhz : in  STD_LOGIC;
           r : in  STD_LOGIC_VECTOR (7 downto 0);
           g : in  STD_LOGIC_VECTOR (7 downto 0);
           b : in  STD_LOGIC_VECTOR (7 downto 0);
	   enable: in STD_LOGIC;
	   output: out STD_LOGIC := '0';
	   done: out STD_LOGIC := '0' );
end ws1228_driver;

architecture ws1228_driver_arch of ws1228_driver is
	signal txdata: std_logic_vector(23 downto 0) := "000000000000000000000000";
	signal index:  natural range 0 to 23 := 23;
	signal fallpoint:  natural range 0 to 16 := 7;
	signal bitlen: natural range 0 to 23 := 0;
	signal transmit: std_logic := '0';
	signal state: std_logic_vector(1 downto 0) := "00";

begin
	process(drv_clk_20mhz, enable) begin
		if rising_edge(drv_clk_20mhz) then
			case state is
			when "00" =>
				done <= '0';
				if enable = '1' then 
					state <= "01";
					txdata(23 downto 16) <= r;
					txdata(15 downto 8) <= g;
					txdata(7 downto 0) <= b;
				end if;
			when "01" =>
				output <= '1';
				if txdata(index) = '1' then
					fallpoint <= 15;
				else
					fallpoint <= 7;	
				end if;
				state <= "10";
			when "10" =>
				if bitlen = fallpoint then
					output <= '0';
				end if;
				if bitlen = 23 then
					bitlen <= 0;
					if index = 0 then
						state <= "00";
						index <= 23;
						done <= '1';
					else
						index <= index - 1;
						state <= "01";
					end if;
				else
					bitlen <= bitlen + 1;
				end if;
			when others =>
			end case;
		end if;
	end process;
end ws1228_driver_arch;
