library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sample_loader is 
port(
	load_ready_in : in  STD_LOGIC;
	sample_out : out  STD_LOGIC_VECTOR (15 downto 0)
);
end sample_loader;

architecture sample_loader_arch of sample_loader is
--type sin_table16_16 is array(0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
--constant sine : sin_table16_16 := (
--x"8000", x"b0fb", x"da82", x"f641", x"ffff", x"f641", x"da82", x"b0fb", --AMP full, uint16_t
--x"8000", x"4f04", x"257d", x"09be", x"0000", x"09be", x"257d", x"4f04"

--x"0000", x"30fb", x"5a82", x"7641", x"7fff", x"7641", x"5a82", x"30fb", --AMP full, int16_t
--x"0000", x"cf05", x"a57e", x"89bf", x"8001", x"89bf", x"a57e", x"cf05"

--x"0000", x"18b8", x"2dac", x"3bac", x"4097", x"3bac", x"2dac", x"18b8", --AMP half, int16_t
--x"0000", x"e748", x"2d54", x"c454", x"bf69", x"c454", x"d254", x"e748"
--);

type sin_table32_16 is array(0 to 31) of STD_LOGIC_VECTOR (15 downto 0);
constant sine : sin_table32_16 := (
x"0000", x"0c9a", x"18b8", x"23e2", x"2dac", x"35b4", x"3bac", x"3f59", --AMP half, int16_t
x"4097", x"3f59", x"3bac", x"35b4", x"2dac", x"23e2", x"18b8", x"0c8a",
x"0000", x"f366", x"e748", x"dc1e", x"d254", x"ca4c", x"c454", x"c0a7",
x"bf69", x"c0a7", x"c454", x"ca4c", x"d254", x"dc1e", x"e748", x"f366"
);

begin
process(load_ready_in)
variable sin_index: natural range 0 to 31 := 0;
	begin
	if rising_edge(load_ready_in) then
		sample_out <= sine(sin_index);
		if sin_index = 31 then sin_index := 0; else
		sin_index := sin_index + 1;
		end if;
	end if;
end process;


end sample_loader_arch;

------------------------------------------------------------------------------
library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity max98257_sine is 
    Port ( 
	drv_clk : in  STD_LOGIC; --512 Khz for 8 khz audio, 1024 Khz for 16 khz audio
	max98257_bclk : out  STD_LOGIC := '0';
	max98257_lrclk: out STD_LOGIC := '0';
	max98257_data: out STD_LOGIC := '0';
	max98257_enable: out STD_LOGIC := '0'
);
end max98257_sine;


architecture max98257_sine_arch of max98257_sine is

component max98257_driver is
    Port ( 
	parallel_in : in  STD_LOGIC_VECTOR (15 downto 0);
	driver_enable: in STD_LOGIC;
	load_ready: out STD_LOGIC := '0';
	drv_clk : in  STD_LOGIC;
	max98257_bclk : out  STD_LOGIC := '0';
	max98257_lrclk: out STD_LOGIC := '0';
	max98257_data: out STD_LOGIC := '0';
	max98257_enable: out STD_LOGIC := '0'
);
end component;
component sample_loader is 
port(
	load_ready_in : in  STD_LOGIC;
	sample_out : out  STD_LOGIC_VECTOR (15 downto 0)
);
end component;
signal sample: STD_LOGIC_VECTOR (15 downto 0) := x"0000";
constant drv_en: std_logic := '1';
signal data_req: std_logic := '0';

begin
drv : max98257_driver port map(
	parallel_in => sample,
	driver_enable => drv_en,
	load_ready => data_req,
	drv_clk => drv_clk,
	max98257_bclk => max98257_bclk,
	max98257_lrclk => max98257_lrclk,
	max98257_data => max98257_data,
	max98257_enable => max98257_enable 
);

datasrc : sample_loader port map(
	load_ready_in => data_req,
	sample_out => sample
);

end max98257_sine_arch;
