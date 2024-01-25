-- Tests 10 bit parallel DAC like AD9760
library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity dac10bit is
    Port ( dac_out : out  STD_LOGIC_VECTOR (9 downto 0);
           dac_clk : out  STD_LOGIC;
           clk : in  STD_LOGIC);
end dac10bit;

architecture dac10bit_arch of dac10bit is
component divider32var is
port (
           inclk : in  STD_LOGIC;
           outclk : out  STD_LOGIC;
			  rst : in  STD_LOGIC;
           divisor : in  STD_LOGIC_VECTOR (31 downto 0));
end component;
signal no_rst_sig : std_logic := '0';
signal counter_divisor: STD_LOGIC_VECTOR (31 downto 0) := x"00000009"; --10
signal divided_sysclk : std_logic := '0';
component sinegen is
    Port ( dac_out : out  STD_LOGIC_VECTOR (9 downto 0);
           dac_clk : out  STD_LOGIC;
           clk : in  STD_LOGIC);
end component;

begin
indiv: divider32var port map (
	inclk => clk, 
	outclk => divided_sysclk, 
	rst => no_rst_sig, 
	divisor => counter_divisor);
	
gen: sinegen port map (
	clk => divided_sysclk,
	dac_clk => dac_clk,
	dac_out => dac_out
);

end dac10bit_arch;

