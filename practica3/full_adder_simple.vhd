
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity full_adder_simple is
	port (
		a, b, cin: in std_logic;
		s, cout: out std_logic
	);
end full_adder_simple;

architecture Behavioral of full_adder_simple is
begin

	s <= cin xor (a xor b);
	cout <= (a and b) or (a and cin) or (b and cin);

end Behavioral;

