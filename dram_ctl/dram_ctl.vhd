library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity dram_ctl is
    Port ( clk : in  STD_LOGIC; -- period 20 ns / 50 Mhz
		ras: out std_logic := '1';
		cas: out std_logic := '1';
		addr: out std_logic_vector(7 downto 0) := x"00";
		wr: out std_logic := '1';
		data: inout std_logic := 'Z';
		dram_addr: in std_logic_vector(15 downto 0);
		byte_out: out std_logic_vector(7 downto 0) := x"00";
		byte_in: in std_logic_vector(7 downto 0);
		rw_flag: in std_logic;
		do_rw: in std_logic;
		done_rw: out std_logic := '0'
	 );
end dram_ctl;

architecture dram_ctl_arch of dram_ctl is
begin
	process(clk) 
		variable mode_state: std_logic_vector(2 downto 0) :=  "000";
		variable write_clock: natural range 0 to 16 := 0;
		variable read_clock: natural range 0 to 16 := 0;
		variable refresh_row_index: natural range 0 to 127 := 0; 
		variable refresh_clock: natural range 0 to 15 := 0;
		variable bit_index: natural range 0 to 7 := 7;
		variable offset_address: std_logic_vector(15 downto 0) := x"0000";
		begin
		if rising_edge(clk) then
			case mode_state is
				when "000" => -- check RW command, if none - refresh DRAM
							done_rw <= '0';
							if do_rw = '1' and rw_flag = '1' then 
								mode_state := "001";
								bit_index := 7;
								offset_address := dram_addr;
								data <= '0';	
							elsif do_rw = '1' and rw_flag = '0' then 
								mode_state := "010";
								bit_index := 7;
								offset_address := dram_addr;	
								data <= 'Z';	
							else
								case refresh_clock is
									when 0 => 
										addr <=  std_logic_vector(to_unsigned(refresh_row_index, 8)); 
										ras <= '0';
										refresh_clock := refresh_clock + 1;
									when 9 => 
										ras <= '1';
										refresh_clock := refresh_clock + 1;
									when 15 => 
										refresh_clock := 0;
										if refresh_row_index = 127 then
											refresh_row_index := 0;
										else
											refresh_row_index := refresh_row_index + 1;
										end if;	
									when others => refresh_clock := refresh_clock + 1; 
								end case;	
							end if;
				when "001" => --WRITE  
					case write_clock is
						when 0 => addr <= offset_address(15 downto 8); write_clock := write_clock + 1;
						when 1 => ras <= '0'; write_clock := write_clock + 1;
						when 3 => 	addr <= offset_address(7 downto 0); 
									wr <= '0';
									--if mode_state = "001" then data <= byte_in(bit_index); else data <= 'Z'; end if; ----DATA!!!!!!
									data <= byte_in(bit_index);

									write_clock := write_clock + 1;
						when 4 => cas <= '0'; write_clock := write_clock + 1;
						when 6 => wr <= '1'; write_clock := write_clock + 1;
						when 9 => cas <= '1'; write_clock := write_clock + 1;
						when 10 => ras <= '1'; write_clock := write_clock + 1;
						when 16 => 
									write_clock := 0;
									if bit_index = 0 then
										bit_index := 7;
										mode_state := "000";
										done_rw <= '1';
									else
										bit_index := bit_index -1;
										offset_address := std_logic_vector(unsigned(dram_addr) + (7 - bit_index));
									end if;
						when others => write_clock := write_clock + 1;
					end case;							
				when "010" => --READ
					case read_clock is
						when 0 => addr <= offset_address(15 downto 8); read_clock := read_clock + 1;
						when 1 => ras <= '0'; read_clock := read_clock + 1;
						when 3 => 	addr <= offset_address(7 downto 0); 
									wr <= '1';
									read_clock := read_clock + 1;
						when 4 => cas <= '0'; read_clock := read_clock + 1;
						when 6 => wr <= '0'; read_clock := read_clock + 1;
						when 9 => 	byte_out(bit_index) <= data;
									cas <= '1';	
									read_clock := read_clock + 1;
						when 10 => ras <= '1'; read_clock := read_clock + 1;
						when 16 => 
									read_clock := 0;
									if bit_index = 0 then
										bit_index := 7;
										mode_state := "000";
										done_rw <= '1';
									else
										bit_index := bit_index -1;
										offset_address := std_logic_vector(unsigned(dram_addr) + (7 - bit_index));
									end if;
						when others => read_clock := read_clock + 1;
					end case;
				when others => mode_state := "000";
			end case;
		end if;
	end process;
end dram_ctl_arch;

