
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity reflejo is
	port(clk, rst, boton, switch: in std_logic;
			luces: out std_logic_vector(4 downto 0));
end reflejo;

architecture Behavioral of reflejo is
	type estados is ( espera, ilumina, cuenta, led);
	signal estado_act : estados;
	signal estado_sig : estados;
	
	signal cuenta_act : std_logic_vector(3 downto 0);
	signal cuenta_sig : std_logic_vector(3 downto 0);
	
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
			cuenta_act <= "0000";
		elsif clk_interno'event and clk_interno ='1' then
			estado_act <= estado_sig;
			cuenta_act <= cuenta_sig;
		end if;
		
	end process biestable;
	
	cambioEstado: process (estado_act, switch, boton, cuenta_act)
	begin
		
		case estado_act is
			when espera => 
				estado_sig <= ilumina;
				cuenta_sig <= "0000";
			when ilumina => 
				if cuenta_act >= "0110" then
					estado_sig <= cuenta;
					cuenta_sig <= "0001";
				else
					estado_sig <= estado_act;
					cuenta_sig <= cuenta_act + "0001";
				end if;
			
			when cuenta =>
				if boton ='0' or cuenta_act = "1111" then
					estado_sig <= led;
					cuenta_sig <= cuenta_act;
				else
					estado_sig <= estado_act;
					cuenta_sig <= cuenta_act + "0001";
				end if;
				
			when led =>
				if switch = '1' then
					estado_sig <= espera;
					cuenta_sig <= cuenta_act;
				else
					estado_sig <= estado_act;
					cuenta_sig <= cuenta_act;
				end if;
		end case;
	
	end process cambioEstado;
	
	salida: process (estado_act, cuenta_act)
	begin
	
		case estado_act is
			when espera => luces <= "00000";
			when ilumina => luces <= "10000";
			when cuenta => luces <= "00000";
			when led => luces <= '0' & cuenta_act;
		end case;
	
	end process salida;
				
end Behavioral;

