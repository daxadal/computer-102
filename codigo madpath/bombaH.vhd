
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity bombaH is
	generic (
		LIM_IZ: integer := 0;
		LIM_DR: integer := 0;
		FILA: integer := 0
	);
	port (
		reset, clk: in std_logic;
		x : out std_logic_vector (8 downto 0) --Salida de la posición actual
	);
end bombaH;

architecture Behavioral of bombaH is
	type estados is (moverIz, moverDr);
	signal estado, est_sig: estados;
	signal Rx, x_sig: std_logic_vector (8 downto 0);
begin
	-- Asignación de registros a salida
	x <= Rx;

	-- Máquina de estados de la bomba horizontal
	reg: process (reset, clk)
	begin
		if reset = '1' then
			Rx <= conv_std_logic_vector(16*LIM_IZ+8, 9);
			estado <= moverDr;
		elsif clk'event and clk = '1' then
			Rx <= x_sig;
			estado <= est_sig;
		end if;
	end process reg;
	
	comb: process (estado, Rx)
	begin
		case estado is
		
			when moverDr =>
				x_sig <= Rx + 1;
				if Rx = 16*LIM_DR+8 then
					est_sig <= moverIz;
				else
					est_sig <= moverDr;
				end if;
				
			when moverIz =>
				x_sig <= Rx - 1;
				if Rx = 16*LIM_IZ+8 then
					est_sig <= moverDr;
				else
					est_sig <= moverIz;
				end if;
		
		end case;
	end process;

end Behavioral;

