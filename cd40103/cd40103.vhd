library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

--WARNING! async preset with APE_N is not supported
entity cd40103 is
    Port ( clk : in  STD_LOGIC;
	jam: in std_logic_vector(7 downto 0);
	clr_n: in std_logic;
	carryin_n: in std_logic;
	ape_n: in std_logic;
	spe_n: in std_logic;
	carryout_n: out std_logic := '1'
	 );
end cd40103;

architecture cd40103_arch of cd40103 is
 signal cnt: std_logic_vector(7 downto 0) := x"FF";
 signal preload: std_logic_vector(7 downto 0) := x"FF";
 signal trigger: std_logic := '0';
 signal trigger_set: std_logic := '0';
 signal trigger_rst: std_logic := '0';
 signal clock: std_logic;
begin
	clock <= clk and not carryin_n;
	process(clock, clr_n) 
	begin
	if clr_n = '0' then
		cnt <= x"FF";
	elsif rising_edge(clock) then
		if trigger = '1' then
			trigger_rst <= trigger_rst xor '1';
			cnt <= preload;
			carryout_n <= '1';
		else
				case cnt is
					when x"01" => carryout_n <= '0'; cnt <= x"00"; 
					when x"00" => carryout_n <= '1'; cnt <= x"FF";
					when others => cnt <=  std_logic_vector(unsigned(cnt) -1);
				end case;
		end if;
	end if;
	end process;

	process(spe_n) begin
		if falling_edge(spe_n) then
			preload<= jam;
			trigger_set <= trigger_set xor '1';
		end if;
	end process;

	process(trigger_set, trigger_rst) begin
		trigger <= (not trigger_set and trigger_rst) or (trigger_set and not trigger_rst);
	end process;

end cd40103_arch;

