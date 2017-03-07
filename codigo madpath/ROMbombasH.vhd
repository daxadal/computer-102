
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
-- ROM de las bombas horizontales y verticales
entity ROMbombas is
	generic (
		ADDRESS_WIDE : integer := 5;
		DATA_WIDE : integer := 9
	);
	port(
	-- ROM de dos entradas y dos salidas
		clk1, clk2, reset : in std_logic;
		en: in std_logic;
		we1, we2 : in std_logic;
		input1, input2 : in std_logic_vector(DATA_WIDE - 1 downto 0); 
		addr1, addr2 : in std_logic_vector(ADDRESS_WIDE - 1 downto 0);
		salida1, salida2 : out std_logic_vector(DATA_WIDE - 1 downto 0)
	);
end ROMbombas;

architecture Behavioral of ROMbombas is
	subtype posicion is std_logic_vector(DATA_WIDE - 1 downto 0);
	type TMemory is array (0 to 2** ADDRESS_WIDE - 1) of posicion;
	shared variable memory : TMemory := ( others => (others => '0'));
	
begin

	process (clk1)
	begin

		if clk1'event and clk1 = '1' then
			if en = '1' then
				if we1 = '1' then
					memory(conv_integer(addr1)) := input1; 
				end if;
				salida1 <= memory(conv_integer(addr1));
			else 
				salida1 <= (others => '0');
			end if;
		end if;
	end process;	


	process (clk2)
	begin

		if clk2'event and clk2 = '1' then
			if en = '1' then
				if we2 = '1' then
					memory(conv_integer(addr2)) := input2; 
				end if;
				salida2 <= memory(conv_integer(addr2));
			else 
				salida2 <= (others => '0');
			end if;
		end if;
	end process;	
											
end Behavioral;