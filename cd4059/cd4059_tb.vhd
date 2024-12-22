library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd4059_tb is
end cd4059_tb;

architecture cd4059_tb_arch of cd4059_tb is
component cd4059 is port (
	clk : in std_logic;
	Ka: in std_logic;
	Kb: in std_logic;
	Kc: in std_logic;
	jbus: in std_logic_vector(15 downto 0);
	output: out std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;
signal ka_pin: std_logic := '0';
signal kb_pin: std_logic := '0';
signal kc_pin: std_logic := '0';
signal jam_input1_4: std_logic_vector(3 downto 0) := "0000";
signal jam_input5_8: std_logic_vector(3 downto 0) := "0000";
signal jam_input9_12: std_logic_vector(3 downto 0) := "0000";
signal jam_input13_16: std_logic_vector(3 downto 0) := "0000";
signal output: std_logic;
signal measure: natural range 0 to 65535 := 0;

begin
--	UNIT UNDER TEST
uut: cd4059 port map (
	clk => clk,
	Ka => ka_pin,
	Kb => kb_pin,
	Kc => kc_pin,
	jbus(3 downto 0) => jam_input1_4,
	jbus(7 downto 4) => jam_input5_8,
	jbus(11 downto 8) => jam_input9_12,
	jbus(15 downto 12) => jam_input13_16,
	output => output
	
);
--	CLK GENERATOR
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

--	TEST SIGNALS
stim_process : process
begin
	wait for 300 ns;
	-- Setup divison by 8471
	-- Prescale clock 5 (N = 5)
	-- 8471 / 5 = 1694,2
	-- 
	-- Preset values  1694 and 2
	--
	-- J1  J2  J3  J4     J5  J6  J7  J8     J9  J10 J11 J12    J13 J14 J15 J16
	--  0   1   2   3      0   1   2   3 	  0   1   2   3      0   1   2   3
	-- |_________| |_|   |______________|    |_____________|    |_____________|
	--      2       1           4                   9                  6
	--
	--  0   1   0   1      0   0   1   0      1   0   0   1      0   1   1   0

	jam_input1_4 <= "1010";
	jam_input5_8 <= "0100";
	jam_input9_12 <= "1001";
	jam_input13_16 <= "0110";
	wait for clk_period;
	ka_pin <= '1';
	kb_pin <= '0';
	kc_pin <= '1';
	wait for 1 ms;
	
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

process(clk)
	begin
	if rising_edge(clk) then
		if output = '0' then
			measure <= measure +1;
		else
			measure <= 0;
		end if;
	end if;
end process;

end cd4059_tb_arch;

