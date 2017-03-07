
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity bombaV is
	generic (
		LIM_SUP: integer := 0;
		LIM_INF: integer := 0;
		COL: integer := 0
	);
	port (
		reset, clk: in std_logic;
		y : out std_logic_vector (8 downto 0) --Salida de la posición actual
	);
end bombaV;

architecture Behavioral of bombaV is
	type estados is (moverAr, moverAb);
	signal estado, est_sig: estados;
	signal Ry, y_sig: std_logic_vector (8 downto 0);
begin
	-- Asignación de registros a salida
	y <= Ry;
	-- Máquina de estados de la bomba vertical
	reg: process (reset, clk)
	begin
		if reset = '1' then
			Ry <= conv_std_logic_vector(LIM_SUP*16+8, 9);
			estado <= moverAb;
		elsif clk'event and clk = '1' then
			Ry <= y_sig;
			estado <= est_sig;
		end if;
	end process reg;
	
	comb: process (estado, Ry)
	begin
		case estado is
		
			when moverAb =>
				y_sig <= Ry + 1;
				if Ry = LIM_INF*16+8 then
					est_sig <= moverAr;
				else
					est_sig <= moverAb;
				end if;
				
			when moverAr =>
				y_sig <= Ry - 1;
				if Ry = LIM_SUP*16+8 then
					est_sig <= moverAb;
				else
					est_sig <= moverAr;
				end if;
		
		end case;
	end process;

end Behavioral;

