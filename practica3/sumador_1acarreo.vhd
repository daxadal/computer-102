
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder1 is
	generic(N : natural := 32);
	port(
		cin: in std_logic;
		op1 : in std_logic_vector(N-1 downto 0);
		op2 : in std_logic_vector(N-1 downto 0);
		add: out std_logic_vector(N downto 0)
	);
end adder1;

architecture uaa_1nivel of adder1 is
	component full_adder is
		port (
			a, b, c: in std_logic;
			s, p, g: out std_logic
		);
	end component full_adder;
	
	component uaa is
		port (
			cin: in std_logic;
			p, g: in std_logic_vector (3 downto 0);
			cout: out std_logic_vector (4 downto 1)
		);
	end component uaa;

	signal carry: std_logic_vector (N downto 0);
	signal p, g, add_out: std_logic_vector (N-1 downto 0);
begin
	
	gen_adder: for i in 0 to N-1 generate
		cell_i: full_adder port map (
			op1(i), op2(i), carry(i),
			add_out(i), p(i), g(i)
		);	
	end generate gen_adder;
	
	gen_uaa: for i in 0 to (N-1)/4 generate
		uaa_i: uaa port map (
			carry(4*i),
			p(4*i+3 downto 4*i), g(4*i+3 downto 4*i),
			carry(4*i+4 downto 4*i+1)
		);
	end generate gen_uaa;
	
	carry(0) <= cin;
	add<= carry(N) & add_out;
	
end uaa_1nivel;
