LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY dac10bit_tb IS
END dac10bit_tb;
 
ARCHITECTURE behavior OF dac10bit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dac10bit
    PORT(
         dac_out : OUT  std_logic_vector(9 downto 0);
         dac_clk : OUT  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';

 	--Outputs
   signal dac_out : std_logic_vector(9 downto 0);
   signal dac_clk : std_logic;

   -- Clock period definitions
   constant dac_clk_period : time := 10 ns;
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dac10bit PORT MAP (
          dac_out => dac_out,
          dac_clk => dac_clk,
          clk => clk
        );

   -- Clock process definitions
--   dac_clk_process :process
--   begin
--		dac_clk <= '0';
--		wait for dac_clk_period/2;
--		dac_clk <= '1';
--		wait for dac_clk_period/2;
--   end process;
 
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

END;
