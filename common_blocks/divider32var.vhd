library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity divider32var is
port (
           inclk : in  STD_LOGIC;
           outclk : out  STD_LOGIC;
			  rst : in  STD_LOGIC;
           divisor : in  STD_LOGIC_VECTOR (31 downto 0));
end divider32var;

architecture divider32var_arch of divider32var is
signal out_state : std_logic := '1';
begin
process(inclk, rst)	
	variable prescaler_cnt: STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
	begin
	if rst = '1' then
		prescaler_cnt := divisor;
	elsif rising_edge(inclk) then
		if prescaler_cnt = x"00000000" then 
			prescaler_cnt := divisor;
			out_state <= not out_state;
		else 
			prescaler_cnt := std_logic_vector(unsigned(prescaler_cnt) - 1);
		end if;
	end if;
	end process; 
	outclk <= std_logic(out_state);
end divider32var_arch;