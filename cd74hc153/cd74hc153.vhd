library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd74hc153 is
    port ( 
	mux0in : in std_logic_vector(3 downto 0);
	mux1in : in std_logic_vector(3 downto 0);
    	s0: in std_logic;
    	s1: in std_logic;
    	en0_n: in std_logic;
    	en1_n: in std_logic;
    	out0: out std_logic;
    	out1: out std_logic
	 );
end cd74hc153;

architecture cd74hc153_arch of cd74hc153 is
begin
end cd74hc153_arch;

