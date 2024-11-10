library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity spi_slave_drv is
    Port ( clk : in  STD_LOGIC; 		-- master CLK
			mosi: in std_logic;			-- MOSI pin
			miso: out std_logic := '0';	-- MISO pin
			ss: in std_logic;			-- CS pin
			master_rcv: out std_logic_vector(15 downto 0) := x"0000"; 	-- data from master device
			slave_trx: in std_logic_vector(15 downto 0);			 	-- data to master device
			cmd_bit_len: in natural range 0 to 14;						-- number of command MSB bits 
			cmd_ready: out std_logic := '0';							-- command is ready for checking
			done: out std_logic := '0'									-- end of data transmission
	 );
end spi_slave_drv;

architecture spi_slave_drv_arch of spi_slave_drv is
signal index: natural range 0 to 15 := 15;
begin
	process(clk) begin
		if rising_edge(clk) then
			if ss = '0' then
				if index = 15 - cmd_bit_len then 
					cmd_ready <= '1';
				else
					cmd_ready <= '0';
				end if;

				master_rcv(index) <= mosi;
				if index = 0 then
					index <= 15;
					done <= '1';
				else
					index <= index - 1;
					done <= '0';
				end if;
			else
				index <= 15;
				done <= '0';
			end if;
		end if;
	end process;
	
	process(clk) begin
		if falling_edge(clk) then
			if ss = '0' then
				miso <= slave_trx(index);
			end if;
		end if;
	end process;
end spi_slave_drv_arch;

