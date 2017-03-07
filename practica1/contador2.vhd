
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador2 is
	port (rst, clk_100MHz, count: in std_logic;
			SC: out std_logic_vector(3 downto 0));
end contador2;

architecture Behavioral of contador2 is
	component contador is
		port (rst, clk_100MHz, count: in std_logic;
			SC: out std_logic_vector(3 downto 0));
	end component;
	
	signal SAux: std_logic_vector(3 downto 0);
	
begin
	cont: contador port map (rst, clk_100MHz, count, SAux);
	SC <= SAux(2 downto 0) & '0';

end Behavioral;

