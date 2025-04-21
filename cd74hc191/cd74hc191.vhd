library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cd74hc191 is
    Port ( 
		clk : in  STD_LOGIC;
		din : in std_logic_vector(3 downto 0);
		dout: out std_logic_vector(3 downto 0);
		ce_n: in std_logic;
		up_n_down: in std_logic;
		pl_n: in std_logic;
		tc: out std_logic;
		rc_n: out std_logic
	 );
end cd74hc191;

architecture cd74hc191_arch of cd74hc191 is
signal counter: std_logic_vector(3 downto 0) := "0000";
signal preload: std_logic_vector(3 downto 0) := "0000";
signal tc_sig: std_logic := '0';
signal clock: std_logic;

signal trigger: std_logic := '0';
signal trigger_set: std_logic := '0';
signal trigger_rst: std_logic := '0';
begin
	process(clk) begin
		if rising_edge(clk) then
			if trigger = '1' then
				counter <= preload;
				tc_sig <= '0';
				trigger_rst <= trigger_rst xor '1';
			else

			if ce_n = '0' then
				if up_n_down = '0' then
					case counter is
						when "1110" => counter <= "1111"; tc_sig <= '1';
						when others => counter <= std_logic_vector(unsigned(counter)+1); tc_sig <= '0';
					end case;
				else
					case counter is
						when "0001" => counter <= "0000"; tc_sig <= '1';
						when others => counter <= std_logic_vector(unsigned(counter)-1); tc_sig <= '0';
					end case;
				end if;
			end if;

			end if;
		end if;
		dout <= counter;
	end process;

	process(pl_n) begin
		if falling_edge(pl_n) then
			preload <= din;
			trigger_set <= trigger_set xor '1';
		end if;
	end process;

	process(trigger_set, trigger_rst) begin
		trigger <= (not trigger_set and trigger_rst) or (trigger_set and not trigger_rst);
	end process;

	rc_n <= ce_n or not tc_sig or clk;
	tc <= tc_sig;
end cd74hc191_arch;

