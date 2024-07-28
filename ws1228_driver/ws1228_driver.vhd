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

begin
	process(drv_clk_20mhz, enable)
	variable txdata: std_logic_vector(23 downto 0) := "000000000000000000000000";
	variable index: natural range 0 to 23 := 23;
	variable bitlen: natural range 0 to 24 := 0;
	variable bittrg: natural range 0 to 16 := 8;
	variable transmit: std_logic := '0';
	variable fsm_bittx_state: std_logic_vector(1 downto 0) := "00";
	begin
	if rising_edge(enable) then
		txdata(23 downto 16) := r;
		txdata(15 downto 8) := g;
		txdata(7 downto 0) := b;
		index := 23;
		transmit := '1';
		done <= '0';
	end if;
	if rising_edge(drv_clk_20mhz) then
		if transmit = '1' then
			case fsm_bittx_state is
				when "00" => --Start bit transmission
					output <= '1';
					if txdata(index) = '1' then
						bittrg := 16;
					else
						bittrg := 8;	
					end if;
					fsm_bittx_state := "01";
				when "01" => --Bit is transmittig
					if (bitlen = bittrg) then
						output <= '0';
					end if;
				when others => 
			end case;
			if bitlen = 24 then 
				bitlen := 0;
				fsm_bittx_state := "00";
				if index = 0 then
					done <= '1';
					transmit := '0';
				else
					index := index - 1;
				end if; 
			else 
				bitlen := bitlen + 1; 
			end if;
			 
		end if;
	end if;

	end process;
	

end ws1228_driver_arch;

