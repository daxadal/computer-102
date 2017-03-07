
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity reflejo is
	port(clk, rst, boton, switch: in std_logic;
			luces: out std_logic_vector(3 downto 0));
end reflejo;

architecture Behavioral of reflejo is
	type estados is ( espera, ilumina, rapido, medio, lento, error,
		LEDrapido, LEDmedio, LEDlento, LEDerror);
	signal estado_act : estados;
	signal estado_sig : estados;
	
	signal clk_interno : std_logic;
	
-- Implementación
	component divisor is
		port ( reset, clk_entrada: in STD_LOGIC;
				clk_salida: out STD_LOGIC);
	end component;
------

begin

-- Implementación
	Nuevo_reloj: divisor port map (rst , clk, clk_interno);
-- Simulación
--	clk_interno <= clk;
------

	
	biestable: process (rst, clk_interno)
	begin
	
		if rst ='1' then
			estado_act <= espera;
		elsif clk_interno'event and clk_interno ='1' then
			estado_act <= estado_sig;
		end if;
		
	end process biestable;
	
	cambioEstado: process (estado_act, switch, boton)
	begin
		
		case estado_act is
			when espera => estado_sig <= ilumina;
			when ilumina => estado_sig <= rapido;
			
			when rapido =>
				if boton ='0' then
					estado_sig <= LEDrapido;
				else
					estado_sig <= medio;
				end if;
					
			when medio =>
				if boton ='0' then
					estado_sig <= LEDmedio;
				else
					estado_sig <= lento;	
				end if;
					
			when lento =>
				if boton ='0' then
					estado_sig <= LEDlento;
				else
					estado_sig <= error;
				end if;
					
			when error => estado_sig <= LEDerror;
			
			when LEDrapido =>
				if switch = '1' then
					estado_sig <= espera;
				else
					estado_sig <= LEDrapido;
				end if;
			
			when LEDmedio =>
				if switch = '1' then
					estado_sig <= espera;
				else
					estado_sig <= LEDmedio;
				end if;
				
			when LEDlento =>
				if switch = '1' then
					estado_sig <= espera;
				else
					estado_sig <= LEDlento;
				end if;
				
			when LEDerror =>
				if switch = '1' then
					estado_sig <= espera;
				else
					estado_sig <= LEDerror;
				end if;
		end case;
	
	end process cambioEstado;
	
	salida: process (estado_act)
	begin
	
		case estado_act is
			when espera => luces <= "0000";
			when ilumina => luces <= "1000";
			
			when rapido => luces <= "0000";
			when medio => luces <= "0000";
			when lento => luces <= "0000";
			when error => luces <= "0000";
			
			when LEDrapido => luces <= "0110";
			when LEDmedio => luces <= "0101";
			when LEDlento => luces <= "0100";
			when LEDerror => luces <= "0011";
		end case;
	
	end process salida;
					
					



end Behavioral;

