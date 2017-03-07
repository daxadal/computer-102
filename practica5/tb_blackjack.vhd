
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY tb_blackjack IS
END tb_blackjack;
 
ARCHITECTURE behavior OF tb_blackjack IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT blackjack
    PORT(
         reset : IN  std_logic;
         clk : IN  std_logic;
         inicio : IN  std_logic;
         jugar : IN  std_logic;
         plantarse : IN  std_logic;
         ult_carta : OUT  std_logic_vector(3 downto 0);
         puntos : OUT  std_logic_vector(5 downto 0);
         pierdo : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal inicio : std_logic := '0';
   signal jugar : std_logic := '1';
   signal plantarse : std_logic := '1';

 	--Outputs
   signal ult_carta : std_logic_vector(3 downto 0);
   signal puntos : std_logic_vector(5 downto 0);
   signal pierdo : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: blackjack PORT MAP (
          reset => reset,
          clk => clk,
          inicio => inicio,
          jugar => jugar,
          plantarse => plantarse,
          ult_carta => ult_carta,
          puntos => puntos,
          pierdo => pierdo
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
      reset <= '1';
      wait for 30 ns;	
		reset <= '0';
		
		bucle: for i in 0 to 10 loop
			wait for clk_period*2;
			inicio <= '1';
			wait for clk_period*5;
			inicio <= '0';
			
			wait for clk_period*5;
			jugar <= '0';
			wait for clk_period*2;
			jugar <= '1';
			
			wait for clk_period*10;
			jugar <= '0';
			wait for clk_period*2;
			jugar <= '1';
			
			wait for clk_period*15;
			jugar <= '0';
			wait for clk_period*2;
			jugar <= '1';
			
			wait for clk_period*15;
			jugar <= '0';
			wait for clk_period*2;
			jugar <= '1';
			
			wait for clk_period*2;
			plantarse <= '0';
			wait for clk_period*2;
			plantarse <= '1';
			
		end loop bucle;
		

      wait;
   end process;

END;
