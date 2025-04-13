library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd4026 is
    Port ( 
		clk : in  std_logic;
		rst: in std_logic;
		inhibit: in std_logic;
		disp_en_in: in std_logic;
		disp_en_out: out std_logic;
		segments: out std_logic_vector(6 downto 0) := "0000000"; --  0-a, 1-b, ... 6-g
		carry: out std_logic := '1';
		ung_c: out std_logic := '1'
	 );
end cd4026;

architecture cd4026_arch of cd4026 is
	signal outval: std_logic_vector (3 downto 0) := "0000";
	signal ungated_segments: std_logic_vector(6 downto 0);
	signal after_reset: std_logic := '0';

component bcd2sseg is
    Port ( 
		b0 : in  std_logic;
		b1 : in  std_logic;
		b2 : in  std_logic;
		b3 : in  std_logic;
		a : out  std_logic;
		b : out  std_logic;
		c : out  std_logic;
		d : out  std_logic;
		e : out  std_logic;
		f : out  std_logic;
		g : out  std_logic
	 );
end component;
	
begin
	process(clk) begin
		if rising_edge(clk) then
			if rst = '1' then	
				outval <= "0000";
				carry <= '1';
			else
					if inhibit = '0' then
						outval <= std_logic_vector(unsigned(outval) + 1);
						case outval is
							when "0100" => carry <= '0'; outval <= std_logic_vector(unsigned(outval) + 1);
							when "1001" => carry <= '1'; outval <= "0000";
							when others => outval <= std_logic_vector(unsigned(outval) + 1);
						end case;		
					end if;
			end if;
		end if;	
	end process;

	disp_en_out <= disp_en_in;
	segments(0) <= ungated_segments(0) and disp_en_in;
	segments(1) <= ungated_segments(1) and disp_en_in;
	segments(2) <= ungated_segments(2) and disp_en_in;
	segments(3) <= ungated_segments(3) and disp_en_in;
	segments(4) <= ungated_segments(4) and disp_en_in;
	segments(5) <= ungated_segments(5) and disp_en_in;
	segments(6) <= ungated_segments(6) and disp_en_in;
	decoder: bcd2sseg port map(
		b0 => outval(0), b1=> outval(1), 
		b2=>outval(2), b3=>outval(3), 
		a=>ungated_segments(0), b=>ungated_segments(1),
		c=>ungated_segments(2), d=>ungated_segments(3),
		e=>ungated_segments(4), f=>ungated_segments(5),
		g=>ungated_segments(6));
	ung_c <= ungated_segments(2);	
end cd4026_arch;

