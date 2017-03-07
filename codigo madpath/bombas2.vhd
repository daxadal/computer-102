-- Comentarios adicionales en la entity bombas1
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity bombas2 is
	port (
		-- Posicion de las bombas (x,y) codificado para las bombas:
			-- horizontales (fila, pos_en_fila)
			-- verticales (pos_en_col, col)
		reset, clk_bomb, clk_ram: in std_logic;
		fila, col: out	std_logic_vector (4 downto 0); -- Fila de las bombas horizontales, columna de las bombas verticales
		pos_en_fila, pos_en_col: out std_logic_vector (8 downto 0) -- Columna de las bombas horizontales, fila de las bombas verticales
	);
end bombas2;

architecture Behavioral of bombas2 is

	component bombaH is
		generic (
			LIM_IZ: integer := 0;
			LIM_DR: integer := 0;
			FILA: integer := 0
		);
		port (
			reset, clk: in std_logic;
			x : out std_logic_vector (8 downto 0) --Salida de la posición actual
		);
	end component bombaH;

	component bombaV is
		generic (
			LIM_SUP: integer := 0;
			LIM_INF: integer := 0;
			COL: integer := 0
		);
		port (
			reset, clk: in std_logic;
			y : out std_logic_vector (8 downto 0) --Salida de la posición actual
		);
		end component bombaV;
		
		signal cont : std_logic_vector(4 downto 0);

		signal x_bh1, x_bh3, x_bh5, x_bh9, x_bh12, x_bh16, x_bh17 : std_logic_vector(8 downto 0);
		signal y_bv2, y_bv4, y_bv6, y_bv9, y_bv15, y_bv17, y_bv23, y_bv27 : std_logic_vector(8 downto 0);
		
begin

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
	with cont select
		pos_en_fila <= 
							x_bh1 when "00001",
							x_bh3 when "00011",
							x_bh5 when "00101",
							x_bh9 when "01001",
							x_bh12 when "01100",
							x_bh16 when "10000",
							x_bh17 when "10001",
							(others => '0') when others;
							


		
	with cont select
		pos_en_col <= 
							y_bv2 when "00010",
							y_bv4 when "00100",
							y_bv6 when "00110",
							y_bv9 when "01001",
							y_bv15 when "01111",
							y_bv17 when "10001",
							y_bv23 when "10111",
							y_bv27 when "11011",
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
	
	bombaV4: bombaV generic map (
		LIM_SUP => 10,
		LIM_INF =>16,
		COL => 4
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv4
	);
	
	bombaV6: bombaV generic map (
		LIM_SUP => 14,
		LIM_INF =>18,
		COL => 6
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv6
	);
	
	bombaV9: bombaV generic map (
		LIM_SUP => 1,
		LIM_INF => 5,
		COL => 9
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv9
	);
	
	bombaV15: bombaV generic map (
		LIM_SUP => 5,
		LIM_INF =>11,
		COL => 15
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv15
	);
	
	bombaV17: bombaV generic map (
		LIM_SUP => 6,
		LIM_INF =>16,
		COL => 17
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv17
	);
	
	
	bombaV23: bombaV generic map (
		LIM_SUP => 7,
		LIM_INF => 14,
		COL => 23
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv23
	);
	
	bombaV27: bombaV generic map (
		LIM_SUP => 1,
		LIM_INF =>14,
		COL => 27
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv27
	);

	
	-- Instanciacion de las bombas horizontales
	
	
	bombaH1: bombaH generic map (
		LIM_IZ => 3,
		LIM_DR =>16,
		FILA => 1
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh1
	);
	
	bombaH3: bombaH generic map (
		LIM_IZ => 11,
		LIM_DR =>18,
		FILA => 3
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh3
	);
	
	bombaH5: bombaH generic map (
		LIM_IZ => 2,
		LIM_DR =>7,
		FILA => 5
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh5
	);
	
	bombaH9: bombaH generic map (
		LIM_IZ => 10,
		LIM_DR =>15,
		FILA => 9
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh9
	);
	
	bombaH12: bombaH generic map (
		LIM_IZ => 1,
		LIM_DR =>11,
		FILA => 12
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh12
	);
	
	bombaH16: bombaH generic map (
		LIM_IZ => 8,
		LIM_DR =>12,
		FILA => 16
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh16
	);
	
	bombaH17: bombaH generic map (
		LIM_IZ => 23,
		LIM_DR =>28,
		FILA => 17
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh17
	);


end Behavioral;
