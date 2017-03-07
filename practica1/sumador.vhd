library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sumador is
port (A, B: in std_logic_vector(3 downto 0);
		C: out std_logic_vector(3 downto 0));
end sumador;

architecture beh of sumador is
-- No hace falta definir señales intermedias
begin

C <= A + B;

end beh;



