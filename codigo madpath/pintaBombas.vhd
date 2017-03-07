
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity pintaBombas is
	port(
		clock: in std_logic;
		x_vga, y_vga: in std_logic_vector (8 downto 0);
		fila, col: out std_logic_vector (8 downto 0);
		pos_en_fila, pos_en_col: in std_logic_vector (8 downto 0);
		nivel: in std_logic_vector(2 downto 0);
		pintar: out std_logic
	);
end pintaBombas;

architecture Behavioral of pintaBombas is

begin
	
	-- La fila y la columna son las posiciones x e y que pregunta la vga
	fila <= y_vga;
	col <= x_vga;
	
	PintaBomba: process(clock, y_vga, nivel, x_vga, pos_en_fila, pos_en_col)
	begin
		if (
				pos_en_fila /= "000000000" and nivel /= "000" and --Si en la fila hay bomba
				 (x_vga < (pos_en_fila + 4)) and (pos_en_fila < (x_vga + 4)) -- y la columna está cerca de la posicion en columna de la bomba
			) or (
				pos_en_col /= "000000000" and nivel /= "000" and --Si en la columna hay bomba
				 (y_vga < (pos_en_col + 4)) and (pos_en_col < (y_vga + 4)) -- y la fila está cerca de la posicion en fila de la bomba
			)
		then 
			pintar <= '1';
		else
			pintar <= '0';
		end if;
		


	end process;
	
	
end Behavioral;

