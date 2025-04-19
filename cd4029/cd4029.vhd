library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- WARNING! This is not a precise implemetnation of CD4029.
-- An original IC has async "preset_enable" pin for load from a "jam" reg, 
-- but it is non-synthesable on a FPGA.
entity cd4029 is
    Port ( 
	clk : in  STD_LOGIC;
    	bindec: in std_logic;
    	updown: in std_logic;
    	preset_en: in std_logic;
    	carry_in: in std_logic;
    	jam: in std_logic_vector(3 downto 0);
    	output: out std_logic_vector(3 downto 0) := "0000";
    	carry_out: out std_logic := '1'
	 );
end cd4029;

architecture cd4029_arch of cd4029 is
signal counter: std_logic_vector(3 downto 0) := "0000";
begin
	process(clk) begin
	if rising_edge(clk) and (carry_in = '0') then
		if (preset_en = '1') then
			counter <= jam;
		else
			if updown = '1' then
				case counter is
					when "1000" =>
						if bindec = '0' then
							counter <= std_logic_vector(unsigned(counter)+1);
							carry_out <= '0'; 
						end if;
					when "1001" => 
						if bindec = '0' then 
							counter <= "0000";
							carry_out <= '1'; 
						end if;
					when "1110" => 
						counter <= std_logic_vector(unsigned(counter)+1);
						carry_out <= '0';
					when "1111" => 
						counter <= "0000";	
						carry_out <= '1';
					when others => counter <= std_logic_vector(unsigned(counter)+1);

				end case;
			else
				case counter is 
					when "0000" =>
						if bindec = '0' then
							counter <= "1001";
						else
							counter <= "1111";
						end if;
						carry_out <= '1';
					when "0001" =>
						carry_out <= '0';
						counter <= std_logic_vector(unsigned(counter)-1);
					when others =>
						counter <= std_logic_vector(unsigned(counter)-1);
				end case;
			end if;
		end if;
	end if;
	end process;
	output <= counter;
end cd4029_arch;

