library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity seven_seg_tester is
    Port ( clk : in  std_logic;
    	   segs: out std_logic_vector(7 downto 0);
    	   pos: out std_logic_vector(3 downto 0)
	 );
end seven_seg_tester;

architecture seven_seg_tester_arch of seven_seg_tester is
component clkgen is port (
	clk : in  std_logic;
    	c100: out std_logic := '0'; --100 Hz clk
    	c1: out std_logic -- 1Hz clk
);
end component;

component cd4543 is
    Port ( 
		le_n : in std_logic;
		d: in std_logic_vector(3 downto 0);
		ph: in std_logic;
		bl: in std_logic;
		q: out std_logic_vector(6 downto 0)
	 );
end component;

begin
	process(clk) begin

	end process;
end seven_seg_tester_arch;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clkgen is
  generic (
     CLK_HZ   : natural := 27000000;
  );
    port (
	clk : in  std_logic;
    	c100: out std_logic := '0'; --100 Hz clk
    	c1: out std_logic -- 1Hz clk
	 );
end clkgen;

architecture clkgen_arch of clkgen is
signal cnt: std_logic_vector(7 downto 0) := x"1A"; --26
constant prescaler: std_logic_vector(7 downto 0) := x"1A";
signal clk1mhz: std_logic := '0';
constant clk100_halfperiod : integer := (20000 -1);
constant clk1_halfperiod : integer := (2000000 -1);
signal clk100: std_logic := '0';
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
        variable c: natural range 0 to clk100_halfperiod := clk100_halfperiod;	
	begin
	if rising_edge(clk1mhz) then
		if c = 0 then 
			clk100 <= clk100 xor '1'; 
			c := clk100_halfperiod;
		else
			c := c-1;
		c100 <= clk100;
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
		c1 <= clk1;
	end if;
end process;

end clkgen_arch;
