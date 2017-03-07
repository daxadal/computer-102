-- Comentarios en entity nivel0
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity nivel1 is
	generic (
		ADDRESS_WIDE : integer := 10;
		DATA_WIDE : integer := 2
	);
	port(
		clk1, clk2, reset : in std_logic;
		en: in std_logic;
		we1, we2 : in std_logic;
		input1, input2 : in std_logic_vector(1 downto 0); --(DATA_WIDE - 1 downto 0)
		addr1, addr2 : in std_logic_vector(ADDRESS_WIDE - 1 downto 0);
		salida1, salida2 : out std_logic_vector(DATA_WIDE - 1 downto 0)
	);
end nivel1;

architecture Behavioral of nivel1 is
	type objetos is (iii,MMM, met);
	type TMemory is array (0 to 2** ADDRESS_WIDE - 1) of objetos;
	
	signal salida_aux1, salida_aux2: objetos;
	signal entrada_aux1, entrada_aux2: objetos;
	

	shared variable memory : TMemory := 
	( 
		MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,	MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,MMM,MMM,MMM,MMM,MMM,iii,iii,iii,MMM,iii,iii,iii,MMM,MMM,MMM,MMM,MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,MMM,MMM,MMM,MMM,iii,MMM,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,MMM,iii,iii,MMM,MMM,MMM,MMM,MMM,iii,iii,iii,iii,iii,MMM,iii,iii,MMM,iii,iii,MMM,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,iii,iii,iii,MMM,iii,iii,iii,iii,iii,MMM,iii,iii,MMM,iii,MMM,MMM,MMM,MMM,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,MMM,iii,iii,iii,iii,MMM,iii,iii,iii,MMM,MMM,MMM,iii,MMM,MMM,MMM,iii,iii,MMM,iii,iii,iii,MMM,MMM,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,MMM,iii,MMM,iii,iii,iii,iii,iii,MMM,iii,MMM,iii,iii,iii,iii,MMM,iii,iii,iii,MMM,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,MMM,MMM,MMM,MMM,MMM,iii,MMM,iii,iii,iii,MMM,iii,MMM,iii,MMM,iii,iii,iii,iii,MMM,iii,iii,iii,MMM,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,MMM,iii,iii,iii,iii,MMM,iii,iii,iii,MMM,iii,MMM,iii,MMM,iii,iii,iii,iii,MMM,MMM,MMM,MMM,MMM,MMM,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,MMM,iii,iii,iii,iii,MMM,iii,iii,iii,MMM,iii,iii,iii,MMM,iii,iii,iii,iii,MMM,iii,iii,iii,iii,MMM,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,MMM,iii,iii,iii,iii,MMM,iii,iii,iii,MMM,iii,MMM,iii,MMM,iii,iii,MMM,MMM,MMM,iii,iii,iii,iii,MMM,iii,iii,MMM,   MMM,MMM,
		MMM,MMM,iii,MMM,MMM,MMM,iii,MMM,MMM,iii,iii,iii,MMM,iii,MMM,iii,MMM,iii,iii,MMM,iii,iii,iii,iii,iii,iii,MMM,iii,iii,MMM,   MMM,MMM,
		MMM,MMM,iii,iii,iii,MMM,iii,MMM,iii,iii,iii,iii,MMM,iii,MMM,iii,MMM,iii,iii,MMM,iii,iii,iii,iii,MMM,MMM,MMM,iii,MMM,MMM,   MMM,MMM,
		MMM,MMM,iii,MMM,iii,MMM,iii,MMM,iii,MMM,MMM,MMM,MMM,iii,MMM,iii,MMM,MMM,MMM,MMM,iii,iii,iii,iii,MMM,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,MMM,iii,MMM,iii,MMM,iii,MMM,iii,iii,MMM,iii,iii,iii,iii,iii,MMM,MMM,iii,iii,iii,iii,iii,iii,MMM,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,MMM,MMM,MMM,iii,MMM,iii,MMM,MMM,iii,MMM,iii,iii,iii,iii,iii,MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,MMM,iii,iii,iii,iii,MMM,iii,iii,iii,iii,iii,MMM,met,iii,iii,iii,MMM,MMM,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,MMM,   MMM,MMM,
		
		
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM,
		MMM,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,iii,MMM,   MMM,MMM
	);

begin

	process (clk1)
	begin

		if clk1'event and clk1 = '1' then
			if en = '1' then	--Implementación del enable
				if we1 = '1' then
					memory(conv_integer(addr1)) := entrada_aux1;
				end if;
				salida_aux1 <= memory(conv_integer(addr1));
			else 
				salida_aux1 <= iii;
			end if;
		end if;
	end process;

	process (clk2)
	begin
		if clk2'event and clk2 = '1' then
			if en = '1' then	--Implementación del enable
				if we2 = '1' then
					memory(conv_integer(addr2)) := entrada_aux2;
				end if;
				salida_aux2 <= memory(conv_integer(addr2));
			else 
				salida_aux2 <= iii;
			end if;
		end if;
	end process;
	
	with salida_aux1 select
		salida1 <= "00" when iii,
						"10" when met,
						"01" when others;	
						
	with salida_aux2 select
		salida2 <= "00" when iii,
						"10" when met,
						"01" when others;	
						
	with input1 select
		entrada_aux1 <= iii when "00",
						MMM when others;	
						
	with input2 select
		entrada_aux2 <= iii when "00",
						MMM when others;					
											
end Behavioral;