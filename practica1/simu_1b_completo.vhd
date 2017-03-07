--Librerias necesarias
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_textio.all;
use std.textio.all;
 
 
ENTITY simreg IS
END simreg;
 
ARCHITECTURE behavior OF simreg IS 
 
-- Declaración del componente que vamos a simular
 
    COMPONENT reg_paralelo
    PORT(
         rst : IN  std_logic;
         clk_100MHz : IN  std_logic;
			load: IN  std_logic;
         EP : IN  std_logic_vector(3 downto 0);
         SP : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;

--Entradas
    signal rst : std_logic;
    signal clk_100MHz : std_logic;
	 signal load : std_logic;
    signal EP : std_logic_vector(3 downto 0);
		
--Salidas
    signal SP : std_logic_vector(3 downto 0);
   
--Se define el periodo de reloj 
    constant clk_100MHz_period : time := 50 ns;
 
BEGIN
 
-- Instanciacion de la unidad a simular 

   uut: reg_paralelo PORT MAP (
          rst => rst,
          clk_100MHz => clk_100MHz,
			 load=> load,
          EP => EP,
          SP => SP
        );

-- Definicion del process de reloj
reloj_process :process
   begin
	clk_100MHz <= '0';
	wait for clk_100MHz_period/2;
	clk_100MHz <= '1';
	wait for clk_100MHz_period/2;
end process;
 
-- External reset
  p_rst : process
  begin
    rst <= '1';
	--EP<="0000";
    wait for 50 ns;
    rst <= '0';
    wait;
  end process p_rst;
  
--Proceso de estimulos
stim_proc: process
 variable v_dato_debug   : std_logic_vector(3 downto 0);
   begin		
	EP<="0000";
	 load <= '1';
 wait for 50 ns;
--if rst='0' then
	 loop_debug1: for j in 0 to 15 loop
		
      EP <= conv_std_logic_vector(j,4);
		 v_dato_debug :=EP ;
			    wait until rising_edge(clk_100MHz);
			
        assert v_dato_debug = SP
          report "Error en la carga del registro"
          severity error;
			 
    end loop loop_debug1;

	 load <= '0';
	 loop_debug2: for j in 0 to 15 loop
      EP <= conv_std_logic_vector(j,4);
           wait until rising_edge(clk_100MHz);
       v_dato_debug := "1111";
		 
       assert v_dato_debug = SP
         report "Error en la carga del registro"
         severity error;
			end loop loop_debug2;
-- Se mantiene el rst activado durante 50 ns.
	--end if;
      wait;
end process;

END;
