library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity cd4543 is
    Port ( 
		le_n : in std_logic;
		d: in std_logic_vector(3 downto 0);
		ph: in std_logic;
		bl: in std_logic;
		q: out std_logic_vector(6 downto 0)
	 );
end cd4543;

architecture cd4543_arch of cd4543 is
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
signal inbcd: std_logic_vector(3 downto 0) := "0000";
signal oseg: std_logic_vector(6 downto 0) := "0000000";
signal change: std_logic;
begin
	bcdconv: bcd2sseg port map(
			b0=> inbcd(0), b1=> inbcd(1), b2=> inbcd(2), b3=> inbcd(3),
			a=>oseg(0),b=>oseg(1),c=>oseg(2),d=>oseg(3),
			e=>oseg(4),f=>oseg(5),g=>oseg(6));
	
	q(0) <= (not bl and ph) or (ph and not oseg(0)) or (bl and not ph and oseg(0));
	q(1) <= (not bl and ph) or (ph and not oseg(1)) or (bl and not ph and oseg(1));
	q(2) <= (not bl and ph) or (ph and not oseg(2)) or (bl and not ph and oseg(2));
	q(3) <= (not bl and ph) or (ph and not oseg(3)) or (bl and not ph and oseg(3));
	q(4) <= (not bl and ph) or (ph and not oseg(4)) or (bl and not ph and oseg(4));
	q(5) <= (not bl and ph) or (ph and not oseg(5)) or (bl and not ph and oseg(5));
	q(6) <= (not bl and ph) or (ph and not oseg(6)) or (bl and not ph and oseg(6));
	change <= (d(0) xor inbcd(0)) or (d(1) xor inbcd(1)) or (d(2) xor inbcd(2)) or (d(3) xor inbcd(3));
	process(change) begin
		if rising_edge(change) then
			if le_n = '1' then
				inbcd <= d;
			end if;
		end if;
	end process;
end cd4543_arch;

