library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity OR2 is port (IN1,IN2: in STD_LOGIC; OUT1: out STD_LOGIC);
end OR2; 
architecture OR2_ARCH of OR2 is begin
  OUT1  <= (IN1 OR IN2);
end OR2_ARCH;
----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity OR3 is port (IN1,IN2,IN3: in STD_LOGIC; OUT1: out STD_LOGIC);
end OR3; 
architecture OR3_ARCH of OR3 is begin
  OUT1  <= (IN1 OR IN2 OR IN3);
end OR3_ARCH;
----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AND4 is port (IN1,IN2,IN3,IN4: in STD_LOGIC; OUT1: out STD_LOGIC);
end AND4; 
architecture AND4_ARCH of AND4 is begin
  OUT1  <= (IN1 AND IN2 AND IN3 AND IN4);
end AND4_ARCH;
----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AND3 is port (IN1,IN2,IN3: in STD_LOGIC; OUT1: out STD_LOGIC);
end AND3; 
architecture AND3_ARCH of AND3 is begin
  OUT1  <= (IN1 AND IN2 AND IN3);
end AND3_ARCH;
----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity AND2 is port (IN1,IN2: in STD_LOGIC; OUT1: out STD_LOGIC);
end AND2; 
architecture AND2_ARCH of AND2 is begin
  OUT1  <= (IN1 AND IN2);
end AND2_ARCH;
----
