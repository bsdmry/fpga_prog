library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd74hc191_tb is
end cd74hc191_tb;

architecture cd74hc191_tb_arch of cd74hc191_tb is
component cd74hc191 is port (
		clk : in  STD_LOGIC;
		din : in std_logic_vector(3 downto 0);
		dout: out std_logic_vector(3 downto 0);
		ce_n: in std_logic;
		up_n_down: in std_logic;
		pl_n: in std_logic;
		tc: out std_logic;
		rc_n: out std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;
constant val: std_logic_vector(7 downto 0) := x"64";
signal outval: std_logic_vector(7 downto 0) := x"00";
signal dir: std_logic := '1'; --down
signal preload_usr: std_logic := '1';
signal preload_global: std_logic;
signal tc0, tc1: std_logic;
signal carry0, carry1: std_logic;
begin
--	UNIT UNDER TEST
--Synchronous n+1-stage down counter using ripple carry/borrow and auto pre-load
preload_global <= (preload_usr and carry1) or (preload_usr and carry0);
uut0: cd74hc191 port map (
	clk => clk,
	din => val(3 downto 0),
	dout => outval(3 downto 0),
	ce_n => '0',
	up_n_down => dir,
	pl_n => preload_global,
	tc => tc0,
	rc_n => carry0
);

uut1: cd74hc191 port map (
	clk => clk,
	din => val(7 downto 4),
	dout => outval(7 downto 4),
	ce_n => carry0,
	up_n_down => dir,
	pl_n => preload_global,
	tc => tc1,
	rc_n => carry1
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
	wait for 30 ns;
	preload_usr <= '0';
	wait for 60 ns;
	preload_usr <= '1';
	wait for 60 us;
	-- INSERT TEST CODE HERE ---
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end cd74hc191_tb_arch;

