
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder_128bits is
	generic(N : natural := 128);
	port(
		cin: in std_logic;
		op1 : in std_logic_vector(N-1 downto 0);
		op2 : in std_logic_vector(N-1 downto 0);
		add: out std_logic_vector(N downto 0)
	);
end adder_128bits;

architecture Behavioral of adder_128bits is
	component adder_64bits is
		generic(N : natural := 64);
		port(
			cin: in std_logic;
			op1 : in std_logic_vector(N-1 downto 0);
			op2 : in std_logic_vector(N-1 downto 0);
			add: out std_logic_vector(N-1 downto 0);
			cout: out std_logic
		);
	end component adder_64bits;
	
	signal cmid, cout: std_logic;
	signal op1in : std_logic_vector(N-1 downto 0);
	signal op2in : std_logic_vector(N-1 downto 0);
	signal addout: std_logic_vector(127 downto 0);
	
begin
	
	adder1: adder_64bits generic map (N/2)
	port map (
		cin, 
		op1in(63 downto 0),
		op2in(63 downto 0),
		addout(63 downto 0),
		cmid
	);
	
	adder2: adder_64bits generic map (N/2)
	port map (
		cmid, 
		op1in(127 downto 64),
		op2in(127 downto 64),
		addout(127 downto 64),
		cout
	);
	
	add <= cout & addout;
	op1in <= op1;
	op2in <= op2;

end Behavioral;

