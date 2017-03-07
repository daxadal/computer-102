
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adderIt is
	generic(N : natural := 32);
	port(
		cin: in std_logic;
		op1 : in std_logic_vector(N-1 downto 0);
		op2 : in std_logic_vector(N-1 downto 0);
		add: out std_logic_vector(N downto 0)
	);
end adderIt;

architecture Behavioral of adderIt is
	component full_adder_simple is
		port (
			a, b, cin: in std_logic;
			s, cout: out std_logic
		);
	end component full_adder_simple;
	
	signal carry: std_logic_vector(N downto 0);
begin

	gen: for i in 0 to N-1 generate
		cell_i: full_adder_simple port map (
			op1(i), op2(i), carry(i),
			add(i), carry(i+1)
		);
	end generate gen;
	
	carry(0) <= cin;
	add(N) <= carry(N);

end Behavioral;

