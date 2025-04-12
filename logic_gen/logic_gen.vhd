library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity logic_gen is
    Port ( 
	clk : in  STD_LOGIC;
    	up: in std_logic;
    	down: in std_logic;
    	divclk: out std_logic := '0'
	 );
end logic_gen;

architecture logic_gen_arch of logic_gen is
signal limit: std_logic_vector(11 downto 0) := "000000000010";
signal cntval: std_logic_vector(11 downto 0);
signal equal: std_logic := '1';
signal outclk: std_logic := '0';

component cd4020 is
    Port ( 
		clk : in  STD_LOGIC;
		rst: in std_logic;
		q: out std_logic_vector(11 downto 0)
	 );
end component;

begin
	counter: cd4020 port map (q => cntval, clk => clk, rst => equal);

	equal <= '0' when unsigned(limit) = unsigned(cntval) else '1';
	process(equal) begin
		if falling_edge(equal) then
			outclk <= outclk xor '1';
		end if;
	end process;
	divclk <= outclk;
end logic_gen_arch;

