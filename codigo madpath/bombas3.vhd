-- Comentarios adicionales en la entity bombas1
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity bombas3 is
	port (
		-- Posicion de las bombas (x,y) codificado para las bombas:
			-- horizontales (fila, pos_en_fila)
			-- verticales (pos_en_col, col)
		reset, clk_bomb, clk_ram: in std_logic;
		fila, col: out	std_logic_vector (4 downto 0); -- Fila de las bombas horizontales, columna de las bombas verticales
		pos_en_fila, pos_en_col: out std_logic_vector (8 downto 0) -- Columna de las bombas horizontales, fila de las bombas verticales
	);
end bombas3;

architecture Behavioral of bombas3 is

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
		signal x_bh1, x_bh2, x_bh11, x_bh12, x_bh13, x_bh14, x_bh15, x_bh16, x_bh17, x_bh18 : std_logic_vector(8 downto 0);
		signal y_bv1, y_bv9, y_bv15, y_bv19, y_bv22, y_bv24, y_bv26, y_bv28 : std_logic_vector(8 downto 0);
		
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
		pos_en_fila <= x_bh1 when "00001",
							x_bh2 when "00010",
							--x_bh4 when "00100",
							x_bh11 when "01011",
							x_bh12 when "01100",
							x_bh13 when "01101",
							x_bh14 when "01110",
							x_bh15 when "01111",
							x_bh16 when "10000",
							x_bh17 when "10001",
							x_bh18 when "10010",
							(others => '0') when others;
		
	with cont select
		pos_en_col <= 
							y_bv1 when "00001",
					--		y_bv6 when "00110",
							y_bv9 when "01001",
							y_bv15 when "01111",
							y_bv19 when "10011",
							y_bv22 when "10110",
							y_bv24 when "11000",
							y_bv26 when "11010",
							y_bv28 when "11100",
						(others => '0') when others;

	--Instanciación de las bombas verticales
	
	bombaV1: bombaV generic map (
		LIM_SUP => 2,
		LIM_INF => 9,
		COL => 1
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv1
	);
	
--	bombaV6: bombaV generic map (
--		LIM_SUP => 10,
--		LIM_INF => 13,
--		COL => 6
--	) port map (
--		reset => reset,
--		clk => clk_bomb, 
--		y => y_bv6
--	);
	
	bombaV9: bombaV generic map (
		LIM_SUP => 4,
		LIM_INF => 10,
		COL => 9
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv9
	);
	
	bombaV15: bombaV generic map (
		LIM_SUP => 3,
		LIM_INF => 14,
		COL => 15
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv15
	);
	
	bombaV19: bombaV generic map (
		LIM_SUP => 1,
		LIM_INF => 12,
		COL => 19
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv19
	);
	
	bombaV22: bombaV generic map (
		LIM_SUP => 1,
		LIM_INF => 8,
		COL => 22
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv22
	);
	
	bombaV24: bombaV generic map (
		LIM_SUP => 1,
		LIM_INF => 7,
		COL => 24
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv24
	);
	
	bombaV26: bombaV generic map (
		LIM_SUP => 1,
		LIM_INF => 7,
		COL => 26
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv26
	);
	
	bombaV28: bombaV generic map (
		LIM_SUP => 1,
		LIM_INF => 7,
		COL => 28
	) port map (
		reset => reset,
		clk => clk_bomb, 
		y => y_bv28
	);
	
	-- Instanciacion de las bombas horizontales
	
	bombaH1: bombaH generic map (
		LIM_IZ => 2,
		LIM_DR => 9,
		FILA => 1
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh1
	);
	
	bombaH2: bombaH generic map (
		LIM_IZ => 17,
		LIM_DR => 22,
		FILA => 2
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh2
	);
	
--	bombaH4: bombaH generic map (
--		LIM_IZ => 6,
--		LIM_DR => 9,
--		FILA => 4
--	) port map (
--		reset => reset,
--		clk => clk_bomb, 
--		x => x_bh4
--	);
	
	bombaH11: bombaH generic map (
		LIM_IZ => 5,
		LIM_DR => 7,
		FILA => 11
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh11
	);
	
	bombaH12: bombaH generic map (
		LIM_IZ => 25,
		LIM_DR => 28,
		FILA => 12
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh12
	);
	
	bombaH13: bombaH generic map (
		LIM_IZ => 3,
		LIM_DR => 6,
		FILA => 13
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh13
	);
	
	bombaH14: bombaH generic map (
		LIM_IZ => 13,
		LIM_DR => 17,
		FILA => 14
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh14
	);
	
	bombaH15: bombaH generic map (
		LIM_IZ => 1,
		LIM_DR => 6,
		FILA => 15
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh15
	);
	
	bombaH16: bombaH generic map (
		LIM_IZ => 1,
		LIM_DR => 6,
		FILA => 16
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh16
	);
	
	bombaH17: bombaH generic map (
		LIM_IZ => 19,
		LIM_DR => 28,
		FILA => 17
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh17
	);
	
	bombaH18: bombaH generic map (
		LIM_IZ => 23,
		LIM_DR => 28,
		FILA => 18
	) port map (
		reset => reset,
		clk => clk_bomb, 
		x => x_bh18
	);
	
end Behavioral;
