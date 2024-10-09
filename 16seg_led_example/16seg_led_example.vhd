library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity 16seg_led_example is
    Port ( clk : in  STD_LOGIC;
    	   clr_btn: in std_logic
	   msg_btn: in std_logic;
    	   driver_cs: out std_logic;
    	   driver_clk: out std_logic;
    	   driver_data: out std_logic
	 );
end 16seg_led_example;

architecture 16seg_led_example_arch of 16seg_led_example is
component mseg_ctl is port (
	clk : in std_logic;
	spi_clk_div: in std_logic_vector(3 downto 0);
	spi_clk: out std_logic;
	spi_data: out std_logic;
	spi_cs: out std_logic;
	symbol: in std_logic_vector(15 downto 0);
	dot: in std_logic;
	position: in std_logic_vector(2 downto 0);
	clear: in std_logic;
	set: in std_logic
	);
end component;
constant scaler_value: std_logic_vector(3 downto 0) := "1111";
signal symbol: std_logic_vector(15 downto 0);
signal dot: std_logic := '0';
signal position: std_logic_vector(2 downto 0) := "010";
signal clear_sig: std_logic := '0';
signal set_sig: std_logic := '0';

begin
driver : mseg_ctl port map(
	clk => clk,
	spi_clk_div => scaler_value,
	spi_clk => driver_clk,
	spi_data => driver_data,
	spi_cs => driver_cs,
	symbol => symbol,
	dot => dot,
	position => position,
	clear => clear_sig,
	set => set_sig
);

	process(clk) begin
		if rising_edge(clk) then
			if clr_btn = '0' then
				clear_sig <= '1';
				set_sig <= '1';
			else
				if msg_btn = '0' then
					clear_sig <= '0';
					set_sig <= '1';
				else
					clear_sig <= '0';
					set_sig <= '0';
				end if;
			end if;
		end if;
	end process;

end 16seg_led_example_arch;

