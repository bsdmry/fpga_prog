library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd4020 is
    Port ( 
		clk : in  STD_LOGIC;
		rst: in std_logic;
		q: out std_logic_vector(11 downto 0) := "000000000000"
	 );
end cd4020;

architecture cd4020_arch of cd4020 is
begin
	process(clk)
		variable c: std_logic_vector(11 downto 0) := "000000000000";
		begin
		if rst = '0' then
			c := "000000000000";
		elsif falling_edge(clk) then
			c := std_logic_vector(unsigned(c) + 1);
		end if;
		q <= c;
	end process;
end cd4020_arch;

