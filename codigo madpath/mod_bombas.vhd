
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity mod_bombas is
	port (
		-- Posicion de las bombas (x,y) codificado para las bombas:
				-- horizontales (fila, pos_en_fila)
				-- verticales (pos_en_col, col)
		reset, clk_bomb, clk_ram: in std_logic;
		nivel: in std_logic_vector (2 downto 0);
		fila, col: in std_logic_vector (4 downto 0); -- Fila de las bombas horizontales, columna de las bombas verticales
		pos_en_fila, pos_en_col: out std_logic_vector (8 downto 0); -- Columna de las bombas horizontales, fila de las bombas verticales
		
		x_bola_act, y_bola_act: in std_logic_vector (8 downto 0);
		muerte : out std_logic;
		confirmarMuerte: in std_logic
	);
end mod_bombas;

architecture Behavioral of mod_bombas is

	component bombas1 is
		port (
			-- Posicion de las bombas (x,y) codificado para las bombas:
				-- horizontales (fila, pos_en_fila)
				-- verticales (pos_en_col, col)
			reset, clk_bomb, clk_ram: in std_logic;
			fila, col: out std_logic_vector (4 downto 0); -- Fila de las bombas horizontales, columna de las bombas verticales
			pos_en_fila, pos_en_col: out std_logic_vector (8 downto 0) -- Columna de las bombas horizontales, fila de las bombas verticales
		);
	end component bombas1;
	
	component bombas2 is
		port (
			-- Posicion de las bombas (x,y) codificado para las bombas:
				-- horizontales (fila, pos_en_fila)
				-- verticales (pos_en_col, col)
			reset, clk_bomb, clk_ram: in std_logic;
			fila, col: out std_logic_vector (4 downto 0); -- Fila de las bombas horizontales, columna de las bombas verticales
			pos_en_fila, pos_en_col: out std_logic_vector (8 downto 0) -- Columna de las bombas horizontales, fila de las bombas verticales
		);
	end component bombas2;
	
	component bombas3 is
		port (
			-- Posicion de las bombas (x,y) codificado para las bombas:
				-- horizontales (fila, pos_en_fila)
				-- verticales (pos_en_col, col)
			reset, clk_bomb, clk_ram: in std_logic;
			fila, col: out std_logic_vector (4 downto 0); -- Fila de las bombas horizontales, columna de las bombas verticales
			pos_en_fila, pos_en_col: out std_logic_vector (8 downto 0) -- Columna de las bombas horizontales, fila de las bombas verticales
		);
	end component bombas3;
	
	-- ROM que contiene las bombas 
	component ROMbombas is
		generic (
			ADDRESS_WIDE : integer := 5;
			DATA_WIDE : integer := 9
		);
		port(
			clk1, clk2, reset : in std_logic;
			en: in std_logic;
			we1, we2 : in std_logic;
			input1, input2 : in std_logic_vector(DATA_WIDE - 1 downto 0); 
			addr1, addr2 : in std_logic_vector(ADDRESS_WIDE - 1 downto 0);
			salida1, salida2 : out std_logic_vector(DATA_WIDE - 1 downto 0)
		);
	end component ROMbombas;
	
	
	signal fila_write, col_write, fila_read, col_read: std_logic_vector (4 downto 0); -- Filas y columnas a escribir en las ROMs así como las que se leen de las mismas
	signal fila_write1, col_write1, fila_write2, col_write2, fila_write3, col_write3: std_logic_vector (4 downto 0); -- Señales idénticas a las anteriores pero específicas de cada nivel
	signal pef_write, pec_write, pef_read, pec_read: std_logic_vector (8 downto 0); -- Ídem pero con la posición en fila y en columna
	signal pef_write1, pec_write1, pef_write2, pec_write2, pef_write3, pec_write3: std_logic_vector (8 downto 0); -- Posición en fila y columna de cada nivel
	signal salida1, salida2: std_logic_vector (8 downto 0); -- Salidas (multiplexadas) de cada ROM
	signal Rmuerte: std_logic;	
	
begin
	-- Asignación de salidas
	fila_read <= fila;
	col_read <= col;
	muerte <= Rmuerte;
	
	-- Multiplexamos las señales según el nivel en el que estemos
	with nivel select
		fila_write <= fila_write1 when "001",
						fila_write2 when "010",
						fila_write3 when "100",
						(others => '0') when others;
						
	with nivel select
		col_write <= col_write1 when "001",
						col_write2 when "010",
						col_write3 when "100",
						(others => '0') when others;
						
	with nivel select
		pef_write <= pef_write1 when "001",
						pef_write2 when "010",
						pef_write3 when "100",
						(others => '0') when others;
						
	with nivel select
		pec_write <= pec_write1 when "001",
						pec_write2 when "010",
						pec_write3 when "100",
						(others => '0') when others;
	-- Máquina de estados que se comunica con el ASM
	muerte_proc: process (clk_ram, reset, x_bola_act, y_bola_act, col_write, pec_write, fila_write, pef_write)
	begin
		if reset = '1' then
			Rmuerte <= '0';
		elsif clk_ram'event and clk_ram = '1' then
			if confirmarMuerte = '1' then
				Rmuerte <= '0';
			elsif (
					x_bola_act(8 downto 4) = col_write
					and  (y_bola_act < (pec_write + 6)) and (pec_write < (y_bola_act + 6)) -- Si estamos próximos a la bola entonces activamos muerte
				) or (
					y_bola_act(8 downto 4) = fila_write
					and  (x_bola_act < (pef_write + 6)) and (pef_write < (x_bola_act + 6))
				) then
				Rmuerte <= '1';
			end if;
		end if;
	end process;

	bombas1_ins: bombas1 port map (
		reset => reset,
		clk_bomb => clk_bomb,
		clk_ram => clk_ram,
		fila => fila_write1,
		col => col_write1,
		pos_en_fila => pef_write1,
		pos_en_col => pec_write1
	);
	
	bombas2_ins: bombas2 port map (
		reset => reset,
		clk_bomb => clk_bomb,
		clk_ram => clk_ram,
		fila => fila_write2,
		col => col_write2,
		pos_en_fila => pef_write2,
		pos_en_col => pec_write2
	);
	
	bombas3_ins: bombas3 port map (
		reset => reset,
		clk_bomb => clk_bomb,
		clk_ram => clk_ram,
		fila => fila_write3,
		col => col_write3,
		pos_en_fila => pef_write3,
		pos_en_col => pec_write3
	);
	
	romH: ROMbombas port map (
		reset => reset,
		clk1 => clk_ram,
		clk2 => clk_ram,
		en => '1',
		we1 => '1',
		we2 => '0',
		input1 => pef_write,
		input2 => "000000000",
		addr1 => fila_write,
		addr2 => fila_read,
		salida1 => salida1,
		salida2 => pos_en_fila
	);
	
	romV: ROMbombas port map (
		reset => reset,
		clk1 => clk_ram,
		clk2 => clk_ram,
		en => '1',
		we1 => '1',
		we2 => '0',
		input1 => pec_write,
		input2 => "000000000",
		addr1 => col_write,
		addr2 => col_read,
		salida1 => salida2,
		salida2 => pos_en_col
	);

end Behavioral;

