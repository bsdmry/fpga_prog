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
signal ndo00,ndo01,ndo02,ndo03,ndo10,ndo11,ndo12,ndo13: std_logic;
signal s0_p, s0_n, s1_p, s1_n: std_logic;
begin
	s0_n <= not s0;
	s0_p <= not s0_n;
	s1_n <= not s1;
	s1_p <= not s1_n;

	ndo00 <= not en0_n and mux0in(0) and s0_n and s1_n;
	ndo01 <= not en0_n and mux0in(1) and s0_p and s1_n;
	ndo02 <= not en0_n and mux0in(2) and s0_n and s1_p;
	ndo03 <= not en0_n and mux0in(3) and s0_p and s1_p;

	ndo10 <= not en1_n and mux1in(0) and s0_n and s1_n;
	ndo11 <= not en1_n and mux1in(1) and s0_p and s1_n;
	ndo12 <= not en1_n and mux1in(2) and s0_n and s1_p;
	ndo13 <= not en1_n and mux1in(3) and s0_p and s1_p;

	out0 <= ndo00 or ndo01 or ndo02 or ndo03;
	out1 <= ndo10 or ndo11 or ndo12 or ndo13;
end cd74hc153_arch;

