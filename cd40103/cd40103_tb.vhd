library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd40103_tb is
end cd40103_tb;

architecture cd40103_tb_arch of cd40103_tb is
component cd40103 is port (
	clk : in std_logic;
	jam: in std_logic_vector(7 downto 0);
	clr_n: in std_logic;
	carryin_n: in std_logic;
	ape_n: in std_logic;
	spe_n: in std_logic;
	carryout_n: out std_logic := '1'
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;
constant pval: std_logic_vector(7 downto 0) := "00000100";
signal clr_n_line:  STD_LOGIC := '1';
signal carryin_n_line:  STD_LOGIC := '0';
signal ape_n_line:  STD_LOGIC := '1';
signal spe_n_line:  STD_LOGIC := '1';
signal carryout_n_line: std_logic;
--
constant sec_init: std_logic_vector(7 downto 0) := "00001001"; --9
signal set_init:  STD_LOGIC := '1';
signal spe_n_line1, carryout_n_line1,  spe_n_line2, carryout_n_line2: std_logic;

begin
--	UNIT UNDER TEST
uut: cd40103 port map (
	clk => clk,
	jam => pval,
	clr_n => clr_n_line,
	carryin_n => carryin_n_line,
	ape_n => ape_n_line,
	--spe_n => spe_n_line,
	spe_n => carryout_n_line,
	carryout_n => carryout_n_line
);

--Ripple cascading with preset to JAM on zero
spe_n_line1 <= set_init AND carryout_n_line1;
uut1: cd40103 port map (
	clk => clk,
	jam => sec_init,
	clr_n => clr_n_line,
	carryin_n => carryin_n_line,
	ape_n => ape_n_line,
	spe_n => spe_n_line1,
	carryout_n => carryout_n_line1
);
spe_n_line2 <= set_init AND carryout_n_line2; 
uut2: cd40103 port map (
	clk => carryout_n_line1,
	jam => sec_init,
	clr_n => clr_n_line,
	carryin_n => carryin_n_line,
	ape_n => ape_n_line,
	spe_n => spe_n_line2,
	carryout_n => carryout_n_line2
);
--End cascade
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
	wait for 30 ns;
	wait for 100 ns;
	set_init <= '0';
	wait for clk_period;
	set_init <= '1';
	wait for 420 ns;
	--spe_n_line <= '0';
	--wait for clk_period;
	--spe_n_line <= '1';
	wait for 610 ns;
	--clr_n_line <= '0';
	wait for clk_period;
	clr_n_line <= '1';
	wait for 1300 us;
	
	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end cd40103_tb_arch;

