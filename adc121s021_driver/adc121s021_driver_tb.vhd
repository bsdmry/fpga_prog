library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity adc_spi_source is
port (
	adc_clk: in std_logic;
	adc_data: out std_logic := '0';
	adc_cs:	in std_logic
);
end adc_spi_source;

architecture adc_spi_source_arch of adc_spi_source is
constant adc_byte: std_logic_vector(15 downto  0) := x"0DEB";
signal index: natural range 0 to 15 := 15;
begin
	process(adc_clk)
	begin
		if falling_edge(adc_clk) then
			if adc_cs = '0' then
				case index is 
					when 15 => adc_data <= '0'; index <= index-1;
					when 14 => adc_data <= '0'; index <= index-1;
					when 1 => adc_data <= '0'; index <= index-1;
					when 0 => adc_data <= '0'; index <= 15;
					when others => adc_data <= adc_byte(index-2); index <= index-1;
				end case;
			else
				index <= 15;	
			end if;		
		end if;
	end process;
end adc_spi_source_arch;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

---------------------------------------------------------------

entity adc121s021_driver_tb is
end adc121s021_driver_tb;

architecture adc121s021_driver_tb_arch of adc121s021_driver_tb is
component adc121s021_driver is port (
	clk : in std_logic;
	cs: out std_logic := '1';
	sclk: out std_logic := '1';
	sdata: in std_logic;
	enable: in std_logic;
	adc_data: out std_logic_vector(15 downto 0) :=x"0000";
	data_ready: out std_logic := '0';
	srate_option: in std_logic_vector(1 downto 0)	
	);
end component;

component adc_spi_source is port (
	adc_clk: in std_logic;
	adc_data: out std_logic;
	adc_cs:	in std_logic
);
end component;

signal clk:  STD_LOGIC := '1';
signal sym_stop: STD_LOGIC := '0';
constant clk_period : time := 4 ns;
-------------------------------------
signal adc_clk_sig: std_logic;
signal adc_cs_sig: std_logic;
signal adc_data_sig: std_logic;
signal driver_enable: std_logic := '0';
constant sample_rate: std_logic_vector(1 downto 0) := "00";
signal adc_read_ready: std_logic; 
signal adc_data_out:  std_logic_vector(15 downto 0) :=x"0000";

begin
--	UNIT UNDER TEST
uut: adc121s021_driver port map (
	clk => clk,
	cs => adc_cs_sig,
	sclk => adc_clk_sig,
	sdata => adc_data_sig,
	enable => driver_enable,
	srate_option=> sample_rate,
	data_ready => adc_read_ready,
	adc_data => adc_data_out
);
src: adc_spi_source port map (
	adc_clk => adc_clk_sig,
	adc_data => adc_data_sig,
	adc_cs => adc_cs_sig
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
	-- INSERT TEST CODE HERE ---
	wait for 50 ns;
	driver_enable <= '1';
	wait for 200 ns;
	driver_enable <= '0';
	wait for 200 ns;
	report "end of test" severity note;
	sym_stop <= '1';
	wait;
end process;

end adc121s021_driver_tb_arch;

