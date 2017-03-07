
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder is
	generic(N : natural := 32);
	port(
		cin: in std_logic;
		op1 : in std_logic_vector(N-1 downto 0);
		op2 : in std_logic_vector(N-1 downto 0);
		add: out std_logic_vector(N downto 0)
	);
end adder;

architecture simple of adder is
	signal op1_aux, op2_aux,cin_aux: std_logic_vector(N downto 0);
begin

	cin_aux(N downto 1) <= (others=>'0');
	cin_aux(0)<= cin;
	op1_aux <= '0'&op1 + cin_aux;
	op2_aux <= '0'&op2;
	add <= op1_aux + op2_aux;
	
end simple;


