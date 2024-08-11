library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lfsr_prnd is
	port (
		clk:  in std_logic;
		preset_value: in std_logic_vector(23 downto 0);
		random_out: out std_logic_vector(23 downto 0) := "000000000000000000000000";
		preset: in std_logic
);
end lfsr_prnd;

architecture lfsr_prnd_arch of lfsr_prnd is
	signal reg: std_logic_vector(23 downto 0) := "111111111111111111111111";
begin
	process(clk, preset) begin
		if rising_edge(clk) then
			if preset = '1' then
				reg <= preset_value;
			else
				reg(23) <= reg(22);
				reg(22) <= reg(21);
				reg(21) <= reg(20);
				reg(20) <= reg(19);
				reg(19) <= reg(18);
				reg(18) <= reg(17);
				reg(17) <= reg(16);
				reg(16) <= reg(15);
				reg(15) <= reg(14);
				reg(14) <= reg(13);
				reg(13) <= reg(12);
				reg(12) <= reg(11);
				reg(11) <= reg(10);
				reg(10) <= reg(9);
				reg(9) <= reg(8);
				reg(8) <= reg(7);
				reg(7) <= reg(6);
				reg(6) <= reg(5);
				reg(5) <= reg(4);
				reg(4) <= reg(3);
				reg(3) <= reg(2);
				reg(2) <= reg(1);
				reg(1) <= reg(0);
				
				reg(0) <= ((reg(23) xor reg(21)) xor reg(15)) xor reg(6);
				random_out <= reg;
			end if;
		end if;
	end process;
end lfsr_prnd_arch;
