library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter8var is
port (
	           inclk : in STD_LOGIC;
				  rst: STD_LOGIC;
				  limit: in std_logic_vector(7 downto 0);
				  value: out std_logic_vector(7 downto 0)
);
end counter8var;

architecture counter8var_arch of counter8var is
signal counter : std_logic_vector(7 downto 0) := x"00";
begin
process (inclk, rst)
	begin
	if rst = '1' then 
		counter <= x"00";
	elsif rising_edge(inclk) then
		if counter >= limit then
			counter <= x"00";
		else
			counter <= std_logic_vector(unsigned(counter) + 1);
		end if;
	end if;
end process;
value <= counter;
end counter8var_arch;