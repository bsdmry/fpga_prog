library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dram_spi_bridge is 
	port(
		clk: in std_logic;
		spi_data_from_master: in std_logic_vector(15 downto 0);
		spi_data_to_master: in std_logic_vector(15 downto 0);
		spi_cmd_ready: in std_logic;
		spi_done: in std_logic;
		dram_access_addr: out std_logic_vector(15 downto 0);
		dram_byte_from_mem: in std_logic_vector(7 downto 0);
		dram_byte_to_mem: out std_logic_vector(7 downto 0);
		dram_rw_flag: out std_logic;
		dram_done: in std_logic		
	);
end dram_spi_bridge;

architecture dram_spi_bridge_arch of dram_spi_bridge is
variable state: std_logic_vector(2 downto 0) := "000";
variable incmd: std_logic_vector(3 downto 0) := "0000";
variable access_addr: std_logic_vector(15 downto 0) := x"0000";

begin
	process(clk) begin
		if rising_edge(clk) then
			case state is
				when "000" =>
					if spi_cmd_ready = '1' then
						incmd <= spi_data_from_master(15 downto 12);
						state := "001";
					end if;
				when "001" =>
					case incmd is
						when "1000" => state := "010"; --hi address in data section
						when "1010" => state := "011"; --low address in data section, read
						when "1011" => state := "100"; --low address in data section, write
						when others =>
					end case;
				when "010" =>
					if spi_done = '1' then
						access_addr(15 downto 8) := spi_data_from_master(7 downto 0);
						state := "000";
					end if;
				when "011" =>
					if spi_done = '1' then
						access_addr(7 downto 0) := spi_data_from_master(7 downto 0);
						state := "000";
					end if;
				when "100" =>
					if spi_done = '1' then
						
					end if;
				when others =>
			end case;
		end if;	
	end process;
end dram_spi_bridge_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dram_via_spi is
    Port ( clk : in  STD_LOGIC;
			ext_spi_clk: in std_logic;
			ext_spi_mosi: in std_logic;
			ext_spi_miso: out std_logic;
			ext_spi_cs: in std_logic;
			ext_dram_ras: out std_logic;
			ext_dram_cas: out std_logic;
			ext_dram_wr: out std_logic;
			ext_dram_addr: out std_logic_vector(7 downto 0);
			ext_dram_data: inout std_logic 
	 );
end dram_via_spi;

architecture dram_via_spi_arch of dram_via_spi is
component spi_slave_drv is
    Port ( clk : in  STD_LOGIC; 		-- master CLK
			mosi: in std_logic;			-- MOSI pin
			miso: out std_logic;		-- MISO pin
			ss: in std_logic;			-- CS pin
			master_rcv: out std_logic_vector(15 downto 0); 				-- data from master device
			slave_trx: in std_logic_vector(15 downto 0);			 	-- data to master device
			cmd_bit_len: in natural range 0 to 14;						-- number of command MSB bits 
			cmd_ready: out std_logic;							-- command is ready for checking
			done: out std_logic									-- end of data transmission
	 );
end component;
component dram_ctl is
    Port ( clk : in  STD_LOGIC; -- period 20 ns / 50 Mhz
		ras: out std_logic;
		cas: out std_logic;
		addr: out std_logic_vector(7 downto 0);
		wr: out std_logic;
		data: inout std_logic;
		dram_addr: in std_logic_vector(15 downto 0);
		byte_out: out std_logic_vector(7 downto 0);
		byte_in: in std_logic_vector(7 downto 0);
		rw_flag: in std_logic;
		do_rw: in std_logic;
		done_rw: out std_logic
	 );
end component;


begin
	process(clk) begin

	end process;
end dram_via_spi_arch;

