
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pintaLaberinto is
	generic (
		DATA_WIDE : integer := 2
	);
	port(
		clock: in std_logic;
		libre: in std_logic_vector (1 downto 0);
		x_vga, y_vga: in std_logic_vector (8 downto 0);
		x_mem, y_mem: out std_logic_vector (8 downto 0);
		pintar: out std_logic_vector(1 downto 0)
	);

end pintaLaberinto;

architecture Behavioral of pintaLaberinto is
	-- ROM que almacena la imagen de la copa
	component rom_meta is
		generic (
			ADDRESS_WIDE : integer := 8;
			DATA_WIDE : integer := 2
		);
		port(
			clk1: in std_logic; -- Clock 
			we1 : in std_logic; -- Write enable
			input1 : in std_logic_vector(DATA_WIDE - 1 downto 0); -- Datos de entrada(DATA_WIDE - 1 downto 0)
			addr1 : in std_logic_vector(ADDRESS_WIDE - 1 downto 0); -- Dirección de entrada
			salida1 : out std_logic_vector(DATA_WIDE - 1 downto 0) -- Salida de la ROM
		);
	end component;

	signal salida_rom : std_logic_vector(1 downto 0); -- Salida de la ROM
	signal addr_rom : std_logic_vector(7 downto 0); -- Dirección de memoria de la ROM

begin
	
	rom: rom_meta port map(
		clk1 => clock,
		we1 => '0',
		input1 => "00", --(DATA_WIDE - 1 downto 0)
		addr1 => addr_rom,
		salida1 => salida_rom
	);
	
	addr_rom <= y_vga(3 downto 0) & x_vga(3 downto 0); -- Conversión entre el cuadrado del tablero y la dirección de memoria de la ROM
	x_mem <= x_vga;
	y_mem <= y_vga;
	
	with libre select
		pintar <= "01" when "01", --pared
					salida_rom  when "10", --meta
					"00" when others;
					
	
end Behavioral;

