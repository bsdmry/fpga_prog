library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mul10x is
    Port (
	inval: in std_logic_vector(3 downto 0);
	outval: out std_logic_vector(7 downto 0)
	 );
end mul10x;

architecture mul10x_arch of mul10x is
	component add_sub4 is port (
		mode : in std_logic; -- '0' - add/ '1' - sub
		a: in std_logic_vector(3 downto 0);
		b: in std_logic_vector(3 downto 0);
		carryin: in std_logic;
		carryout: out std_logic;
		result: out std_logic_vector(3 downto 0)
	);	
	end component;
	signal op1, op2: std_logic_vector(7 downto 0) := x"00";
	signal carry: std_logic;
begin
	op1(4 downto 1) <= inval;
	op2(6 downto 3) <= inval;
	sum1: add_sub4 port map (mode=>'0', a=>op1(3 downto 0), b=>op2(3 downto 0), carryin=>'0', carryout=>carry, result=>outval(3 downto 0 ));
	sum2: add_sub4 port map (mode=>'0', a=>op1(7 downto 4), b=>op2(7 downto 4), carryin=>carry, result=>outval(7 downto 4));
end mul10x_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity mul100x is
    Port (
	inval: in std_logic_vector(3 downto 0);
	outval: out std_logic_vector(11 downto 0)
	 );
end mul100x;

architecture mul100x_arch of mul100x is
	component add_sub4 is port (
		mode : in std_logic; -- '0' - add/ '1' - sub
		a: in std_logic_vector(3 downto 0);
		b: in std_logic_vector(3 downto 0);
		carryin: in std_logic;
		carryout: out std_logic;
		result: out std_logic_vector(3 downto 0)
	);	
	end component;
	signal op1, op2, preop12, op3: std_logic_vector(11 downto 0) := "000000000000";
	signal carry1, carry2, carry3, carry4: std_logic;
begin
	op1(9 downto 6 ) <= inval;
	op2(8 downto 5) <= inval;
	op3(5 downto 2) <= inval;
	sum1: add_sub4 port map (mode=>'0', a=>op1(3 downto 0), b=>op2(3 downto 0), carryin=>'0', carryout=>carry1, result=>preop12(3 downto 0 ));
	sum2: add_sub4 port map (mode=>'0', a=>op1(7 downto 4), b=>op2(7 downto 4), carryin=>carry1, carryout=>carry2,  result=>preop12(7 downto 4));
	sum3: add_sub4 port map (mode=>'0', a=>op1(11 downto 8), b=>op2(11 downto 8), carryin=>carry2, result=>preop12(11 downto 8));

	sum4: add_sub4 port map (mode=>'0', a=>preop12(3 downto 0), b=>op3(3 downto 0), carryin=>'0', carryout=>carry3, result=>outval(3 downto 0 ));
	sum5: add_sub4 port map (mode=>'0', a=>preop12(7 downto 4), b=>op3(7 downto 4), carryin=>carry3, carryout=>carry4,  result=>outval(7 downto 4));
	sum6: add_sub4 port map (mode=>'0', a=>preop12(11 downto 8), b=>op3(11 downto 8), carryin=>carry4, result=>outval(11 downto 8));
end mul100x_arch;
