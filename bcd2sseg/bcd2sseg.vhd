library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity bcd2sseg is
    Port ( 
		b0 : in  std_logic;
		b1 : in  std_logic;
		b2 : in  std_logic;
		b3 : in  std_logic;
		a : out  std_logic := '1';
		b : out  std_logic := '1';
		c : out  std_logic := '1';
		d : out  std_logic := '1';
		e : out  std_logic := '1';
		f : out  std_logic := '1';
		g : out  std_logic := '0'
	 );
end bcd2sseg;

architecture bcd2sseg_arch of bcd2sseg is
signal pb: std_logic_vector(3 downto 0);
signal nb: std_logic_vector(3 downto 0);

signal a_inter1: std_logic;
signal a_inter2: std_logic;
signal b_inter1: std_logic;
signal b_inter2: std_logic;
signal d_inter1: std_logic;
signal d_inter2: std_logic;
signal d_inter3: std_logic;
signal e_inter1: std_logic;
signal f_inter1: std_logic;
signal f_inter2: std_logic;
signal f_inter3: std_logic;
signal g_inter1: std_logic;
signal g_inter2: std_logic;
component OR2 is port (IN1,IN2: in STD_LOGIC; OUT1: out STD_LOGIC); end component;
component OR3 is port (IN1,IN2,IN3: in STD_LOGIC; OUT1: out STD_LOGIC); end component;
component AND2 is port (IN1,IN2: in STD_LOGIC; OUT1: out STD_LOGIC); end component;
component AND3 is port (IN1,IN2,IN3: in STD_LOGIC; OUT1: out STD_LOGIC); end component;
component AND4 is port (IN1,IN2,IN3,IN4: in STD_LOGIC; OUT1: out STD_LOGIC); end component;
begin
	pb(0) <= b0;
	pb(1) <= b1;
	pb(2) <= b2;
	pb(3) <= b3;
	nb(0) <= not b0;
	nb(1) <= not b1;
	nb(2) <= not b2;
	nb(3) <= not b3;

--
	a_el1: AND4 port map(IN1=>pb(0), IN2=>nb(2), IN3=>nb(3), IN4=>nb(1), OUT1=>a_inter1);	
	a_el2: AND3 port map(IN1=>nb(0), IN2=>pb(3), IN3=>nb(1), OUT1=>a_inter2);	
	a_el3: OR2 port map(IN1 =>a_inter1, IN2=>a_inter2, OUT1=>a);

	b_el1: AND3 port map(IN1=>pb(2), IN2=>nb(1), IN3=>pb(0), OUT1=>b_inter1);	
	b_el2: AND3 port map(IN1=>pb(2), IN2=>pb(1), IN3=>nb(0), OUT1=>b_inter2);	
	b_el3: OR2 port map(IN1 =>b_inter1, IN2=>b_inter2, OUT1=>b);

	c_el1: AND3 port map(IN1=>nb(0), IN2=>nb(2), IN3=>pb(1), OUT1=>c);

	d_el1: AND3 port map(IN1=>nb(1), IN2=>nb(0), IN3=>pb(2), OUT1=>d_inter1);
	d_el2: AND3 port map(IN1=>pb(2), IN2=>pb(1), IN3=>pb(0), OUT1=>d_inter2);
	d_el3: AND4 port map(IN1=>nb(3), IN2=>nb(2), IN3=>nb(1), IN4=>pb(0), OUT1=>d_inter3);
	d_el4: OR3 port map(IN1=>d_inter1, IN2=>d_inter2, IN3=>d_inter3, OUT1=>d);

	e_el1: AND2 port map(IN1=>pb(2), IN2=>nb(1), OUT1=>e_inter1);
	e_el2: OR2 port map(IN1=>e_inter1, IN2=>pb(0), OUT1=>e);

	f_el1: AND2 port map(IN1=>pb(0), IN2=>pb(1), OUT1=>f_inter1);
	f_el2: AND2 port map(IN1=>pb(1), IN2=>nb(2), OUT1=>f_inter2);
	f_el3: AND3 port map(IN1=>nb(3), IN2=>nb(2), IN3=>pb(0), OUT1=>f_inter3);
	f_el4: OR3 port map(IN1=>f_inter1, IN2=>f_inter2, IN3=>f_inter3, OUT1=>f);

	g_el1: AND3 port map(IN1=>nb(3), IN2=>nb(2), IN3=>nb(1), OUT1=>g_inter1);
	g_el2: AND3 port map(IN1=>pb(2), IN2=>pb(1), IN3=>pb(0), OUT1=>g_inter2);
	g_el3: OR2 port map(IN1=>g_inter1, IN2=>g_inter2, OUT1=>g);
end bcd2sseg_arch;

