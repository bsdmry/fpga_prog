library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sinegen is
    Port ( dac_out : out  STD_LOGIC_VECTOR (9 downto 0);
           dac_clk : out  STD_LOGIC;
           clk : in  STD_LOGIC);
end sinegen;

architecture sinegen_arch of sinegen is
type sin_table10_64 is array(0 to 63) of unsigned (11 downto 0);
constant sine : sin_table10_64 := (
X"1FF", X"231", X"262", X"293", X"2C2", X"2EF", X"31A", X"343",
X"368", X"38A", X"3A7", X"3C1", X"3D7", X"3E7", X"3F4", X"3FB",
X"3FE", X"3FB", X"3F4", X"3E7", X"3D7", X"3C1", X"3A7", X"38A",
X"368", X"343", X"31A", X"2EF", X"2C2", X"293", X"262", X"231",
X"1FF", X"1CC", X"19B", X"16A", X"13B", X"10E", X"0E3", X"0BA",
X"095", X"073", X"056", X"03C", X"026", X"016", X"009", X"002",
X"000", X"002", X"009", X"016", X"026", X"03C", X"056", X"073",
X"095", X"0BA", X"0E3", X"10E", X"13B", X"16A", X"19B", X"1CC"
);

begin
	process(clk)
	variable index: STD_LOGIC_VECTOR (5 downto 0) := "000000";
	variable div: STD_LOGIC := '0';
	begin
	if rising_edge(clk) then
		if div = '1' then
			dac_out <= std_logic_vector(sine(to_integer(unsigned(index)))(9 downto 0));
			dac_clk <= '1';
		elsif div = '0' then
			index := std_logic_vector(unsigned(index) + 1);
			dac_clk <= '0';		
		end if;
		div := div xor '1';
	end if;
	end process;
end sinegen_arch;

