library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd4017 is
    Port (
		clk : in  STD_LOGIC;
		inhibit: in std_logic;
		rst: in std_logic;
		output: out std_logic_vector(9 downto 0);
		carry: out std_logic := '1'
	 );
end cd4017;

architecture cd4017_arch of cd4017 is
	signal outval: std_logic_vector (9 downto 0) := "0000000001";
	signal after_reset: std_logic := '0';
begin
	process(clk) begin
		if rising_edge(clk) then
			if rst = '1' then	
				outval <= "0000000001";
				carry <= '1';
				after_reset <= '1';
			else
				if after_reset = '1' then
					after_reset <= '0';
				else
					if inhibit = '0' then
						outval(1) <= outval(0);
						outval(2) <= outval(1);
						outval(3) <= outval(2);
						outval(4) <= outval(3);
						outval(5) <= outval(4);
						outval(6) <= outval(5);
						outval(7) <= outval(6);
						outval(8) <= outval(7);
						outval(9) <= outval(8);
						outval(0) <= outval(9);
						case outval is
							when "0000010000" => carry <= '0';
							when "1000000000" => carry <= '1';
							when others =>
						end case;		
					end if;
				end if;
			end if;
		end if;
	end process;
	output <= outval;
end cd4017_arch;

