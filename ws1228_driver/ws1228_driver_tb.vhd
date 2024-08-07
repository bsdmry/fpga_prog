library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ws1228_driver_tb is
end ws1228_driver_tb;

architecture ws1228_driver_arch_tb of ws1228_driver_tb is
component ws1228_driver is port (
	drv_clk_20mhz : in  STD_LOGIC;
	r : in  STD_LOGIC_VECTOR (7 downto 0);
	g : in  STD_LOGIC_VECTOR (7 downto 0);
	b : in  STD_LOGIC_VECTOR (7 downto 0);
	enable: in STD_LOGIC;
	output: out STD_LOGIC;
	done: out STD_LOGIC	);
end component;

signal clk:  STD_LOGIC := '1';
signal r_reg: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal g_reg: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal b_reg: STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal en:  STD_LOGIC := '0';
signal outd:  STD_LOGIC;
signal don:  STD_LOGIC;
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;

begin
uut: ws1228_driver port map ( 
	drv_clk_20mhz => clk,
	r => r_reg,
	g => g_reg,
	b => b_reg,
	enable => en,
	output => outd,
	done => don
);

clk_process : process
begin
	clk <= '0';
	wait for clk_period/2;
	clk <= '1';
	wait for clk_period/2;
	if sym_stop = '1' then
		wait;
	end if;
end process;

stim_process : process
begin
	wait for 30 ns;
	r_reg <= x"FF";
	g_reg <= x"01";
	b_reg <= x"FF";
	en <= '1';
	wait for 100 ns;
	en <= '0';
	wait for 60 us;
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;


end;
