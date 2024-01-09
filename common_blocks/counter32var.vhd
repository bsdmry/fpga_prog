library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter32var is
port (
	           inclk : in STD_LOGIC;
				  rst: STD_LOGIC;
				  limit: in std_logic_vector(31 downto 0);
				  value: out std_logic_vector(31 downto 0)
);
end counter32var;

architecture counter32var_arch of counter32var is
signal counter : std_logic_vector(31 downto 0) := x"00000000";
begin
process (inclk, rst)
	begin
	if rst = '1' then 
		counter <= x"00000000";
	elsif rising_edge(inclk) then
		if counter >= limit then
			counter <= x"00000000";
		else
			counter <= std_logic_vector(unsigned(counter) + 1);
		end if;
	end if;
end process;
value <= counter;
end counter32var_arch;
