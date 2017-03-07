
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder_16bits is
	port(
		cin: in std_logic;
		op1 : in std_logic_vector(15 downto 0);
		op2 : in std_logic_vector(15 downto 0);
		add: out std_logic_vector(15 downto 0);
		cout: out std_logic
	);
end adder_16bits;

architecture uaa_2niveles of adder_16bits is
	component full_adder is
		port (
			a, b, c: in std_logic;
			s, p, g: out std_logic
		);
	end component full_adder;
	
	component uaa_2 is
		port (
			cin: in std_logic;
			p, g: in std_logic_vector (3 downto 0);
			cout: out std_logic_vector (3 downto 1);
			Pout, Gout: out std_logic
		);
	end component uaa_2;
	
	component uaa_2super is
		port (
			cin: in std_logic;
			p, g: in std_logic_vector (3 downto 0);
			cout: out std_logic_vector (4 downto 1)
		);
	end component uaa_2super;

	signal carry: std_logic_vector (16 downto 0);
	signal carry_super: std_logic_vector (4 downto 0);
	signal p, g, add_out: std_logic_vector (15 downto 0);
	signal Pout, Gout: std_logic_vector (3 downto 0);
	
begin
	
	gen_adder: for i in 0 to 15 generate
		cell_i: full_adder port map (
			op1(i), op2(i), carry(i),
			add_out(i), p(i), g(i)
		);	
	end generate gen_adder;
	
	gen_uaa: for i in 0 to 3 generate
		uaa_i: uaa_2 port map (
			carry(4*i),
			p(4*i+3 downto 4*i), g(4*i+3 downto 4*i),
			carry(4*i+3 downto 4*i+1),
			Pout(i), Gout(i)
		);
	end generate gen_uaa;
	
	uaa_super: uaa_2super port map (
		carry_super(0),
		Pout, Gout,
		carry_super(4 downto 1)
	);
	
	carry(0) <= cin;
	
	carry_super(0) <= carry(0);
	carry(4) <= carry_super(1);
	carry(8) <= carry_super(2);
	carry(12) <= carry_super(3);
	carry(16) <= carry_super(4);
	
	add <= add_out;
	cout <= carry(16);
	
end uaa_2niveles;

