
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram is
	port (
		clk, ena, wea: in std_logic;
		addra: in std_logic_vector (6 downto 0);
		dina: in std_logic_vector (3 downto 0);
		douta: out std_logic_vector (3 downto 0)
	);
end ram;

architecture archxi of ram is
	subtype ram_word is std_logic_vector(3 downto 0);
	type ram_table is array (0 to 127) of ram_word;
	signal rammemory: ram_table := (others => (others => '0'));
begin

	process(clk, wea)
	begin
	
		if clk'event and clk='1' then
			if ena = '1' then
				if wea = '1' then 
					rammemory(conv_integer(addra))<=dina;
				end if;
				douta <= rammemory(conv_integer(addra));
			end if;
		end if;
	
	end process;
	
end archxi;

