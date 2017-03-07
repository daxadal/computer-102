
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity contador is
	port (rst, clk_100MHz, count: in std_logic;
			SC: out std_logic_vector(3 downto 0));
end contador;

architecture Behavioral of contador is
	component sumador is
		port (A, B: in std_logic_vector(3 downto 0);
				C: out std_logic_vector(3 downto 0));
	end component;
	
	component reg_paralelo is
		port (rst, clk_100MHz, load: in std_logic;
				EP: in std_logic_vector(3 downto 0);
				SP: out std_logic_vector(3 downto 0));
	end component;
	
	signal RegToSum, SumToReg: std_logic_vector(3 downto 0);
	
begin
	sum: sumador port map (RegToSum, "0001", SumToReg);
	reg: reg_paralelo port map (rst, clk_100MHz, count, SumToReg, RegToSum);
	Sc <= RegToSum;

end Behavioral;

