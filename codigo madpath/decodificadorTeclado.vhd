
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity decodificadorTeclado is
	port(
		reset: in std_logic;
		PS2DATA: in std_logic;
		PS2CLK : in std_logic;
		salida : out std_logic_vector (6 downto 0) -- "Up-Down-Left-Right-Lv3-Lv2-Lv1"
	);
end decodificadorTeclado;

architecture Behavioral of decodificadorTeclado is
	signal registro: std_logic_vector (20 downto 0); -- Registro que guarda los bits que llegan del teclado
	signal salida_aux: std_logic_vector(6 downto 0); -- Salida multiplexada
begin

	process (PS2CLK, reset)
	begin
		if reset = '1' then
			registro <= (others => '0');	
		elsif PS2CLK'event and PS2CLK = '0' then
			registro <= registro (19 downto 0) & PS2DATA;
		end if;
	end process;	
	
	with registro(9 downto 2) select
	salida_aux <= "1000000" when "10111000", --up is W (1D) al reves
				 "0100000" when "11011000", --down is S (1B)al reves
				 "0010000" when "00111000", --left is A (1C)al reves
				 "0001000" when "11000100", --right is D (23) al reves
				 "0000001" when "01101000", --Lv1 is 1 (16) al reves
				 "0000010" when "01111000", --Lv2 is 2 (1E) al reves
				 "0000100" when "01100100", --Lv3 is 3 (26) al reves
				 "0000000" when others;
				 
	with registro(20 downto 13) select -- Lo sacamos por salida cuando hayamos dejado de pulsar la tecla (F0)
		salida <= salida_aux when "00001111",
				    "0000000" when others; 
		
		
end Behavioral;