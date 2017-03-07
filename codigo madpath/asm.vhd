library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity asm is
	generic (
			DATA_WIDE : integer := 2
		);
	port(
		reset, clk: in std_logic;
		direcciones: in std_logic_vector(6 downto 0); --Up-Down-Left-Right-3-2-1
		nivel_out: out std_logic_vector (2 downto 0); -- Nivel al que hay que cambiar cuando se solicita desde el teclado
		reinicia_nivel: out std_logic; -- Salida que decide si hay que volver a cargar algún nivel (no tiene por qué ser el actual)
		libre: in std_logic_vector (1 downto 0); -- Señal que nos indica si podemos mover a la posición que ha pedido el usuario (libre=0, pared=1)
		muerte: in std_logic; -- Señal que indica si la bola ha tocado una bomba
		confirmarMuerte: out std_logic; -- Señal que confirma la muerte
		x, y : out std_logic_vector (8 downto 0); --Salida a la vga
		x_inicial, y_inicial : in std_logic_vector (8 downto 0); --Posicion inicial de la bola
		x_sig, y_sig : out std_logic_vector (8 downto 0); --Posicion siguiente de la bola
		vidas: out std_logic_vector (1 downto 0) -- Numero de vidas que disponemos
	);
end asm;

architecture Behavioral of asm is
	type estados is (S0selec_nivel, S0jugar, muerto, cambiarNivel1, cambiarNivel2, aNivel0, aNivel0_2, reseteoHaciaNivel0, reseteo, preguntar, 
							respuesta, moverse, moveR, moveU, moveD, moveL); -- Estados del ASM
	signal estado_act, estado_sig : estados; -- Estado actual y siguiente
	signal rpx, rpy:  std_logic_vector (8 downto 0); -- Registros de posiciones x e y
	signal px_aux, py_aux, rpx_aux, rpy_aux:  std_logic_vector (8 downto 0); --Para calular la siguiente posicion a mover
	signal px_aux2, py_aux2, rpx_aux2, rpy_aux2:  std_logic_vector (8 downto 0); --Para calular la siguiente posicion para la memoria
	signal nivel: std_logic_vector (2 downto 0); -- Registro de nivel 
	signal Rvidas: std_logic_vector (1 downto 0); -- Registro de vidas
	
begin
	-- Asignaciones de registros
	x <= rpx;
	y <= rpy;
	x_sig <= rpx_aux2;
	y_sig <= rpy_aux2;
	
	nivel_out <= nivel;
	
	vidas <= Rvidas;

	registros: process (clk, reset)
	begin
		if reset = '1' then
			Rvidas <= "11";
			estado_act <= S0selec_nivel; 
			rpx <= (others => '0');
			rpy <= (others => '0');
			nivel <= "000"; --Nivel en la rom en el que no hay bola. se escribe "selecciona nivel"
	
		elsif clk'event and clk ='1' then

			if estado_act = cambiarNivel1 then -- Estado que nos cambia a otro nivel y resetea
				nivel <= direcciones(2 downto 0);
			
			elsif estado_act = S0selec_nivel then
				Rvidas <= "11";
			elsif estado_act = muerto then
				Rvidas <= Rvidas - 1;
			elsif estado_act = aNivel0 then
				nivel <= "000";
				Rvidas <= Rvidas;
			elsif estado_act = moverse and nivel /= "000" then -- Estado que actualiza las salidas x e y de salida
				rpx <= rpx_aux;
				rpy <= rpy_aux;
			
			elsif estado_act = respuesta and libre = "10" then -- Estado tras haber tocado la copa (Pasamos de nivel)
				case nivel is 
					when "001" => 
						nivel<= "010";
					when "010" =>
						nivel <= "100"; 
					when "100" =>
						nivel <= "001";
					when others =>
						nivel <= "000";
				end case;
				
			elsif estado_act = reseteo then -- Estado que resetea a la posición inicial de la bola
				rpx <= x_inicial;
				rpy <= y_inicial;
				
			elsif (estado_act = moveU or estado_act = moveD or estado_act = moveR or estado_act = moveL) then -- Estados que actualizan las salidas x_sig e y_sig
				rpx_aux2 <= px_aux2;
				rpy_aux2 <= py_aux2;
				rpx_aux <= px_aux;
				rpy_aux <= py_aux;

			end if;
			estado_act <= estado_sig;	
			
		end if;
	end process registros;
	
	combinacional: process (estado_act, rpx, rpy, direcciones, x_inicial, y_inicial, libre, Rvidas, muerte)
	begin
		case estado_act is
		
			when S0selec_nivel => -- estado inicial de la maquina
				reinicia_nivel <= '0';
				confirmarMuerte <= '0';
				px_aux <= rpx;
				py_aux <= rpy;
				px_aux2 <= rpx;
				py_aux2 <= rpy;
				case direcciones is 
					when "0000100" => --Lv3				
						estado_sig <= cambiarNivel1;
					when "0000010" => --Lv2
						estado_sig <= cambiarNivel1;
					when "0000001" => --Lv1
						estado_sig <= cambiarNivel1;
					when others =>
						estado_sig <= S0selec_nivel;	
				end case;
					
			when muerto =>
				confirmarMuerte <= '1';
				reinicia_nivel <= '1';
				px_aux <= rpx;
				py_aux <= rpy;
				px_aux2 <= rpx;
				py_aux2 <= rpy;
				estado_sig <= reseteo;
				
			when cambiarNivel1 => --Se ha seleccionado el nivel a jugar. Se carga en regístro
				confirmarMuerte <= '0';
				reinicia_nivel <= '0';
				px_aux <= rpx;
				py_aux <= rpy;
				px_aux2 <= rpx;
				py_aux2 <= rpy;
				estado_sig <= cambiarNivel2;
				
			when cambiarNivel2 => --Se ordena a la memoria que cargue dicho nivel
				reinicia_nivel <= '1';
				confirmarMuerte <= '0';
				px_aux <= rpx;
				py_aux <= rpy;
				px_aux2 <= rpx;
				py_aux2 <= rpy;
				estado_sig <= reseteo;
				
			when reseteo =>	--Se inicializa la bola
				reinicia_nivel <= '0';
				confirmarMuerte <= '1';
				px_aux <= rpx;
				py_aux <= rpy;
				px_aux2 <= rpx;
				py_aux2 <= rpy;
				if Rvidas = "00" then
					estado_sig <= aNivel0;
				else
					estado_sig <= S0jugar;
				end if;
					
			when aNivel0 =>	
				reinicia_nivel <= '0';
				confirmarMuerte <= '0';
				px_aux <= rpx;
				py_aux <= rpy;
				px_aux2 <= rpx;
				py_aux2 <= rpy;
				estado_sig <= aNivel0_2;
				
			when aNivel0_2 =>	
				reinicia_nivel <= '1';
				confirmarMuerte <= '0';
				px_aux <= rpx;
				py_aux <= rpy;
				px_aux2 <= rpx;
				py_aux2 <= rpy;
				estado_sig <= reseteoHaciaNivel0;
			
			when reseteoHaciaNivel0 =>	
				reinicia_nivel <= '0';
				confirmarMuerte <= '0';
				px_aux <= rpx;
				py_aux <= rpy;
				px_aux2 <= rpx;
				py_aux2 <= rpy;
				estado_sig <= S0selec_nivel;
			
			when S0jugar => --Estado de espera ya jugando
				reinicia_nivel <= '0';
				confirmarMuerte <= '0';
				px_aux <= rpx;
				py_aux <= rpy;
				px_aux2 <= rpx;
				py_aux2 <= rpy;
				if muerte = '1' then
					estado_sig <= muerto;
				else
				case direcciones is
					when "1000000" => --Up
						estado_sig <= moveU;
					when "0100000" => --Down
						estado_sig <= moveD;
					when "0010000" => --Left
						estado_sig <= moveL;
					when "0001000" => --Right
						estado_sig <= moveR;
					when others =>
						estado_sig <= S0jugar;					
				end case;
				end if;
			
			when moveU => --Se ha pulsado tecla de dirección. Se calcula la posición destino
				reinicia_nivel <= '0';
				confirmarMuerte <= '0';
				py_aux <= rpy - 1;
				px_aux <= rpx;
				py_aux2 <= rpy - 4;
				px_aux2 <= rpx;
				estado_sig <= preguntar;
				
			when moveD => --Se ha pulsado tecla de dirección. Se calcula la posición destino
				reinicia_nivel <= '0';
				confirmarMuerte <= '0';
				py_aux <= rpy + 1;
				px_aux <= rpx;
				py_aux2 <= rpy + 4;
				px_aux2 <= rpx;
				estado_sig <= preguntar;
				
			when moveR => --Se ha pulsado tecla de dirección. Se calcula la posición destino
				reinicia_nivel <= '0';
				confirmarMuerte <= '0';
				px_aux <= rpx + 1;
				py_aux <= rpy;
				px_aux2 <= rpx + 4;
				py_aux2 <= rpy;
				estado_sig <= preguntar;
				
			when moveL => --Se ha pulsado tecla de dirección. Se calcula la posición destino
				reinicia_nivel <= '0';
				confirmarMuerte <= '0';
				px_aux <= rpx - 1;
				py_aux <= rpy;
				px_aux2 <= rpx - 4;
				py_aux2 <= rpy;
				estado_sig <= preguntar;
			
			when preguntar => --Se pregunta a la memoria si la posición destino está libre
				reinicia_nivel <= '0';
				confirmarMuerte <= '0';
				px_aux <= rpx;
				py_aux <= rpy;
				px_aux2 <= rpx;
				py_aux2 <= rpy;
				estado_sig <= respuesta;
				
			when respuesta => --Se recibe la respuesta de la memoria.
				reinicia_nivel <= '0';
				confirmarMuerte <= '0';
				px_aux <= rpx;
				py_aux <= rpy;px_aux2 <= rpx;
				py_aux2 <= rpy;
				if libre = "00" then
					estado_sig <= moverse;
				elsif libre  = "10" then
					estado_sig <= cambiarNivel2;
				else 
					estado_sig <= S0jugar;
				end if;
				
			when moverse => --Se mueve a la posicion destino
				reinicia_nivel <= '0';
				confirmarMuerte <= '0';
				px_aux <= rpx;
				py_aux <= rpy;
				px_aux2 <= rpx;
				py_aux2 <= rpy;
				estado_sig <= S0jugar;
		end case;
		
	end process combinacional;

end Behavioral;

