
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity conv_7seg is
    Port ( x : in  STD_LOGIC_VECTOR (3 downto 0);
           display_o : out  STD_LOGIC_VECTOR (6 downto 0));
end conv_7seg;

architecture Behavioral of conv_7seg is

signal display : STD_LOGIC_VECTOR (6 downto 0);

begin

-- Si el display 7 segmentos es activo a alta
-- display_o <= not(display);

-- Si el display 7 segmentos es activo a baja
display_o <= display;

with x select
	display<= "0000110" when "0001",
	      	"1011011" when "0010",
	      	"1001111" when "0011",
	      	"1100110" when "0100",
	      	"1101101" when "0101",
	      	"1111101" when "0110",
	      	"0000111" when "0111",
	      	"1111111" when "1000",
	      	"1101111" when "1001",
	      	"1110111" when "1010",
	      	"1111100" when "1011",
	      	"0111001" when "1100",
	      	"1011110" when "1101",
	      	"1111001" when "1110",
	      	"1110001" when "1111",
	      	"0111111" when others;

end Behavioral;

