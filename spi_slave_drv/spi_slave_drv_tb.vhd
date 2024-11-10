library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity spi_slave_drv_tb is
end spi_slave_drv_tb;

architecture spi_slave_drv_tb_arch of spi_slave_drv_tb is
component spi_slave_drv is port (
	clk : in std_logic;
	mosi: in std_logic;
	miso: out std_logic;
	ss: in std_logic;
	master_rcv: out std_logic_vector(15 downto 0);
	slave_trx: in std_logic_vector(15 downto 0);
	cmd_bit_len: in natural range 0 to 14;
	cmd_ready: out std_logic;
	done: out std_logic
	);
end component;

signal clk:  STD_LOGIC := '0';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 50 ns;
constant cmd_len: natural := 3;

signal mosi_out: std_logic := '0';
signal miso_out: std_logic;
signal ss_out: std_logic := '1';
signal host_command: std_logic_vector(15 downto 0);
signal slave_reply: std_logic_vector(15 downto 0) := x"0000";
signal cmd_flag: std_logic;
signal done_flag: std_logic;
constant cmd1: std_logic_vector(15 downto 0) := "1111000000000000";
constant cmd2: std_logic_vector(15 downto 0) := "1001000000000000";
constant cmd3: std_logic_vector(15 downto 0) := "1100000000000000";
signal cmd_buf: std_logic_vector(15 downto 0) := x"0000";

procedure spiMasterTx(
	signal fclk: out std_logic; 
	signal fss_out: out std_logic;
	signal fmosi_out: out std_logic;
	signal fcmd_buf: in std_logic_vector(15 downto 0)
) is
begin
	fss_out <= '0';
	wait for clk_period;
	for i in fcmd_buf'range loop
		fmosi_out <= fcmd_buf(i);
		fclk <= '0';
		wait for clk_period/2;
		fclk <= '1';
		wait for clk_period/2;
	end loop;
	fclk <= '0';
	wait for clk_period;
	fss_out <= '1';
end procedure spiMasterTx;

begin
--	UNIT UNDER TEST
uut: spi_slave_drv port map (
	clk => clk,
	mosi => mosi_out,
	miso => miso_out,
	ss => ss_out,
	master_rcv => host_command,
	slave_trx => slave_reply,
	cmd_bit_len => cmd_len,
	cmd_ready => cmd_flag,
	done => done_flag
);


--	TEST SIGNALS
stim_process : process
begin
	wait for 30 ns;
	-- INSERT TEST CODE HERE ---
	cmd_buf <= cmd1;
	spiMasterTx(clk, ss_out, mosi_out, cmd_buf);	
	wait for 30 ns;
	cmd_buf <= cmd2;
	spiMasterTx(clk, ss_out, mosi_out, cmd_buf);	
	wait for 30 ns;
	cmd_buf <= cmd3;
	spiMasterTx(clk, ss_out, mosi_out, cmd_buf);	
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

cmd_parser_process: process(cmd_flag)
begin
	if rising_edge(cmd_flag) then
		case host_command(15 downto 12) is
			when "1111" =>  slave_reply(11 downto 0) <= "100001111000";
			when "1001" =>  slave_reply(11 downto 0) <= "100001001000";
			when others =>  slave_reply(11 downto 0) <= "100000000001";
		end case;
	end if;
end process;


end spi_slave_drv_tb_arch;

