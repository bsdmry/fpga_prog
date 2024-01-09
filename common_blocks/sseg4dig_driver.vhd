library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;
library personal;
use personal.sevenseg.eight_bit_to_three_bcd;


entity sseg4dig_driver is
    Port ( position_clk : in  STD_LOGIC;
           pos_select : out  STD_LOGIC_VECTOR (3 downto 0);
           led_data : out  STD_LOGIC_VECTOR (7 downto 0);
           data : in  STD_LOGIC_VECTOR (7 downto 0));
end sseg4dig_driver;

architecture sseg4dig_driver_arch of sseg4dig_driver is
begin
process(position_clk)
variable position: std_logic_vector (3 downto 0) := "1110";
variable bcd_data: std_logic_vector (15 downto 0) := "0000000000000000";
variable current_bcd_char: std_logic_vector (3 downto 0) := "0000";
begin
	bcd_data(11 downto 0) := eight_bit_to_three_bcd(data);
	bcd_data(15 downto 12) := "0000";
	if rising_edge(position_clk) then
		case position is
			when "1110" =>
				current_bcd_char := bcd_data(3 downto 0);
				pos_select <= position;
				position := "1101";
			when "1101" =>
				current_bcd_char := bcd_data(7 downto 4);
				pos_select <= position;
				position := "1011";
			when "1011" =>
				current_bcd_char := bcd_data(11 downto 8);
				pos_select <= position;
				position := "0111";
			when "0111" =>
				current_bcd_char := bcd_data(15 downto 12);
				pos_select <= position;
				position := "1110";				
			when others =>
				position := "1110";
		end case;
		case current_bcd_char is
			when "0000"=> led_data <= "11111100";
			when "0001"=> led_data <= "01100000";
			when "0010"=> led_data <= "11011010";
			when "0011"=> led_data <= "11110010";
			when "0100"=> led_data <= "01100110";
			when "0101"=> led_data <= "10110110";
			when "0110"=> led_data <= "10111110";
			when "0111"=> led_data <= "11100000";
			when "1000"=> led_data <= "11111110";
			when "1001"=> led_data <= "11110110";
			when others => led_data <= "00000010";
		end case;
	end if;	
end process;
end sseg4dig_driver_arch;

