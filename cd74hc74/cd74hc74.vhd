-------------WARNING!------------------------------
-- FPGA can't implement async RESET and SET simultanious,
-- as it present in 74HC74. This model separated by 2 different cases:
-- 74HC74 with async RESET and sync SET
-- 74HC74 with sync RESET and async SET
--------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd74hc74_async_set is
    port (
		clk0: in std_logic; d0 : in std_logic;
		r0_n: in std_logic; s0_n: in std_logic;
		q0: out std_logic := '0'; q0_n: out std_logic := '1';
		clk1: in std_logic; d1 : in std_logic;
		r1_n: in std_logic; s1_n: in std_logic;
		q1: out std_logic := '0'; q1_n: out std_logic := '1'
	 );
end cd74hc74_async_set;

architecture cd74hc74_async_set_arch of cd74hc74_async_set is
component cd74hc74_half_async_set is
    port (
		clk: in std_logic; d : in std_logic;
		r_n: in std_logic; s_n: in std_logic;
		q: out std_logic; q_n: out std_logic);
end component;

begin
	ff0: cd74hc74_half_async_set port map(clk=>clk0, d=>d0, r_n => r0_n, s_n => s0_n, q=>q0, q_n=>q0_n);
	ff1: cd74hc74_half_async_set port map(clk=>clk1, d=>d1, r_n => r1_n, s_n => s1_n, q=>q1, q_n=>q1_n);
end cd74hc74_async_set_arch;

----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd74hc74_async_rst is
    port (
		clk0: in std_logic; d0 : in std_logic;
		r0_n: in std_logic; s0_n: in std_logic;
		q0: out std_logic := '0'; q0_n: out std_logic := '1';
		clk1: in std_logic; d1 : in std_logic;
		r1_n: in std_logic; s1_n: in std_logic;
		q1: out std_logic := '0'; q1_n: out std_logic := '1'
	 );
end cd74hc74_async_rst;

architecture cd74hc74_async_rst_arch of cd74hc74_async_rst is
component cd74hc74_half_async_rst is
    port (
		clk: in std_logic; d : in std_logic;
		r_n: in std_logic; s_n: in std_logic;
		q: out std_logic; q_n: out std_logic);
end component;

begin
	ff0: cd74hc74_half_async_rst port map(clk=>clk0, d=>d0, r_n => r0_n, s_n => s0_n, q=>q0, q_n=>q0_n);
	ff1: cd74hc74_half_async_rst port map(clk=>clk1, d=>d1, r_n => r1_n, s_n => s1_n, q=>q1, q_n=>q1_n);
end cd74hc74_async_rst_arch;

----------------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cd74hc74_half_async_rst is
    port (
		clk: in std_logic;
		d : in std_logic;
		r_n: in std_logic;
		s_n: in std_logic;
		q: out std_logic := '0';
		q_n: out std_logic := '1'
	 );
end cd74hc74_half_async_rst;

architecture cd74hc74_half_async_rst_arch of cd74hc74_half_async_rst is
begin
	process(clk, r_n) begin
		if r_n = '0' then
			q <= '0';
			q_n <= '1';
		elsif rising_edge(clk) then
			if s_n = '0' then
				q <= '1';
				q_n <= '0';
			else
				q <= d;
				q_n <= not d;
			end if;	
		end if;
	end process;
end cd74hc74_half_async_rst_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cd74hc74_half_async_set is
    port (
		clk: in std_logic;
		d : in std_logic;
		r_n: in std_logic;
		s_n: in std_logic;
		q: out std_logic := '0';
		q_n: out std_logic := '1'
	 );
end cd74hc74_half_async_set;

architecture cd74hc74_half_async_set_arch of cd74hc74_half_async_set is
begin
	process(clk, s_n) begin
		if s_n = '0' then
			q <= '1';
			q_n <= '0';
		elsif rising_edge(clk) then
			if r_n = '0' then
				q <= '0';
				q_n <= '1';
			else
				q <= d;	
				q_n <= not d;	
			end if;
		end if;
	end process;
end cd74hc74_half_async_set_arch;
