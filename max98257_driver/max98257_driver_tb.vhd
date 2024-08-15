library IEEE; 
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity max98257_driver_tb is
end max98257_driver_tb;

architecture max98257_driver_tb_arch of max98257_driver_tb is
component max98257_driver is port (
	parallel_in : in  STD_LOGIC_VECTOR (15 downto 0);
	driver_enable: in STD_LOGIC;
	load_ready: out STD_LOGIC := '0';
	drv_clk : in  STD_LOGIC; --32 kHz
	max98257_bclk : out  STD_LOGIC;
	max98257_lrclk: out STD_LOGIC;
	max98257_data: out STD_LOGIC;
	max98257_enable: out STD_LOGIC
);
end component;


--type sin_table16_16 is array(0 to 15) of unsigned (15 downto 0);
type sin_table16_16 is array(0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
constant sine : sin_table16_16 := (
x"8000", x"b0fb", x"da82", x"f641", x"ffff", x"f641", x"da82", x"b0fb",
x"8000", x"4f04", x"257d", x"09be", x"0000", x"09be", x"257d", x"4f04"

);

signal clk:  STD_LOGIC := '1';
signal sample1: STD_LOGIC_VECTOR (15 downto 0) := x"F00F";
signal sample2: STD_LOGIC_VECTOR (15 downto 0) := x"CCCC";

signal txreg: STD_LOGIC_VECTOR (15 downto 0) := x"0000";

signal data_req: STD_LOGIC;
signal bclk: STD_LOGIC;
signal lrclk: STD_LOGIC;
signal adata: STD_LOGIC;
signal en: STD_LOGIC;
signal drv_enable: STD_LOGIC;

constant clk_period : time := 977 ns;
signal sym_stop: STD_LOGIC := '0';

begin
uut: max98257_driver port map (
	drv_clk => clk,
	parallel_in => txreg,
	load_ready => data_req,
	max98257_bclk => bclk,
	max98257_lrclk => lrclk,
	max98257_data => adata, 
	max98257_enable => en, 
	driver_enable => drv_enable 
);

clk_process: process
begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
	if sym_stop = '1' then
		wait;
	end if;
end process;

delay_process : process
begin
	wait for 30 ns;
	drv_enable <= '1';
	wait for 20 ms;
	report "end of test" severity note;
	sym_stop <= '1';
	drv_enable <= '0';
	wait;
end process;

stim_process : process(data_req)
variable sin_index: natural range 0 to 15 := 0;
begin
	if rising_edge(data_req) then
		txreg <= sine(sin_index);
		if sin_index = 15 then sin_index := 0; else
		sin_index := sin_index + 1;
		end if;
	end if;
end process;

end max98257_driver_tb_arch;
