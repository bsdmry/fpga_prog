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

entity OR4 is port (IN1,IN2,IN3,IN4: in STD_LOGIC; OUT1: out STD_LOGIC);
end OR4; 
architecture OR4_ARCH of OR4 is begin
  OUT1  <= (IN1 OR IN2 OR IN3 OR IN4);
end OR4_ARCH;
----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity OR5 is port (IN1,IN2,IN3,IN4,IN5: in STD_LOGIC; OUT1: out STD_LOGIC);
end OR5; 
architecture OR5_ARCH of OR5 is begin
  OUT1  <= (IN1 OR IN2 OR IN3 OR IN4 OR IN5);
end OR5_ARCH;
----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NOR2 is port (IN1,IN2: in STD_LOGIC; OUT1: out STD_LOGIC);
end NOR2; 
architecture NOR2_ARCH of NOR2 is begin
  OUT1  <= not (IN1 OR IN2);
end NOR2_ARCH;
----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NOR3 is port (IN1,IN2,IN3: in STD_LOGIC; OUT1: out STD_LOGIC);
end NOR3; 
architecture NOR3_ARCH of NOR3 is begin
  OUT1  <= not (IN1 OR IN2 OR IN3);
end NOR3_ARCH;
----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NOR4 is port (IN1,IN2,IN3,IN4: in STD_LOGIC; OUT1: out STD_LOGIC);
end NOR4; 
architecture NOR4_ARCH of NOR4 is begin
  OUT1  <= (IN1 OR IN2 OR IN3 OR IN4);
end NOR4_ARCH;
----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NOR5 is port (IN1,IN2,IN3,IN4,IN5: in STD_LOGIC; OUT1: out STD_LOGIC);
end NOR5; 
architecture NOR5_ARCH of NOR5 is begin
  OUT1  <= (IN1 OR IN2 OR IN3 OR IN4 OR IN5);
end NOR5_ARCH;
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NAND2 is port (IN1,IN2: in STD_LOGIC; OUT1: out STD_LOGIC);
end NAND2; 
architecture NAND2_ARCH of NAND2 is begin
  OUT1  <= not (IN1 AND IN2);
end NAND2_ARCH;
----
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NAND3 is port (IN1,IN2,IN3: in STD_LOGIC; OUT1: out STD_LOGIC);
end NAND3; 
architecture NAND3_ARCH of NAND3 is begin
  OUT1  <= not (IN1 AND IN2 AND IN3);
end NAND3_ARCH;
