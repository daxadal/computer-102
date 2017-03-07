
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
 
ENTITY testbench IS
END testbench;
 
ARCHITECTURE behavior OF testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT asm
    PORT(
         clk : IN  std_logic;
         rst_n : IN  std_logic;
         ini : IN  std_logic;
         clave : IN  std_logic_vector(3 downto 0);
         dir : OUT  std_logic_vector(6 downto 0);
         fin : OUT  std_logic;
         error : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst_n : std_logic := '0';
   signal ini : std_logic := '0';
   signal clave : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal dir : std_logic_vector(6 downto 0);
   signal fin : std_logic;
   signal error : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: asm PORT MAP (
          clk => clk,
          rst_n => rst_n,
          ini => ini,
          clave => clave,
          dir => dir,
          fin => fin,
          error => error
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst_n <= '1';
      wait for 50 ns;	
		rst_n <= '0';
      wait for clk_period*2;
		
		--clave nueva
      clave <= "0100";
		ini <= '1';
		wait for clk_period*2;
		ini <= '0';
		wait until fin = '1';
		wait for clk_period*2;
		
		--clave nueva
      clave <= "0010";
		ini <= '1';
		wait for clk_period*2;
		ini <= '0';
		wait until fin = '1';
		wait for clk_period*2;
		
		--clave nueva
      clave <= "0111";
		ini <= '1';
		wait for clk_period*2;
		ini <= '0';
		wait until fin = '1';
		wait for clk_period*2;
		
		--clave repetida
      clave <= "0100";
		ini <= '1';
		wait for clk_period*2;
		ini <= '0';
		wait until fin = '1';
		wait for clk_period*2;
		
		--clave nueva
      clave <= "1000";
		ini <= '1';
		wait for clk_period*2;
		ini <= '0';
		wait until fin = '1';
		wait for clk_period*2;
		
		--clave repetida
      clave <= "0010";
		ini <= '1';
		wait for clk_period*2;
		ini <= '0';
		wait until fin = '1';
		wait for clk_period*2;
		
		--clave repetida
      clave <= "0111";
		ini <= '1';
		wait for clk_period*2;
		ini <= '0';
		wait until fin = '1';
		wait for clk_period*2;
		
		--clave nueva
      clave <= "0000";
		ini <= '1';
		wait for clk_period*2;
		ini <= '0';
		wait until fin = '1';
		wait for clk_period*2;
		

      wait;
   end process;

END;
