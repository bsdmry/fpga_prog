library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tang_ft2232_mirror is 
port (
	clk: in std_logic;
	cs_in: in std_logic;
	dat_in: in std_logic;
	dir_in: in std_logic;
	sclk_in: in std_logic;
	tms_in: in std_logic;
	tck_in: in std_logic;
	tdi_in: in std_logic;
	tdo_in: in std_logic;
	tx_in: out std_logic;
	rx_in: in std_logic;

	cs_out: out std_logic;
	dat_out: out std_logic;
	dir_out: out std_logic;
	sclk_out: out std_logic;
	tms_out: out std_logic;
	tck_out: out std_logic;
	tdi_out: out std_logic;
	tdo_out: out std_logic;
	tx_out: in std_logic;
	rx_out: out std_logic
);
end tang_ft2232_mirror;

architecture tang_ft2232_mirror_arch of tang_ft2232_mirror is
begin
	process(clk) begin
	if rising_edge(clk) then
	cs_out <= cs_in;
	dat_out <= dat_in;
	dir_out <= dir_in;
	sclk_out <= sclk_in;
	tms_out <= tms_in;
	tck_out <= tck_in;
	tdi_out <= tdi_in;
	tdo_out <= tdo_in;
	tx_in <= tx_out;
	rx_out <= rx_in;
	end if;
	end process;
end;
