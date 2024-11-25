library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity dram_ctl_tb is
end dram_ctl_tb;

architecture dram_ctl_tb_arch of dram_ctl_tb is
component dram_ctl is port (
	clk : in std_logic;
		ras: out std_logic;
		cas: out std_logic;
		addr: out std_logic_vector(7 downto 0);
		wr: out std_logic;
		data: inout std_logic := 'Z';
		dram_addr: in std_logic_vector(15 downto 0);
		byte_out: out std_logic_vector(7 downto 0);
		byte_in: in std_logic_vector(7 downto 0);
		rw_flag: in std_logic;
		do_rw: in std_logic;
		done_rw: out std_logic
	);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 20 ns;

signal mem_ras: std_logic;
signal mem_cas: std_logic;
signal mem_addr: std_logic_vector(7 downto 0);
signal mem_wr: std_logic;
signal mem_data: std_logic;
signal ext_addr: std_logic_vector(15 downto 0) := x"0000";
signal ext_byte_tx: std_logic_vector(7 downto 0) := x"00";
signal ext_byte_rx: std_logic_vector(7 downto 0) := x"00";
signal ext_rw_flag: std_logic := '0';
signal ext_do_rw: std_logic := '0';
signal ext_done_rw: std_logic;
type mem is array (0 to 255) of bit_vector(255 downto 0); 
type bitmem is array(0 to 255, 0 to 255) of std_logic;

signal dram: bitmem := (others=>(others=>'0'));
signal raddr: std_logic_vector(7 downto 0) := x"00";
signal caddr: std_logic_vector(7 downto 0) := x"00";

begin
--	UNIT UNDER TEST
uut: dram_ctl port map (
	clk => clk,
	ras => mem_ras,
	cas => mem_cas,
	addr => mem_addr,
	wr => mem_wr,
	data => mem_data,
	dram_addr => ext_addr,
	byte_out => ext_byte_rx,
	byte_in => ext_byte_tx,
	rw_flag => ext_rw_flag,
	do_rw => ext_do_rw,
	done_rw => ext_done_rw
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

dram_radd_process : process(mem_ras)
begin
	if falling_edge(mem_ras) then
		raddr <= mem_addr;
	end if;
end process;

dram_cadd_process : process(mem_cas)
begin
	if falling_edge(mem_cas) then
		caddr <= mem_addr;
		if mem_wr = '0' then 
			mem_data <= 'Z';
			dram(to_integer(unsigned(raddr)), to_integer(unsigned(caddr))) <= mem_data;
		else
			mem_data <= dram(to_integer(unsigned(raddr)), to_integer(unsigned(caddr))); 
		end if;
		report("Row ->") & integer'image(to_integer(unsigned(raddr)));
		report("Col->") & integer'image(to_integer(unsigned(caddr)));  
		report("Bit:") & std_logic'image(mem_data); 
	end if;
end process;


--	TEST SIGNALS
stim_process : process
begin
	wait for 300 ns;
	-- INSERT TEST CODE HERE ---
	ext_addr <= x"1008";
	ext_byte_tx <= x"0A";
	ext_rw_flag <= '1';
	ext_do_rw <= '1';
	wait for clk_period;
	ext_do_rw <= '0';
	wait for 4 us;
	report "x0A ->" & std_logic'image(dram(16, 8));
	report "x0A ->" & std_logic'image(dram(16, 9));
	report "x0A ->" & std_logic'image(dram(16, 10));
	report "x0A ->" & std_logic'image(dram(16, 11));
	report "x0A ->" & std_logic'image(dram(16, 12));
	report "x0A ->" & std_logic'image(dram(16, 13));
	report "x0A ->" & std_logic'image(dram(16, 14));
	report "x0A ->" & std_logic'image(dram(16, 15));

	ext_addr <= x"1018";
	ext_byte_tx <= x"AD";
	ext_rw_flag <= '1';
	ext_do_rw <= '1';
	wait for clk_period;
	ext_do_rw <= '0';
	wait for 4 us;

	ext_addr <= x"1008";
	ext_rw_flag <= '0';
	ext_do_rw <= '1';
	wait for clk_period;
	ext_do_rw <= '0';
	wait for 4 us;

	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end dram_ctl_tb_arch;

