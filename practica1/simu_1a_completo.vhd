-- Añadimos las librerias necesarias
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;

--entidad
 
ENTITY simsum IS
END simsum;
 
--arquitectura

ARCHITECTURE testbench_arch OF simsum IS 
 
-- Declaración del componente que vamos a simular

    COMPONENT sumador
    PORT(
         A : IN  std_logic_vector(3 downto 0);
         B : IN  std_logic_vector(3 downto 0);
         C : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    
--Entradas
   signal A : std_logic_vector(3 downto 0) := (others => '0');
   signal B : std_logic_vector(3 downto 0) := (others => '0');

--Salidas
   signal C : std_logic_vector(3 downto 0);
  
BEGIN
 
-- Instanciacion de la unidad a simular 
   uut: sumador PORT MAP (
          A => A,
          B => B,
          C => C
        );

-- Proceso de estimulos
stim_proc: process
 variable v_dato_debug   : std_logic_vector(3 downto 0);
   begin		
	loop_debug1: for j in 0 to 15 loop
		loop_debug2: for i in 0 to 15 loop
			A<=conv_std_logic_vector (i,4);
			B<=conv_std_logic_vector(j,4);
			wait for 5 ns;
			v_dato_debug :=A+B;
			assert v_dato_debug = C
         report "Error en la suma"
         severity error;
			wait for 5 ns;
		end loop loop_debug2;
	end loop loop_debug1;
      wait;
end process;

END testbench_arch;
