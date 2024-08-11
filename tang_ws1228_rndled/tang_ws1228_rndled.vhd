library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity usr_ws1228 is
    Port ( inclk_20mhz : in  STD_LOGIC;
	   button: in STD_LOGIC;
	   ws1228_done: in STD_LOGIC;
	   trigger: out STD_LOGIC := '0');
end usr_ws1228;

architecture usr_ws1228_arch of usr_ws1228 is
signal wait_rdy : STD_LOGIC := '0';
begin
process(inclk_20mhz)
begin
	if rising_edge(inclk_20mhz) then
		if ws1228_done = '1' then
			wait_rdy <= '0';
		end if;	
		
		if (button = '0') and (wait_rdy = '0') then
			trigger <= '1';
			wait_rdy <= '1';
		else
			trigger <= '0';
		end if;
	end if;
end process;
end;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tang_ws1228_rndled is
    Port ( inclk_20mhz : in  STD_LOGIC;
	   button: in STD_LOGIC;
	   output: out STD_LOGIC := '0');
end tang_ws1228_rndled;

architecture tang_ws1228_rndled_arch of tang_ws1228_rndled is

component ws1228_driver is
    Port ( drv_clk_20mhz : in  STD_LOGIC;
           r : in  STD_LOGIC_VECTOR (7 downto 0);
           g : in  STD_LOGIC_VECTOR (7 downto 0);
           b : in  STD_LOGIC_VECTOR (7 downto 0);
	   enable: in STD_LOGIC;
	   output: out STD_LOGIC;
	   done: out STD_LOGIC);
end component;

component usr_ws1228 is port (
	inclk_20mhz : in  STD_LOGIC;
	button: in STD_LOGIC;
	ws1228_done: in STD_LOGIC;
	trigger: out STD_LOGIC
);
end component;

component lfsr_prnd is port (
		clk:  in std_logic;
		preset_value: in std_logic_vector(23 downto 0);
		random_out: out std_logic_vector(23 downto 0);
		preset: in std_logic
);
end component;

signal red: STD_LOGIC_VECTOR (7 downto 0);
signal green: STD_LOGIC_VECTOR (7 downto 0);
signal blue: STD_LOGIC_VECTOR (7 downto 0);
constant preset_val: STD_LOGIC_VECTOR (23 downto 0) := "111111111111111111111111";
signal en: STD_LOGIC := '0';
signal next_rdy : STD_LOGIC;

begin

drv : ws1228_driver port map (
	drv_clk_20mhz => inclk_20mhz,
	r => red,
	g => green,
	b => blue,
	enable => en,
	output => output,
	done => next_rdy
);

ctl : usr_ws1228 port map (
	inclk_20mhz => inclk_20mhz,
	button => button,
	ws1228_done => next_rdy,
	trigger => en
);

prnd : lfsr_prnd port map (
	clk => inclk_20mhz,
	random_out(23 downto 16) => red,
	random_out(15 downto 8) => green,
	random_out(7 downto 0) => blue,
	preset_value => preset_val,
	preset => '0'	
);

end tang_ws1228_rndled_arch;
