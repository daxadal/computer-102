
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity vgacore is
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
		 x_bola: in std_logic_vector (8 downto 0); 
		 y_bola: in std_logic_vector (8 downto 0);
		 x_mem: out std_logic_vector (8 downto 0);
		 y_mem: out std_logic_vector (8 downto 0);
		 libre: in std_logic_vector (DATA_WIDE-1 downto 0);
		 
		fila, col: out std_logic_vector (8 downto 0);
		pos_en_fila, pos_en_col: in std_logic_vector (8 downto 0);
		
		nivel: in std_logic_vector(2 downto 0);
		vidas: in std_logic_vector (1 downto 0)
    );
end vgacore;

architecture vgacore_arch of vgacore is

	signal pintarBola, pintarBombas, pintarVid: std_logic; -- Señales que salen de los componentes que deciden que objeto pintar
	signal pintarLab: std_logic_vector (1 downto 0); -- Señal que decide si pintar pared o meta
	signal x, y: std_logic_vector (8 downto 0); -- Posición de los píxeles que vamos a pintar en pantalla
	signal x_largo, y_largo: std_logic_vector (9 downto 0);
	signal video_on, p_tick:  std_logic; -- Señales requeridas por el controlador vga de la fpga
	signal pixel_x , pixel_y : std_logic_vector (9 downto 0); -- Píxeles de la pantalla

	component pintaLaberinto is
		generic (
			DATA_WIDE : integer := 2
		);
		port(
			clock: in std_logic;
			libre: in std_logic_vector (1 downto 0);
			x_vga, y_vga: in std_logic_vector (8 downto 0); -- Posición a pintar
			x_mem, y_mem: out std_logic_vector (8 downto 0); -- Posición a preguntar en memoria
			pintar: out std_logic_vector(1 downto 0) -- Devuelve si se se tiene que pintar
		);
	end component;

	component pintaBola is
		port(
			clock: in std_logic;
			x, y: in std_logic_vector (8 downto 0); -- Posición a pintar
			x_bola, y_bola: in std_logic_vector (8 downto 0); -- Posición donde está la bola
			pintar: out std_logic -- Devuelve si se se tiene que pintar
		);
	end component;
	
	component pintaBombas is
		port(
			clock: in std_logic;
			x_vga, y_vga: in std_logic_vector (8 downto 0); -- Posición a pintar
			fila, col: out std_logic_vector (8 downto 0); -- Fila y columna que vamos a pintar
			pos_en_fila, pos_en_col: in std_logic_vector (8 downto 0); -- Columna y fila determinadas donde podría haber bombas
			nivel: in std_logic_vector(2 downto 0); -- Nivel actual
			pintar: out std_logic -- Devuelve si se se tiene que pintar
		);
	end component pintaBombas;
	
	component controlador is 
	port (clk, reset: in std_logic;
			hsync , vsync : out std_logic ;
			video_on, p_tick: out std_logic;
			pixel_x , pixel_y : out std_logic_vector (9 downto 0)
	);
	end component;
	
	component PintaVidas is
		port(
			clock: in std_logic;
			x_vga, y_vga: in std_logic_vector (8 downto 0); -- Posición a pintar
			vidas: in std_logic_vector (1 downto 0); -- Numero de vidas actuales
			pintar: out std_logic -- Devuelve si se se tiene que pintar
		);
	end component PintaVidas;

begin
	
	-- Transformación del tamaño total de la pantalla a un recuadro 480*320 en el centro de la pantalla
	x_largo <= pixel_x-16;
	y_largo <= pixel_y-32;
	x <= x_largo (8 downto 0);
	y <= y_largo (8 downto 0);
	
	-- Instanciación de componentes
	pl: pintaLaberinto port map(
		clock => p_tick, 
		libre => libre,
		x_vga => x,
		y_vga => y,
		x_mem => x_mem,
		y_mem => y_mem,
		pintar => pintarLab	
	);
	
	pv: PintaVidas port map(
		clock => p_tick, 
		x_vga => x,
		y_vga => y,
		vidas => vidas,
		pintar => pintarVid	
	);
	
	pbl: pintaBola port map(
		clock => p_tick,
		x => x,
		y => y,
		x_bola => x_bola,
		y_bola => y_bola,
		pintar => pintarBola
	);
	
	pbb: pintaBombas port map (
		clock => p_tick, 
		x_vga => x,
		y_vga => y,
		fila => fila,
		col => col,
		pos_en_fila => pos_en_fila,
		pos_en_col => pos_en_col,
		nivel => nivel,
		pintar => pintarBombas
	);
	
	control: controlador port map(
		clk => clock, 
		reset => reset,
		hsync => hsyncb, 
		vsync => vsyncb,
		video_on => video_on, 
		p_tick => p_tick,
		pixel_x => pixel_x, 
		pixel_y => pixel_y
	);

	Pintar: process(pintarLab, pintarVid, pintarBola, pintarBombas, pixel_x, pixel_y, nivel)
	begin
	--Si está dentro de los límites del recuadro, entonces pintar
	if pixel_x>16 and pixel_x<496
			and pixel_y>32 and pixel_y<352 then 
				if (pintarVid = '1') then
					if (nivel = "100") then
						rgb <= "000111000";
					else
						rgb <= "000000111";
					end if;
				elsif (pintarBola = '1') then
					rgb <= "000111111";
				elsif (pintarBombas = '1') then
					rgb <= "111111000";
				elsif (pintarLab = "01" and nivel = "000") then -- Distinguimos si estamos en la pantalla de selección de nivel
					rgb <= "000111111";
				elsif (pintarLab = "10" and nivel = "000") then
					rgb <= "111101000";
				elsif (pintarLab = "01" and nivel /= "000") then
					if (nivel = "001") then
						rgb <= "111000000"; -- rojo
					elsif (nivel = "010") then
						rgb <= "111000111"; --magenta
					else 
						rgb <= "000000111";	-- azul
					end if;
				elsif (pintarLab = "10" and nivel /= "000") then
					if (nivel = "001") then
						rgb <= "111111111";	-- blanco 
					elsif (nivel = "010") then
						rgb <= "000111000";  -- verde
					else 
						rgb <= "000111000"; -- verde
					end if;
					
				
				else 
					rgb <= "000000000";
				end if;
	else
		rgb <= "000000000";
	end if;

	end process;

end vgacore_arch;
