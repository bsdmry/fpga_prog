library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity gen10clock is
  generic (
     CLK_MHZ: natural := 27
  );
    port (
		clk : in  std_logic;
    	c1k: out std_logic := '0'; --1 kHz clk
    	c100: out std_logic := '0'; --100 Hz clk
    	c10: out std_logic := '0'; --10 Hz clk
    	c1: out std_logic := '0' -- 1Hz clk
	 );
end gen10clock;

architecture gen10clock_arch of gen10clock is
signal cnt: std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(CLK_MHZ-1, 8)); -- 27-1
constant prescaler: std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(CLK_MHZ-1, 8));

constant clk1k_halfperiod : integer := (500 -1); --1kHz
constant clk100_halfperiod : integer := (5000 -1); --100Hz
constant clk10_halfperiod : integer := (50000 -1); --10Hz
constant clk1_halfperiod : integer := (500000 -1); --1Hz

signal clk1mhz: std_logic := '0';
signal clk1k: std_logic := '0';
signal clk100: std_logic := '0';
signal clk10: std_logic := '0';
signal clk1: std_logic := '0';

begin
process(clk) begin
	if rising_edge(clk) then
		case cnt is
			when "00000000" => clk1mhz <= '0'; cnt <= prescaler;
			when "00000001" => clk1mhz <= '1'; cnt <= std_logic_vector(unsigned(cnt) -1);
			when others => cnt <= std_logic_vector(unsigned(cnt) -1);
		end case;
	end if;
end process;

process(clk1mhz)
        variable c: natural range 0 to clk1k_halfperiod := clk1k_halfperiod;	
	begin
	if rising_edge(clk1mhz) then
		if c = 0 then 
			clk1k <= clk1k xor '1'; 
			c := clk1k_halfperiod;
		else
			c := c-1;
		end if;
		c1k <= clk1k;
	end if;
end process;

process(clk1mhz)
        variable c: natural range 0 to clk100_halfperiod := clk100_halfperiod;	
	begin
	if rising_edge(clk1mhz) then
		if c = 0 then 
			clk100 <= clk100 xor '1'; 
			c := clk100_halfperiod;
		else
			c := c-1;
		end if;
		c100 <= clk100;
	end if;
end process;

process(clk1mhz)
        variable c: natural range 0 to clk10_halfperiod := clk10_halfperiod;	
	begin
	if rising_edge(clk1mhz) then
		if c = 0 then 
			clk10 <= clk10 xor '1'; 
			c := clk10_halfperiod;
		else
			c := c-1;
		end if;
		c10 <= clk10;
	end if;
end process;

process(clk1mhz)
        variable c: natural range 0 to clk1_halfperiod := clk1_halfperiod;	
	begin
	if rising_edge(clk1mhz) then
		if c = 0 then 
			clk1 <= clk1 xor '1'; 
			c := clk1_halfperiod;
		else
			c := c-1;
		end if;
		c1 <= clk1;
	end if;
end process;
end gen10clock_arch;

