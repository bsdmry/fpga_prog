library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ws1228_driver is
    Port ( drv_clk : in  STD_LOGIC;
           r : in  STD_LOGIC_VECTOR (7 downto 0);
           g : in  STD_LOGIC_VECTOR (7 downto 0);
           b : in  STD_LOGIC_VECTOR (7 downto 0);
	   enable: in STD_LOGIC;
	   output: out STD_LOGIC := '0';
	   done: out STD_LOGIC := '0' );
end ws1228_driver;

architecture ws1228_driver_arch of ws1228_driver is

begin
	process(drv_clk, enable)
	variable txdata: std_logic_vector(23 downto 0) := "000000000000000000000000";
	variable index: natural range 0 to 23 := 0;
	variable transmit: std_logic := '0';
	begin
	if rising_edge(enable) then
		txdata(23 downto 16) := r;
		txdata(15 downto 8) := g;
		txdata(7 downto 0) := b;
		index := 0;
		transmit := '1';
		done <= '0';
	end if;
	if rising_edge(drv_clk) then
		if transmit = '1' then 
			output <= txdata(index);	
			if index = 23 then
				done <= '1';
			else
				index := index + 1;
			end if;
		end if;
	end if;

	end process;
	

end ws1228_driver_arch;

