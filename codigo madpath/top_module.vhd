-- Proyecto Madpath
-- Tecnología y Organización de Computadores
-- 3º Doble Grado en Ingenería Informática y Matemáticas
-- Eric García de Ceca Elejoste
-- María Magdalena Moyano de la Cruz
-- Alberto Terceño Ortega

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

	

entity top_module is
	port(
		--Reset y clock
		reset: in std_logic;
		clk_in: in std_logic;
		--Teclado
		PS2DATA: in std_logic;
		PS2CLK : in std_logic;
   	--Pantalla
   	hsyncb: out std_logic;    -- horizontal (line) sync
   	vsyncb: out std_logic;    -- vertical (frame) sync
   	rgb: out std_logic_vector(8 downto 0) -- red,green,blue colors
	);
end top_module;

architecture Behavioral of top_module is

	component vgacore is
		generic (
			DATA_WIDE : integer := 2
		);
		 port
		 (
			 reset: in std_logic;    -- reset
			 clock: in std_logic;
			 hsyncb: out std_logic;    -- horizontal (line) sync
			 vsyncb: out std_logic;    -- vertical (frame) sync
			 rgb: out std_logic_vector(8 downto 0); -- red,green,blue colors
			 x_bola: in std_logic_vector (8 downto 0); -- Posición de la bola
			 y_bola: in std_logic_vector (8 downto 0);
			 x_mem: out std_logic_vector (8 downto 0); -- Posición a preguntar en memoria
			 y_mem: out std_logic_vector (8 downto 0);
			 libre: in std_logic_vector (DATA_WIDE-1 downto 0); -- Posición libre?
			 
			fila, col: out std_logic_vector (8 downto 0); -- Fila y columna que se están leyendo
			pos_en_fila, pos_en_col: in std_logic_vector (8 downto 0); -- Existen bombas en la fila o la columna?
			nivel: in std_logic_vector(2 downto 0); -- Nivel actual
			vidas: in std_logic_vector (1 downto 0) -- Vidas actuales
		 );
	end component vgacore;

	component decodificadorTeclado is
		port(
			reset: in std_logic;
			PS2DATA: in std_logic;
			PS2CLK : in std_logic;
			salida : out std_logic_vector (6 downto 0) -- "Up-Down-Left-Right-Lv3-Lv2-Lv1"
		);
	end component decodificadorTeclado;
	
	component memoria is
		generic (
			DATA_WIDE : integer := 2
		);
		port (
			clk_asm, clk_vga, reset: in std_logic; -- clk_asm el del asm, clk_vga mas rapido (o igual) que el de la pantalla 
			x_asm, y_asm, x_vga, y_vga: in std_logic_vector(8 downto 0); --Coordenadas a preguntar

			nivel: in std_logic_vector(2 downto 0); -- Entrada que indica el nivel al que cambiar (ya decodificado 3-2-1)
			cambia_nivel: in std_logic; -- Entrada que indica si hay que cambiar de nivel
			
			libre_asm, libre_vga: out std_logic_vector(DATA_WIDE-1 downto 0); -- Señales de libre para el ASM y la vga
			x_bola, y_bola: out std_logic_vector(8 downto 0) --Donde esta la bola
		);
	end component memoria;
	
	component asm is
		generic (
			DATA_WIDE : integer := 2
		);
		port(
			reset, clk: in std_logic;
			direcciones: in std_logic_vector(6 downto 0); --Up-Down-Left-Right-3-2-1
			nivel_out: out std_logic_vector (2 downto 0); -- Nivel al que hay que cambiar cuando se solicita desde el teclado
			reinicia_nivel: out std_logic; -- Salida que decide si hay que volver a cargar el algún nivel (no tiene por qué ser el actual)
			libre: in std_logic_vector (DATA_WIDE-1 downto 0); -- Señal que nos indica si podemos mover a la posición que ha pedido el usuario
			muerte: in std_logic; -- Señal que indica si la bola ha tocado una bomba
			confirmarMuerte: out std_logic; -- Señal que confirma la muerte
			x, y : out std_logic_vector (8 downto 0); --Salida a la vga
			x_inicial, y_inicial : in std_logic_vector (8 downto 0); --Posicion inicial de la bola
			x_sig, y_sig : out std_logic_vector (8 downto 0); --Posicion siguiente de la bola
			vidas: out std_logic_vector (1 downto 0) -- Numero de vidas que disponemos
		);
	end component asm;
	
	component mod_bombas is
		port (
			-- Posicion de las bombas (x,y) codificado para las bombas:
					-- horizontales (fila, pos_en_fila)
					-- verticales (pos_en_col, col)
			reset, 
			clk_bomb, clk_ram: in std_logic; -- Clocks de las bombas y de los process
			nivel: in std_logic_vector (2 downto 0); -- Nivel actual
			fila, col: in std_logic_vector (4 downto 0); -- Fila de las bombas horizontales, columna de las bombas verticales
			pos_en_fila, pos_en_col: out std_logic_vector (8 downto 0); -- Columna de las bombas horizontales, fila de las bombas verticales
			
			x_bola_act, y_bola_act: in std_logic_vector (8 downto 0); -- Posicion actual de la bola en el tablero
			muerte : out std_logic; -- Señal de muerte que se envía al ASM
			confirmarMuerte: in std_logic -- Señal recibida del ASM que confirma la muerte
		);
	end component mod_bombas;
	
	
	--Señales
	constant DATA_WIDE: integer := 2;
	signal cont, cont_sig: std_logic_vector (21 downto 0); -- Señales del contador
	signal nivel_asm_mem_bom: std_logic_vector (2 downto 0); -- Nivel actual va del asm a la memoria y al módulo de bombas
	signal x_bola_inicial, y_bola_inicial: std_logic_vector(8 downto 0);
	signal x_mem_vga, y_mem_vga: std_logic_vector(8 downto 0); --De la vga salen los 8. A la mem los 5 más significcativos
	signal x_asm_vga_bom, y_asm_vga_bom: std_logic_vector(8 downto 0); -- posicuion actual. Va del asm a la vga y al módulo de bombas
	signal x_asm_mem, y_asm_mem: std_logic_vector(8 downto 0); -- posicuion actual. Va del asm a la memoria
	signal libre_mem_asm, libre_mem_vga: std_logic_vector (DATA_WIDE-1 downto 0); -- Señales entre la memoria, el ASM y la vga que indican si una posición dada está libre
	signal reinicia_nivel: std_logic; -- Señal de reinicia nivel del ASM
	signal direccionesTeclado: std_logic_vector(6 downto 0); -- Direcciones del teclado que salen del decodificador del teclado
	signal fila_bombas, col_bombas,  pos_en_fila, pos_en_col: std_logic_vector(8 downto 0); -- Filas y columnas que especifican donde están las bombas (si las hay)
	signal fila_corto, col_corto: std_logic_vector(4 downto 0); -- Filas y columnas con los bits recortados
	signal muerte, confirmarMuerte: std_logic; -- Señales de muerte y confirmarMuerte entre ASM y modBombas
	signal vidas:  std_logic_vector (1 downto 0); -- Señal de vidas

begin

	--Contador
	cont_sig <= cont + 1;
	
	--Process del contador
	registros: process(clk_in, reset)
	begin
		if reset = '1' then
			cont <= (others => '0');
		elsif clk_in'event and clk_in = '1' then
			cont <= cont_sig;
		end if;
	end process;
	
	--Recortamos los bits de las filas y las columnas
	fila_corto <= fila_bombas(8 downto 4);
	col_corto <= col_bombas(8 downto 4);

	--Componentes
	vga: vgacore port map(
		reset => reset, 
		clock => cont(0),
		hsyncb => hsyncb, 
		vsyncb => vsyncb, 
		rgb => rgb,
		x_bola => x_asm_vga_bom, 
		y_bola => y_asm_vga_bom, 
		x_mem => x_mem_vga,
		y_mem => y_mem_vga,
		libre => libre_mem_vga,
	
		fila => fila_bombas,
		col => col_bombas,
		pos_en_fila => pos_en_fila,
		pos_en_col => pos_en_col,
		nivel => nivel_asm_mem_bom,
		vidas => vidas
	);
	
	mem: memoria port map(
			clk_asm => cont(1),
			clk_vga => cont(1),
			reset => reset,
			
			x_asm => x_asm_mem, 
			y_asm => y_asm_mem, 
			x_vga => x_mem_vga, 
			y_vga => y_mem_vga,

			nivel => nivel_asm_mem_bom,
			cambia_nivel => reinicia_nivel,
			
			libre_asm => libre_mem_asm,
			libre_vga => libre_mem_vga,
			x_bola => x_bola_inicial,
			y_bola => y_bola_inicial
		);
		
	teclado: decodificadorTeclado port map(
			reset => reset,
			PS2DATA => PS2DATA,
			PS2CLK => PS2CLK,
			salida => direccionesTeclado
		);
		
	controlador: asm port map(
			reset => reset,
			clk => cont(17),
			direcciones => direccionesTeclado,
			nivel_out => nivel_asm_mem_bom,
			reinicia_nivel => reinicia_nivel,
			libre => libre_mem_asm,
			muerte => muerte,
			confirmarMuerte => confirmarMuerte,
			x => x_asm_vga_bom, 
			y => y_asm_vga_bom,
			x_inicial => x_bola_inicial, 
			y_inicial => y_bola_inicial,
			x_sig => x_asm_mem,
			y_sig => y_asm_mem,
			
			vidas => vidas
		);
		
	bombas: mod_bombas port map (
		reset => reset, 
		clk_bomb => cont(20),
		clk_ram => clk_in,
		nivel => nivel_asm_mem_bom,
		fila => fila_corto,
		col => col_corto,
		pos_en_fila => pos_en_fila,
		pos_en_col => pos_en_col,
		
		x_bola_act => x_asm_vga_bom,
		y_bola_act => y_asm_vga_bom,
		muerte => muerte,
		confirmarMuerte => confirmarMuerte
	);
	


end Behavioral;

