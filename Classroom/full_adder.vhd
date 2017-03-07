
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity full_adder is
	port (
		a, b, c: in std_logic;
		s, p, g: out std_logic
	);
end full_adder;

architecture Behavioral of full_adder is
begin

	g <= a and b;
	p <= a xor b;
	s <= c xor (a xor b);

end Behavioral;



