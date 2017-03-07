--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:32:11 10/17/2014
-- Design Name:   
-- Module Name:   C:/Users/Inma/Documents/docencia/TOC/PracticasVHDL/Practica2/simu_2.vhd
-- Project Name:  Practica2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: reflejo
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY simu_reflejo IS
END simu_reflejo;
 
ARCHITECTURE behavior OF simu_reflejo IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT reflejo
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         boton : IN  std_logic;
         switch : IN  std_logic;
         luces : OUT  std_logic_vector(3 downto 0));
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal boton : std_logic := '1';
	signal switch : std_logic := '0';

 	--Outputs
   signal luces : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: reflejo PORT MAP (
          clk => clk,
          rst => rst,
          boton => boton,
          switch => switch,
          luces => luces
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
      -- hold reset state for 100 ns.
		rst<='1';
      wait for 100 ns;	

-- insert stimulus here 
		rst<='0';
		wait for 100 ns;	
		boton<='0';
		wait for 100 ns;
		boton<='1';
		wait for 100 ns;	
		switch<='1';
		wait for 100 ns;	
		switch<='0';
		wait for 100 ns;	
		boton<='0';
		wait for 100 ns;	
		switch<='1';
		boton<='1';
		wait for 100 ns;	
		switch<='0';
		wait for 150 ns;	
		boton<='0';
		wait for 100 ns;	
		switch<='1';
		boton<='1';
		wait for 100 ns;	
		switch<='0';
      wait;
		
   end process;

END;
