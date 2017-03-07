
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uaa_2super is
	port (
		cin: in std_logic;
		p, g: in std_logic_vector (3 downto 0);
		cout: out std_logic_vector (4 downto 1)
	);
end uaa_2super;

architecture Behavioral of uaa_2super is

begin

	cout(1) <= g(0) or ( p(0) and cin);
	cout(2) <= g(1) or ( p(1) and g(0) ) or ( p(1) and p(0) and cin );
	cout(3) <= g(2) or ( p(2) and g(1) ) or ( p(2) and p(1) and g(0) ) 
					or ( p(2) and p(1) and p(0) and cin );
	cout(4) <= g(3) or ( p(3) and g(2) ) or ( p(3) and p(2) and g(1) ) 
					or ( p(3) and p(2) and p(1) and g(0) ) or ( p(3) and p(2) and p(1) and p(0) and cin );

end Behavioral;
