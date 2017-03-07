
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity decodificadorTeclado is
	port(
		reset: in std_logic;
		PS2DATA: in std_logic;
		PS2CLK : in std_logic;
		salida : out std_logic_vector (5 downto 0); -- "Up-Down-Left-Right-Previous-Next"
		registroSal: out std_logic_vector (21 downto 0)
	);
end decodificadorTeclado;

architecture Behavioral of decodificadorTeclado is
	signal registro: std_logic_vector (21 downto 0);
begin

	process (PS2CLK, reset)
	begin
		if reset = '1' then
			registro <= (others => '0');	
		elsif PS2CLK'event and PS2CLK = '0' then
			registro <= registro (20 downto 0) & PS2DATA;
		end if;
	end process;
	
	with registro(9 downto 2) select
	salida <= "100000" when "10111000", --up is W (1D) al reves
				 "010000" when "11011000", --down is S (1B)al reves
				 "001000" when "00111000", --left is A (1C)al reves
				 "000100" when "11000100", --right is D (23)		al reves
				 "000010" when "10001100", --previous is N (31)al reves
				 "000001" when "01011100", --next is M (3A)	al reves
				 "000000" when others;

	registroSal <=registro;
end Behavioral;