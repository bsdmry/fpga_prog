library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library cmos_logic;
use cmos_logic.cd4020;


entity logic_gen is
    Port ( 
	clk : in  STD_LOGIC;
    	up: in std_logic;
    	down: in std_logic;
    	divclk: out std_logic := '0'
	 );
end logic_gen;

architecture logic_gen_arch of logic_gen is
signal limit: std_logic_vector(11 downto 0) := "000000000011";
signal cntval: std_logic_vector(11 downto 0);
signal equal: std_logic := '1';

begin
counter: cd4020 port map (q => cntval, clk => clk, rst => equal);
	process(clk) begin
		if rising_edge(clk) then
			if limit = cntval then
				equal <= '0';
				divclk <= divclk xor '1';
			else
				equal <= '1';
			end if;
		end if;
	end process;
end logic_gen_arch;

