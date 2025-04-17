library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--https://www.alldatasheet.com/html-pdf/17761/PHILIPS/HEF4522/497/2/HEF4522.html
entity cd4522 is
    Port ( 
	clk : in  std_logic;
	rst : in  std_logic;
    	inhibit: in std_logic;
    	preset: in std_logic;
    	carry_in: in std_logic;
    	p: in std_logic_vector(3 downto 0);
    	q: out std_logic_vector(3 downto 0);
    	tc: out std_logic
	 );
end cd4522;

architecture cd4522_arch of cd4522 is
signal clock: std_logic;
signal counter: std_logic_vector(3 downto 0) := "0000";
begin
	clock <= clk and not inhibit;
	process(clock, rst) begin
		if (rst = '1') then
			counter <= "0000";
		elsif rising_edge(clock) then
			if preset = '1' then
				counter <= p;
			else
				if counter = "0000" then
					counter <= "1001";
				else
					counter <= std_logic_vector(unsigned(counter)-1);
				end if;
			end if;
		end if;
	end process;
	tc <= not (counter(0) or counter(1) or counter(2) or counter(3)) and carry_in and (not preset);
	q <= counter;
end cd4522_arch;

