library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd4059 is
    Port ( clk : in  STD_LOGIC;
			Ka: in std_logic;
			Kb: in std_logic;
			Kc: in std_logic;
			jbus: in std_logic_vector(15 downto 0)
	 );
end cd4059;

architecture cd4059_arch of cd4059 is
signal state: std_logic_vector(2 downto 0) := "000";
signal bits: std_logic_vector(15 downto 0) := x"0000";
signal first_cnt: std_logic_vector(3 downto 0) := "0000";
signal int_cnt1: std_logic_vector(3 downto 0) := "0000";
signal int_cnt2: std_logic_vector(3 downto 0) := "0000";
signal int_cnt3: std_logic_vector(3 downto 0) := "0000";
signal last_cnt: std_logic_vector(2 downto 0) := "000";
begin
	process(clk) begin
		if rising_edge(clk) then
			if (Kb = '0' and Kc = '0') then
				bits <=	jbus;
				state <= "000";
			else
				case state is
					when "000" =>
						if (Ka = '1' and Kb = '1' and Kc = '1') then
							first_cnt(0) <= jbus(0);
							last_cnt <= jbus(3 downto 1);	
						elsif (Ka = '0' and Kb = '1' and Kc = '1') then
							first_cnt(1 downto 0) <= jbus(1 downto 0);
							last_cnt(1 downto 0) <= jbus(3 downto 2);	
						elsif (Ka = '0' and Kb = '0' and Kc = '1') then
							first_cnt(2 downto 0) <= jbus(2 downto 0);
							last_cnt(0) <= jbus(3);	
						elsif (Ka = '1' and Kb = '1' and Kc = '0') then
							first_cnt <= jbus(3 downto 0);
							last_cnt <= "000";	
						end if;
						int_cnt1 <= jbus(7 downto 4);
						int_cnt2 <= jbus(11 downto 8);
						int_cnt3 <= jbus(15 downto 12);
					when others => 
				end case;	
			end if;
		end if;
	end process;
end cd4059_arch;

