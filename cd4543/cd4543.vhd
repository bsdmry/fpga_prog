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
signal check: std_logic_vector(3 downto 0) := "0000";
signal oseg: std_logic_vector(6 downto 0) := "0000000";
signal change: std_logic := '0';
signal det: std_logic := '0';
begin
	bcdconv: bcd2sseg port map(
			b0=> inbcd(0), b1=> inbcd(1), b2=> inbcd(2), b3=> inbcd(3),
			a=>oseg(0),b=>oseg(1),c=>oseg(2),d=>oseg(3),
			e=>oseg(4),f=>oseg(5),g=>oseg(6));
	
	-- seg    blank     phase    out
	--  1     0         0	     1
	--  1     0         1        0
	--  1     1         0        0
	--  1     1         1        1
	--  0     0         0        0
	--  0     0         1        1
	--  0     1         0        0
	--- 0     1         1        1
	
	q(0) <= (not oseg(0) and ph) or (bl and ph) or (oseg(0) and not bl and not ph);
	q(1) <= (not oseg(1) and ph) or (bl and ph) or (oseg(1) and not bl and not ph);
	q(2) <= (not oseg(2) and ph) or (bl and ph) or (oseg(2) and not bl and not ph);
	q(3) <= (not oseg(3) and ph) or (bl and ph) or (oseg(3) and not bl and not ph);
	q(4) <= (not oseg(4) and ph) or (bl and ph) or (oseg(4) and not bl and not ph);
	q(5) <= (not oseg(5) and ph) or (bl and ph) or (oseg(5) and not bl and not ph);
	q(6) <= (not oseg(6) and ph) or (bl and ph) or (oseg(6) and not bl and not ph);
	change <= (d(0) xor check(0)) or (d(1) xor check(1)) or (d(2) xor check(2)) or (d(3) xor check(3));
	process(change) begin
		if rising_edge(change) then
			det <= det xor '1';
			check <= d;
			if le_n = '1' then
				inbcd <= d;
			end if;
		end if;
	end process;
end cd4543_arch;

