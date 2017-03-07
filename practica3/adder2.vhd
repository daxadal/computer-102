
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder2 is
	generic(N : natural := 32);
	port(
		cin: in std_logic;
		op1 : in std_logic_vector(N-1 downto 0);
		op2 : in std_logic_vector(N-1 downto 0);
		add: out std_logic_vector(N downto 0)
	);
end adder2;

architecture uaa_2niveles of adder2 is

	component adder_16bits is
		port(
			cin: in std_logic;
			op1 : in std_logic_vector(15 downto 0);
			op2 : in std_logic_vector(15 downto 0);
			add: out std_logic_vector(15 downto 0);
			cout: out std_logic
		);
	end component adder_16bits;

	signal carry: std_logic_vector(N/16 downto 0);
begin

	gen: for i in 0 to (N-1)/16 generate
		FA16b_i: adder_16bits port map(
			carry(i),
			op1(16*i+15 downto 16*i),
			op2(16*i+15 downto 16*i),
			add(16*i+15 downto 16*i), 
			carry(i+1)
		);
	end generate gen;
	
	carry(0) <= cin;
	add(N) <= carry(N/16);
	
end uaa_2niveles;