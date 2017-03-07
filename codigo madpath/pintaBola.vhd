
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity pintaBola is
	port(
		clock: in std_logic;
		x, y: in std_logic_vector (8 downto 0); -- Posición a pintar
		x_bola, y_bola: in std_logic_vector (8 downto 0); -- Posición donde está la bola
		pintar: out std_logic -- Devuelve si se se tiene que pintar
	);

end pintaBola;

architecture Behavioral of pintaBola is

begin

PintaBola: process(clock, x, y, x_bola, y_bola)
	begin
		-- Pintar una bola de tamaño 9x9 centrada en (x_bola,y_bola)
		if (x < (x_bola + 4)) and (x_bola < (x + 4))  -- (-4 < x - x_bola < 4)
		and (y < (y_bola + 4)) and (y_bola < (y + 4)) then	-- (-4 < y - y_bola < 4)
			pintar <= '1';
		else
			pintar <= '0';
		end if;

	end process;




end Behavioral;

