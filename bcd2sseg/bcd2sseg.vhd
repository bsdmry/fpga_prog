library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity bcd2sseg is
    Port ( 
		b0 : in  std_logic;
		b1 : in  std_logic;
		b2 : in  std_logic;
		b3 : in  std_logic;
		a : out  std_logic;
		b : out  std_logic;
		c : out  std_logic;
		d : out  std_logic;
		e : out  std_logic;
		f : out  std_logic;
		g : out  std_logic
	 );
end bcd2sseg;

architecture bcd2sseg_arch of bcd2sseg is
begin
a <= b3 OR b1 OR (b2 AND b0) OR (NOT b2 AND NOT b0);
b <= (NOT b2) OR (NOT b1 AND NOT b0) OR (b1 AND b0);
c <= b2 OR (NOT b1) OR b0;
d <= b3 OR (NOT b2 AND NOT b0) OR (NOT b2 AND b1) OR (b1 AND NOT b0) OR (b2 AND (NOT b1) AND b0);
e <=  (NOT b2 AND NOT b0) OR (b1 AND NOT b0);
f <= b3 OR (b2 AND NOT b1) OR (b2 AND NOT b0) OR (NOT b1 AND NOT b0);
g <= b3 OR (b2 AND NOT b1) OR (NOT b2 AND b1) OR (b1 AND NOT b0);
end bcd2sseg_arch;

