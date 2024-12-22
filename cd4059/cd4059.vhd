library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--https://www.ti.com/lit/ds/symlink/cd4059a.pdf
entity cd4059 is
    Port ( clk : in  STD_LOGIC;
			Ka: in std_logic;
			Kb: in std_logic;
			Kc: in std_logic;
			jbus: in std_logic_vector(15 downto 0);
			output: out std_logic := '1'
	 );
end cd4059;

architecture cd4059_arch of cd4059 is
	signal state: std_logic_vector(2 downto 0) := "000";
	signal statediv: std_logic_vector(2 downto 0) := "000";
	signal counter1_buf: std_logic_vector(3 downto 0) := "0000";
	signal counter2_buf: std_logic_vector(3 downto 0) := "0000";
	signal counter3_buf: std_logic_vector(3 downto 0) := "0000";
	signal counter4_buf: std_logic_vector(3 downto 0) := "0000";
	signal counter5_buf: std_logic_vector(2 downto 0) := "000";
	signal counter1: std_logic_vector(3 downto 0) := "0000";
	signal counter2: std_logic_vector(3 downto 0) := "0000";
	signal counter3: std_logic_vector(3 downto 0) := "0000";
	signal counter4: std_logic_vector(3 downto 0) := "0000";
	signal counter5: std_logic_vector(2 downto 0) := "000";
	signal divider: natural range 0 to 9 := 9; --can be 2, 4, 5, 8, 10 (combination Ka, Kb, Kc)

begin
	process(clk) 
		variable divcnt: natural range 0 to 9 := 0;
		variable c1000: natural range 0 to 999 := 999;
		variable c100: natural range 0 to 99 := 99;
		variable c10: natural range 0 to 9 := 9;
		begin
		if rising_edge(clk) then
			if (Kb = '0' and Kc = '0') then
				state <= "000";
			else
				case state is
					when "000" =>
						if (Ka = '1' and Kb = '1' and Kc = '1') then -- /2 mode
							counter1(0) <= jbus(0);
							counter1(1) <= '0';
							counter1(2) <= '0';
							counter1(3) <= '0';
							counter5(0) <= jbus(1);
							counter5(1) <= jbus(2);
							counter5(2) <= jbus(3);

							counter1_buf(0) <= jbus(0);
							counter1_buf(1) <= '0';
							counter1_buf(2) <= '0';
							counter1_buf(3) <= '0';
							counter5_buf(0) <= jbus(1);
							counter5_buf(1) <= jbus(2);
							counter5_buf(2) <= jbus(3);

							divider <= 1; divcnt := 1; 	
							state <= "010";
						elsif (Ka = '0' and Kb = '1' and Kc = '1') then -- /4 mode
							counter1(0) <= jbus(0);
							counter1(1) <= jbus(1);
							counter1(2) <= '0';
							counter1(3) <= '0';
							counter5(0) <= jbus(2);
							counter5(1) <= jbus(3);
							counter5(2) <= '0';

							counter1_buf(0) <= jbus(0);
							counter1_buf(1) <= jbus(1);
							counter1_buf(2) <= '0';
							counter1_buf(3) <= '0';
							counter5_buf(0) <= jbus(2);
							counter5_buf(1) <= jbus(3);
							counter5_buf(2) <= '0';

							divider <= 3; divcnt := 3;	
							state <= "010";
						elsif (Ka = '1' and Kb = '0' and Kc = '1') then -- /5 mode
							counter1(0) <= jbus(0);
							counter1(1) <= jbus(1);
							counter1(2) <= jbus(2);
							counter1(3) <= '0';
							counter5(0) <= jbus(3);
							counter5(1) <= '0';
							counter5(2) <= '0';

							counter1_buf(0) <= jbus(0);
							counter1_buf(1) <= jbus(1);
							counter1_buf(2) <= jbus(2);
							counter1_buf(3) <= '0';
							counter5_buf(0) <= jbus(3);
							counter5_buf(1) <= '0';
							counter5_buf(2) <= '0';

							divider <= 4; divcnt := 4;	
							state <= "010";
						elsif (Ka = '0' and Kb = '0' and Kc = '1') then -- /8 mode
							counter1(0) <= jbus(0);
							counter1(1) <= jbus(1);
							counter1(2) <= jbus(2);
							counter1(3) <= '0';
							counter5(0) <= jbus(3);
							counter5(1) <= '0';
							counter5(2) <= '0';

							counter1_buf(0) <= jbus(0);
							counter1_buf(1) <= jbus(1);
							counter1_buf(2) <= jbus(2);
							counter1_buf(3) <= '0';
							counter5_buf(0) <= jbus(3);
							counter5_buf(1) <= '0';
							counter5_buf(2) <= '0';

							divider <= 7; divcnt := 7; 	
							state <= "010";
						elsif (Ka = '1' and Kb = '1' and Kc = '0') then -- /10 mode
							counter1(0) <= jbus(0);
							counter1(1) <= jbus(1);
							counter1(2) <= jbus(2);
							counter1(3) <= jbus(3);
							counter5 <= "000";	

							counter1_buf(0) <= jbus(0);
							counter1_buf(1) <= jbus(1);
							counter1_buf(2) <= jbus(2);
							counter1_buf(3) <= jbus(3);
							counter5_buf <= "000";	

							divider <= 9; divcnt := 9;
							state <= "010";
						end if;
						counter2_buf <= jbus(7 downto 4);
						counter3_buf <= jbus(11 downto 8);
						counter4_buf <= jbus(15 downto 12);
						counter2 <= jbus(7 downto 4);
						counter3 <= jbus(11 downto 8);
						counter4 <= jbus(15 downto 12);
					when "010" =>  -- Count down for [Nmode] * [1000 x 5th decade + 100 x 4th decade + 10 x 3rd decade + 1 x 2nd decade]
						output <= '0';
						if divcnt = 0 then -- Nmode
							divcnt := divider;
							case statediv is
								when "000" =>	
									if counter5 = "000" then --5th decade
										statediv <= "001";
									else
										if c1000 = 0 then -- 1000 x
											counter5 <= std_logic_vector(unsigned(counter5) - 1);
											c1000 := 999;
										else
											c1000 := c1000 - 1;
										end if;
									end if;
								when "001" =>
									if counter4 = "0000" then --4th decade
										statediv <= "010";
									else
										if c100 = 0 then -- 100 x
											counter4 <= std_logic_vector(unsigned(counter4) - 1);
											c100 := 99;
										else
											c100 := c100 - 1;
										end if;
									end if;
								when "010" =>
									if counter3 = "0000" then --3th decade
										statediv <= "011";
									else
										if c10 = 0 then -- 10 x
											counter3 <= std_logic_vector(unsigned(counter3) - 1);
											c10 := 9;
										else
											c10 := c10 - 1;
										end if;
									end if;
								when "011" =>
									if counter2 = "0000" then
										statediv <= "000";
										state <= "011";
									else
										counter2 <= std_logic_vector(unsigned(counter2) - 1);
									end if;
								when others =>
							end case;			
						else
							divcnt := divcnt - 1;
						end if;	
					when "011" => -- Count down 1st decade
						if counter1 = "0000" then
							counter1 <= counter1_buf;
							counter2 <= counter2_buf;
							counter3 <= counter3_buf;
							counter4 <= counter4_buf;
							counter5 <= counter5_buf;

							state <= "010"; --Count again
							output <= '1';
						else
							counter1 <= std_logic_vector(unsigned(counter1) - 1);
						end if;
						
					when others => 
				end case;	
			end if;
		end if;
	end process;

end cd4059_arch;

