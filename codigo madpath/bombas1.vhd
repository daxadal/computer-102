
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity bombas1 is
	port (
		-- Posicion de las bombas (x,y) codificado para las bombas:
			-- horizontales (fila, pos_en_fila)
			-- verticales (pos_en_col, col)
		reset, clk_bomb, clk_ram: in std_logic;
		fila, col: out	std_logic_vector (4 downto 0); -- Fila de las bombas horizontales, columna de las bombas verticales
		pos_en_fila, pos_en_col: out std_logic_vector (8 downto 0) -- Columna de las bombas horizontales, fila de las bombas verticales
	);
end bombas1;

architecture Behavioral of bombas1 is

	component bombaH is
		generic (
			LIM_IZ: integer := 0; -- Límite izquierdo
			LIM_DR: integer := 0; -- Límite derecho 
			FILA: integer := 0 -- Fila de la bomba horizontal
		);
		port (
			reset, clk: in std_logic;
			x : out std_logic_vector (8 downto 0) --Salida de la posición actual
		);
	end component bombaH;

	component bombaV is
		generic (
			LIM_SUP: integer := 0; -- Límite superior
			LIM_INF: integer := 0; -- Límite inferior
			COL: integer := 0 -- Columna de la bomba inferior
		);
		port (
			reset, clk: in std_logic;
			y : out std_logic_vector (8 downto 0) --Salida de la posición actual
		);
		end component bombaV;
		
		signal cont : std_logic_vector(4 downto 0);
		signal x_bh1, x_bh4, x_bh5, x_bh6, x_bh17 : std_logic_vector(8 downto 0); -- Bombas horizontales 
		signal y_bv2, y_bv9, y_bv10, y_bv11, y_bv28 : std_logic_vector(8 downto 0); -- Bombas verticales
		
begin
	-- Contador que recorre filas y columnas
	contador: process(clk_ram, reset)
	begin 
		
		if reset = '1' then
			cont <= (others => '0');
		elsif clk_ram'event and clk_ram = '1' then
			cont <= cont + 1;
		end if;
	
	end process;
	
	fila <= cont;
	col <= cont;
	-- Multiplexador que decide si hay bomba en una fila o columna o no
	with cont select
		pos_en_fila <= x_bh1 when "00001",
							x_bh4 when "00100",
							x_bh5 when "00101",
							x_bh6 when "00110",
							x_bh17 when "10001",
							(others => '0') when others;
		
	with cont select
		pos_en_col <= y_bv2 when "00010",
							y_bv9 when "01001",
							y_bv10 when "01010",
							y_bv11 when "01011",
							y_bv28 when "11100",
							(others => '0') when others;




	--Instanciación de las bombas verticales
	
	bombaV2: bombaV generic map (
		LIM_SUP => 10,
		LIM_INF =>16,
		COL => 2
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv2
	);
	
	bombaV9: bombaV generic map (
		LIM_SUP => 6,
		LIM_INF =>14,
		COL => 9
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv9
	);
	
	bombaV10: bombaV generic map (
		LIM_SUP => 6,
		LIM_INF =>14,
		COL => 10
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv10
	);
	
	bombaV11: bombaV generic map (
		LIM_SUP => 6,
		LIM_INF =>14,
		COL => 11
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv11
	);
	
	bombaV28: bombaV generic map (
		LIM_SUP => 1,
		LIM_INF =>13,
		COL => 28
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv28
	);
	
	-- Instanciacion de las bombas horizontales
	
	bombaH1: bombaH generic map (
		LIM_IZ => 1,
		LIM_DR =>19,
		FILA => 1
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh1
	);
	
	bombaH4: bombaH generic map (
		LIM_IZ => 1,
		LIM_DR => 17,
		FILA => 4
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh4
	);
	
	bombaH5: bombaH generic map (
		LIM_IZ => 13,
		LIM_DR => 17,
		FILA => 5
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh5
	);
	
	bombaH6: bombaH generic map (
		LIM_IZ => 13,
		LIM_DR => 17,
		FILA => 6
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh6
	);
	
	bombaH17: bombaH generic map (
		LIM_IZ => 17,
		LIM_DR => 23,
		FILA => 17
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh17
	);
	

end Behavioral;

