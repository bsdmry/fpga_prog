library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lfsr_prnd_tb is
end lfsr_prnd_tb;

architecture lfsr_prnd_tb_arch of lfsr_prnd_tb is
component lfsr_prnd is port (
		clk:  in std_logic;
		preset_value: in std_logic_vector(23 downto 0);
		random_out: out std_logic_vector(23 downto 0);
		preset: in std_logic
);
end component;

signal clk:  STD_LOGIC := '1';
signal preset_val: STD_LOGIC_VECTOR (23 downto 0) := (others => '1');
signal preset_pin: std_logic := '0';
signal rnd_out: std_logic_vector(23 downto 0);

constant clk_period : time := 50 ns;
signal sym_stop: STD_LOGIC := '0';

begin 
uut: lfsr_prnd port map (
	clk => clk,
	preset_value => preset_val,
	random_out => rnd_out,
	preset => preset_pin
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

stim_process : process
begin
	wait for 30 ns;
	preset_val <= "000000001111111111111111";
	preset_pin <= '1';
	wait for 60 ns;
	preset_pin <= '0';
	wait for 60 us;
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;
end lfsr_prnd_tb_arch;
