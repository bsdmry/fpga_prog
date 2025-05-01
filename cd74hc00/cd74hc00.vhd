library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cd74hc00 is
    port ( 
		a0: in std_logic; b0: in std_logic; q0: out std_logic;
		a1: in std_logic; b1: in std_logic; q1: out std_logic;
		a2: in std_logic; b2: in std_logic; q2: out std_logic;
		a3: in std_logic; b3: in std_logic; q3: out std_logic
	 );
end cd74hc00;

architecture cd74hc00_arch of cd74hc00 is
begin
	q0 <= not (a0 and b0);
	q1 <= not (a1 and b1);
	q2 <= not (a2 and b2);
	q3 <= not (a3 and b3);
end cd74hc00_arch;

