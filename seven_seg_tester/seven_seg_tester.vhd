library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity seven_seg_tester is
    Port ( clk : in  std_logic;
    	   segs: out std_logic_vector(7 downto 0);
    	   pos: out std_logic_vector(3 downto 0)
	 );
end seven_seg_tester;

architecture seven_seg_tester_arch of seven_seg_tester is
component clkgen is port (
	clk : in  std_logic;
    c100: out std_logic := '0'; --100 Hz clk
    c1: out std_logic -- 1Hz clk
);
end component;

component cd4543 is
    port ( 
		le_n : in std_logic; d: in std_logic_vector(3 downto 0);
		ph: in std_logic; bl: in std_logic;
		q: out std_logic_vector(6 downto 0)
	 );
end component;

component cd74hc153 is
    port ( 
	mux0in : in std_logic_vector(3 downto 0); mux1in : in std_logic_vector(3 downto 0);
    s0: in std_logic; s1: in std_logic; en0_n: in std_logic; en1_n: in std_logic;
    out0: out std_logic; out1: out std_logic);
end component;

signal clk100h, clk1h: std_logic;
signal bcd0: std_logic_vector(3 downto 0) := "0011";
signal bcd1: std_logic_vector(3 downto 0) := "0010";
signal bcd2: std_logic_vector(3 downto 0) := "0001"; 
signal bcd3: std_logic_vector(3 downto 0) := "0000";
signal active_bcd: std_logic_vector(3 downto 0) := "0000";
signal active_dig: std_logic_vector(1 downto 0) := "00";

signal inc: std_logic_vector(3 downto 0) := "0000";

begin
	clk_src: clkgen port map(clk=>clk, c100=>clk100h, c1=>clk1h);
	bcdmux0: cd74hc153 port map(
		mux0in(0)=>bcd0(0), mux0in(1)=>bcd1(0), mux0in(2)=>bcd2(0), mux0in(3)=>bcd3(0), 
		mux1in(0)=>bcd0(1), mux1in(1)=>bcd1(1), mux1in(2)=>bcd2(1), mux1in(3)=>bcd3(1),
		en0_n => '0', en1_n=>'0', s0=>active_dig(0), s1=>active_dig(1),
		out0=> active_bcd(0), out1=>active_bcd(1) 
	);
	bcdmux1: cd74hc153 port map(
		mux0in(0)=>bcd0(2), mux0in(1)=>bcd1(2), mux0in(2)=>bcd2(2), mux0in(3)=>bcd3(2), 
		mux1in(0)=>bcd0(3), mux1in(1)=>bcd1(3), mux1in(2)=>bcd2(3), mux1in(3)=>bcd3(3),
		en0_n => '0', en1_n=>'0', s0=>active_dig(0), s1=>active_dig(1),
		out0=> active_bcd(2), out1=>active_bcd(3) 
	);
	bcd2ss: cd4543 port map(le_n => '1', d=>active_bcd, ph=>'0', bl=>'0', q=>segs(6 downto 0));
	segs(7) <= '1';

	process(clk1h) 
		begin
		if rising_edge(clk1h) then
			case inc is
				when "1001" => inc <= "0000";
				when others => inc <= std_logic_vector(unsigned(inc)+1);
			end case;
			bcd0 <= inc;
		end if;
	end process;

	process(clk100h) begin
		if rising_edge(clk100h) then
			case active_dig is
				when "00" =>  pos <= "1101"; active_dig <= "01";
				when "01" =>  pos <= "1011"; active_dig <= "10";
				when "10" =>  pos <= "0111"; active_dig <= "11";
				when "11" =>  pos <= "1110"; active_dig <= "00";
				when others =>
			end case;
		end if;
	end process;

end seven_seg_tester_arch;



library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clkgen is
  generic (
     CLK_HZ   : natural := 27000000
  );
    port (
	clk : in  std_logic;
    	c100: out std_logic := '0'; --100 Hz clk
    	c1: out std_logic -- 1Hz clk
	 );
end clkgen;

architecture clkgen_arch of clkgen is
signal cnt: std_logic_vector(7 downto 0) := x"1A"; -- 27-1
constant prescaler: std_logic_vector(7 downto 0) := x"1A";
signal clk1mhz: std_logic := '0';
--constant clk100_halfperiod : integer := (50000 -1);
constant clk100_halfperiod : integer := (500 -1); --10kHz
constant clk1_halfperiod : integer := (500000 -1);
signal clk100: std_logic := '0';
signal clk1: std_logic := '0';
begin
process(clk) begin
	if rising_edge(clk) then
		case cnt is
			when "00000000" => clk1mhz <= '0'; cnt <= prescaler;
			when "00000001" => clk1mhz <= '1'; cnt <= std_logic_vector(unsigned(cnt) -1);
			when others => cnt <= std_logic_vector(unsigned(cnt) -1);
		end case;
	end if;
end process;

process(clk1mhz)
        variable c: natural range 0 to clk100_halfperiod := clk100_halfperiod;	
	begin
	if rising_edge(clk1mhz) then
		if c = 0 then 
			clk100 <= clk100 xor '1'; 
			c := clk100_halfperiod;
		else
			c := c-1;
		end if;
		c100 <= clk100;
	end if;
end process;

process(clk1mhz)
        variable c: natural range 0 to clk1_halfperiod := clk1_halfperiod;	
	begin
	if rising_edge(clk1mhz) then
		if c = 0 then 
			clk1 <= clk1 xor '1'; 
			c := clk1_halfperiod;
		else
			c := c-1;
		end if;
		c1 <= clk1;
	end if;
end process;

end clkgen_arch;
