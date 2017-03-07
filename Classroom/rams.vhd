
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rams is
	port (
		clk : in std_logic;
		we : in std_logic;
		addr : in std_logic_vector(5 downto 0);
		di : in std_logic_vector(3 downto 0);
		do : out std_logic_vector(3 downto 0)
);
end rams;

architecture circuito of rams is
	type ram_type is array (0 to 63) of std_logic_vector (3 downto 0);
	signal RAM : ram_type:= (
		X"1", X"2", X"3", X"4", X"5", X"6", X"7", X"8", X"9", X"A", X"A", X"A", X"A",
		X"1", X"2", X"3", X"4", X"5", X"6", X"7", X"8", X"9", X"A", X"A", X"A", X"A",
		X"1", X"2", X"3", X"4", X"5", X"6", X"7", X"8", X"9", X"A", X"A", X"A", X"A",
		X"1", X"2", X"3", X"4", X"5", X"6", X"7", X"8", X"9", X"A", X"A", X"A", X"A",
		
		X"0", X"0", X"0", X"0", X"0", X"0", X"0", X"0", X"0", X"0", X"0", X"0" 
	);
begin
	puerto: process (clk)
	begin
	
		if rising_edge(clk) then
			if we = '1' then
				RAM(conv_integer(addr)) <= di;
			end if;
			do <= RAM(conv_integer(addr));
		end if;
		
	end process puerto;
end circuito;

