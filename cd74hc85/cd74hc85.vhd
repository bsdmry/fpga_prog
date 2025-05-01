library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd74hc85 is
    port (
		a : in  std_logic_vector(3 downto 0);
		b : in  std_logic_vector(3 downto 0);
		agi, bgi, eqi : in std_logic; --A greter B, B greater A, A equal B
		ago, bgo, eqo : out std_logic
	 );
end cd74hc85;

architecture cd74hc85_arch of cd74hc85 is
signal i: std_logic_vector(3 downto 0); 
signal eq, ag, bg: std_logic; 

begin
	i(0) <= a(0) xnor b(0);
	i(1) <= a(1) xnor b(1);
	i(2) <= a(2) xnor b(2);
	i(3) <= a(3) xnor b(3);

	eq <= i(3) and i(2) and i(1) and i(0);

	ag <= (a(3) and (not b(3))) or
    	(i(3) and a(2) and (not b(2))) or
    	(i(3) and i(2) and a(1)and (not b(1))) or
    	(i(3) and i(2) and i(1) and a(0) and (not b(0)));

	bg <= (b(3) and (not a(3))) or
    	(i(3) and b(2) and (not a(2))) or
    	(i(3) and i(2) and b(1)and (not a(1))) or
    	(i(3) and i(2) and i(1) and b(0) and (not a(0)));

	eqo <= eqi and eq;
	ago <= (agi and eq) or ag;
	bgo <= (bgi and eq) or bg;
end cd74hc85_arch;

