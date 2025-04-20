library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity halfadder is
    port ( a : in std_logic;  b: in std_logic; sum: out std_logic; carry: out std_logic);
end halfadder;

architecture halfadder_arch of halfadder is
begin
sum <= a xor b;
carry <= a and b;
end halfadder_arch;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fulladder is
    port ( 
		a : in std_logic;  b: in std_logic; 
		sum: out std_logic; mode: in std_logic;  
		carryin: in std_logic; carryout: out std_logic);
end fulladder;

architecture fulladder_arch of fulladder is
component halfadder is port (a : in std_logic;  b: in std_logic; sum: out std_logic; carry: out std_logic); end component;
signal ha1_sum_out, ha1_carry_out, ha2_carry_out, mod_out: std_logic;
begin
ha1: halfadder port map(a=>a, b=>mod_out, sum=>ha1_sum_out, carry=>ha1_carry_out);
ha2: halfadder port map(a=>carryin, b=>ha1_sum_out, sum=>sum, carry=>ha2_carry_out);
mod_out <= b xor mode;
carryout <= ha2_carry_out or ha1_carry_out;
end fulladder_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity add_sub4 is
    port ( 
		mode : in std_logic; -- '0' - add/ '1' - sub
		a: in std_logic_vector(3 downto 0);
		b: in std_logic_vector(3 downto 0);
		carryin: in std_logic;
		carryout: out std_logic;
		result: out std_logic_vector(3 downto 0)
	 );
end add_sub4;

architecture add_sub4_arch of add_sub4 is
signal co0, co1, co2: std_logic;
component fulladder is port(a: in std_logic;  b: in std_logic; mode: in std_logic; carryin: in std_logic; sum: out std_logic; carryout: out std_logic); end component;
begin
f0: fulladder port map(a=>a(0), b=>b(0), mode=>mode, carryin=>carryin, carryout=>co0, sum=>result(0));
f1: fulladder port map(a=>a(1), b=>b(1), mode=>mode, carryin=>co0, carryout=>co1, sum=>result(1));
f2: fulladder port map(a=>a(2), b=>b(2), mode=>mode, carryin=>co1, carryout=>co2, sum=>result(2));
f3: fulladder port map(a=>a(3), b=>b(3), mode=>mode, carryin=>co2, carryout=>carryout, sum=>result(3));
end add_sub4_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--https://abidhussainatisp.wordpress.com/wp-content/uploads/2016/10/lecture-11-dld-bcd-adders-and-comparators.pdf
-- SUBSTRACTION DO NOT WORK!
entity add_sub_bcd is
    port ( 
		mode : in std_logic; -- '0' - add/ '1' - sub
		a: in std_logic_vector(3 downto 0);
		b: in std_logic_vector(3 downto 0);
		carryin: in std_logic;
		carryout: out std_logic;
		result: out std_logic_vector(3 downto 0)
	 );
end add_sub_bcd;

architecture add_sub_bcd_arch of add_sub_bcd is
signal bin_carry, dec_carry, and1_out, and2_out: std_logic;
signal pre: std_logic_vector(3 downto 0);
component add_sub4 is port (
	mode : in std_logic; 
	a: in std_logic_vector(3 downto 0); 
	b: in std_logic_vector(3 downto 0); 
	carryin: in std_logic; 
	carryout: out std_logic; 
	result: out std_logic_vector(3 downto 0)); end component;
begin
adder1: add_sub4 port map(mode=> mode, a=>a, b=>b, carryin=>carryin, carryout=>bin_carry, result=>pre);
carryout <= dec_carry;
dec_carry <= bin_carry or and1_out or and2_out;
and1_out <= pre(2) and pre(3);
and2_out <= pre(1) and pre(3);
adder2: add_sub4 port map(mode=>'0', a=>pre, b(0)=>'0', b(1)=>dec_carry, b(2)=>dec_carry, b(3)=>'0', carryin=>'0', result=>result);
end add_sub_bcd_arch;
