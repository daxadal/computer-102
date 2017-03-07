
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity PintaVidas is
	port(
		clock: in std_logic;
		x_vga, y_vga: in std_logic_vector (8 downto 0);
		vidas: in std_logic_vector (1 downto 0);
		pintar: out std_logic
	);
end PintaVidas;

architecture Behavioral of PintaVidas is
begin
	
	PintaVid: process (clock, x_vga, y_vga, vidas)
	begin
		if ( ( 4 < x_vga(3 downto 0) and x_vga(3 downto 0) < 12 and -- Si estamos en la esquina superior izquierda pintamos
				4 < y_vga and y_vga < 12 )
				and 
				(
					( x_vga (8 downto 4) < 1 and vidas = "01" )
					or
					( x_vga (8 downto 4) < 2 and vidas = "10" )
					or
					( x_vga (8 downto 4) < 3 and vidas = "11" )
				)
			)
				then 

				pintar <= '1';
			else
				pintar <= '0';
		end if;
		
	end process;

end Behavioral;

