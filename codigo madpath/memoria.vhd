
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memoria is
	generic (
		DATA_WIDE : integer := 2
	);
	port (
		clk_asm, clk_vga, reset: in std_logic; -- clk_asm el del asm, clk_vga mas rapido (o igual) que el de la pantalla 
		x_asm, y_asm, x_vga, y_vga: in std_logic_vector(8 downto 0); --Coordenadas a preguntar

		nivel: in std_logic_vector(2 downto 0); -- Entrada que indica el nivel al que cambiar (ya decodificado 321)
		cambia_nivel: in std_logic; -- Entrada que indica si hay que cambiar de nivel
		
		libre_asm, libre_vga: out std_logic_vector(DATA_WIDE-1 downto 0);
		x_bola, y_bola: out std_logic_vector(8 downto 0) --Donde esta la bola
	);
end memoria;

architecture Behavioral of memoria is
	-- Las 4 ROMs son idénticas
	component nivel0 is
		generic (
			ADDRESS_WIDE : integer := 10;
			DATA_WIDE : integer := 2
	);
	port(
		clk1, clk2, reset : in std_logic;
		en: in std_logic; -- Selector de nivel
		we1, we2 : in std_logic; -- Writes enables
		input1, input2 : in std_logic_vector(1 downto 0); -- Datos de entrada(DATA_WIDE - 1 downto 0)
		addr1, addr2 : in std_logic_vector(ADDRESS_WIDE - 1 downto 0); -- Direcciones de entrada
		salida1, salida2 : out std_logic_vector(DATA_WIDE - 1 downto 0) -- Salidas
	);
	end component;

	component nivel1 is
		generic (
			ADDRESS_WIDE : integer := 10;
			DATA_WIDE : integer := 2
		);
		port(
			clk1, clk2, reset : in std_logic;
			en: in std_logic; 
			we1, we2 : in std_logic;
			input1, input2 : in std_logic_vector(DATA_WIDE - 1 downto 0);
			addr1, addr2 : in std_logic_vector(ADDRESS_WIDE - 1 downto 0);
			salida1, salida2 : out std_logic_vector(DATA_WIDE - 1 downto 0)
		);
	end component nivel1;
	
	component nivel2 is
	generic (
		ADDRESS_WIDE : integer := 10;
		DATA_WIDE : integer := 2
	);
	port(
		clk1, clk2, reset : in std_logic;
		en: in std_logic; 
		we1, we2 : in std_logic;
		input1, input2 : in std_logic_vector(DATA_WIDE - 1 downto 0);
		addr1, addr2 : in std_logic_vector(ADDRESS_WIDE - 1 downto 0);
		salida1, salida2 : out std_logic_vector(DATA_WIDE - 1 downto 0)
	);
	end component nivel2;
	
	component nivel3 is
	generic (
		ADDRESS_WIDE : integer := 10;
		DATA_WIDE : integer := 2
	);
	port(
		clk1, clk2, reset : in std_logic;
		en: in std_logic; 
		we1, we2 : in std_logic;
		input1, input2 : in std_logic_vector(DATA_WIDE - 1 downto 0);
		addr1, addr2 : in std_logic_vector(ADDRESS_WIDE - 1 downto 0);
		salida1, salida2 : out std_logic_vector(DATA_WIDE - 1 downto 0)
	);
	end component nivel3;
	
	signal nivel_actual: std_logic_vector(2 downto 0); -- Señal de nivel actual 
	signal libre_asm_nivel0, libre_vga_nivel0: std_logic_vector(DATA_WIDE-1 downto 0); -- Señales de libre para el nivel 0 
	signal lvl_0: std_logic; -- Señal que indica si estamos en el nivel 0
	signal addr1, addr2: std_logic_vector(9 downto 0); -- Direcciones de entrada a las ROMs
	
	-- Posiciones iniciales de las bolas y señales que indican si una determinada posición está o no libre en los 3 niveles
	constant x_bola_nivel1: std_logic_vector(8 downto 0) := "000011000";
	constant y_bola_nivel1: std_logic_vector(8 downto 0) := "100101000";
	signal libre_asm_nivel1, libre_vga_nivel1: std_logic_vector(DATA_WIDE-1 downto 0);
	
	
	
	constant x_bola_nivel2: std_logic_vector(8 downto 0) := "000011000";
	constant y_bola_nivel2: std_logic_vector(8 downto 0) := "100101000";
	signal libre_asm_nivel2, libre_vga_nivel2: std_logic_vector(DATA_WIDE-1 downto 0);
	
	constant x_bola_nivel3: std_logic_vector(8 downto 0) := "000011000";
	constant y_bola_nivel3: std_logic_vector(8 downto 0) := "100101000";
	signal libre_asm_nivel3, libre_vga_nivel3: std_logic_vector(DATA_WIDE-1 downto 0);
	
begin

	--Cambio de nivel
	sincrono: process (clk_vga, reset)
	begin	
		if reset = '1' then
			nivel_actual <= "000";
		elsif clk_vga'event and clk_vga = '1' and cambia_nivel = '1' then
			nivel_actual <= nivel;
		end if;
	end process;
	
	addr1 <= y_asm (8 downto 4) & x_asm (8 downto 4);
	addr2 <= y_vga (8 downto 4) & x_vga (8 downto 4);
	with nivel_actual select 
		lvl_0 <= '1' when "000",
					'0' when others;
	
	--Rom del nivel 0
	level0: nivel0 port map(
		clk1 => clk_asm, 
		clk2 => clk_vga, 
		reset => reset,
		en => lvl_0, -- Enable si estamos en el nivel 0
		we1 => '0',
		we2 =>'0',
		input1 =>"00",
		input2 =>"00",
		
		addr1 => addr1, 
		addr2 => addr2,
		salida1 =>libre_asm_nivel0, 
		salida2 =>libre_vga_nivel0		
	);
	
	--Rom del nivel 1
	level1: nivel1 

		port map(
		clk1 => clk_asm, 
		clk2 => clk_vga, 
		reset => reset,
		en => nivel_actual(0), --Nivel 001
		we1 => '0',
		we2 =>'0',
		input1 =>"00",
		input2 =>"00",
		
		addr1 => addr1, 
		addr2 => addr2,
		salida1 =>libre_asm_nivel1, 
		salida2 =>libre_vga_nivel1		
	);
	
	--Rom del nivel 2
		level2: nivel2 port map(
		clk1 => clk_asm, 
		clk2 => clk_vga, 
		reset => reset,
		en => nivel_actual(1), --Nivel 010
		we1 => '0',
		we2 =>'0',
		input1 =>"00",
		input2 =>"00",
		
		addr1 => addr1, 
		addr2 => addr2,
		salida1 =>libre_asm_nivel2, 
		salida2 =>libre_vga_nivel2		
	);
	
	
	level3: nivel3 port map(
		clk1 => clk_asm, 
		clk2 => clk_vga, 
		reset => reset,
		en => nivel_actual(2), --Nivel 100
		we1 => '0',
		we2 =>'0',
		input1 =>"00",
		input2 =>"00",
		
		addr1 => addr1, 
		addr2 => addr2,
		salida1 =>libre_asm_nivel3, 
		salida2 =>libre_vga_nivel3		
	);
	
	--Salida de la posicion inicial de la bola
	with nivel_actual select
		x_bola <= x_bola_nivel1 when "001",
					 x_bola_nivel2 when "010",
					 x_bola_nivel3 when "100",
						(others => '0') when others;
		
	with nivel_actual select
		y_bola <= y_bola_nivel1 when "001",
					 y_bola_nivel2 when "010",
					 y_bola_nivel3 when "100",
						(others => '0') when others;
	
	-- Salida de la señal libre
	libre_asm <= (libre_asm_nivel0) or libre_asm_nivel1 or libre_asm_nivel2 or libre_asm_nivel3;
	libre_vga <= (libre_vga_nivel0) or libre_vga_nivel1 or libre_vga_nivel2 or libre_vga_nivel3;

end Behavioral;

