library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity seven_seg_tester is
    Port ( clk : in  std_logic;
		   frq_chg_in: in std_logic;
		   --cntout: out std_logic_vector(3 downto 0);
    	   segs: out std_logic_vector(7 downto 0);
    	   pos: out std_logic_vector(3 downto 0)
	 );
end seven_seg_tester;

architecture seven_seg_tester_arch of seven_seg_tester is
component gen10clock is
generic (CLK_MHZ: natural);
port (
	clk : in  std_logic;
    c10k: out std_logic := '0'; --10 kHz clk
    c1k: out std_logic := '0'; --1 kHz clk
    c100: out std_logic := '0'; --100 Hz clk
    c10: out std_logic := '0'; --10 Hz clk
    c1: out std_logic -- 1Hz clk
);
end component;

component cd4543_clk is
    port (
		clk: in std_logic; 
		le_n : in std_logic; d: in std_logic_vector(3 downto 0);
		ph: in std_logic; bl: in std_logic;
		q: out std_logic_vector(6 downto 0));
end component;

component cd74hc153 is
    port ( 
		mux0in : in std_logic_vector(3 downto 0); mux1in : in std_logic_vector(3 downto 0);
    	s0: in std_logic; s1: in std_logic; en0_n: in std_logic; en1_n: in std_logic;
    	out0: out std_logic; out1: out std_logic);
end component;

component cd4029 is
    Port ( 
	clk : in  STD_LOGIC;
    	bindec: in std_logic;
    	updown: in std_logic;
    	preset_en: in std_logic;
    	carry_in: in std_logic;
    	jam: in std_logic_vector(3 downto 0);
    	output: out std_logic_vector(3 downto 0);
    	carry_out: out std_logic
	 );
end component;

component cd74hc74_async_rst is
    port (
		clk0: in std_logic; d0 : in std_logic;
		r0_n: in std_logic; s0_n: in std_logic;
		q0: out std_logic := '0'; q0_n: out std_logic;
		clk1: in std_logic; d1 : in std_logic;
		r1_n: in std_logic; s1_n: in std_logic;
		q1: out std_logic := '0'; q1_n: out std_logic
	 );
end component;

signal clk10kh, clk1kh, clk10h, clk1h: std_logic;
signal bcd0: std_logic_vector(3 downto 0) := "0000";
signal bcd1: std_logic_vector(3 downto 0) := "0000";
signal bcd2: std_logic_vector(3 downto 0) := "0000"; 
signal bcd3: std_logic_vector(3 downto 0) := "0000";

signal active_bcd: std_logic_vector(3 downto 0) := "0000";
signal active_dig: std_logic_vector(1 downto 0) := "00";

signal frq_chng: std_logic;
signal bcd0_crry, bcd1_crry, bcd2_crry, bcd3_crry: std_logic;
signal frq_chng_dir: std_logic := '1';

begin
	clk_src: gen10clock generic map(CLK_MHZ => 27) port map(clk=>clk, c10k=>clk10kh, c1k=>clk1kh, c10=>clk10h, c1=>clk1h);
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
	bcd2ss: cd4543_clk port map(clk=>clk10kh, le_n => '1', d=>active_bcd, ph=>'0', bl=>'0', q=>segs(6 downto 0));
	segs(7) <= '1';

	u_bcd0: cd4029 port map (
    	clk => frq_chng, bindec => '0', updown => frq_chng_dir, preset_en => '0',
    	carry_in => '0', jam => "0000", output =>bcd0,
    	carry_out => bcd0_crry);
	u_bcd1: cd4029 port map (
    	clk => frq_chng, bindec => '0', updown => frq_chng_dir, preset_en => '0',
    	carry_in => bcd0_crry, jam => "0000", output =>bcd1,
    	carry_out => bcd1_crry);
	u_bcd2: cd4029 port map (
    	clk => frq_chng, bindec => '0', updown => frq_chng_dir, preset_en => '0',
    	carry_in => bcd1_crry, jam => "0000", output =>bcd2,
    	carry_out => bcd2_crry);
	u_bcd3: cd4029 port map (
    	clk => frq_chng, bindec => '0', updown => frq_chng_dir, preset_en => '0',
    	carry_in => bcd2_crry, jam => "0000", output =>bcd3,
    	carry_out => bcd3_crry);

	debncr0: cd74hc74_async_rst port map(
			clk0=>clk1kh, d0=>frq_chg_in, r0_n=>'1', s0_n=>'1', q0_n=>frq_chng,
			clk1=>clk10h, d1=>'0', r1_n=>'1', s1_n=>'1');

	process(clk1kh) begin
		if rising_edge(clk1kh) then
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



