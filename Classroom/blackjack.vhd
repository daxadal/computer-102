
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity blackjack is
	port (
		reset, clk_in: in std_logic;
		inicio: in std_logic;
		jugar, plantarse: in std_logic;
		
	--	ult_carta : out std_logic_vector(3 downto 0); --Simulación
		ult_carta : out std_logic_vector(6 downto 0); --Implementación
		puntos : out std_logic_vector(5 downto 0);
		pierdo : out std_logic
	);
end blackjack;

architecture Behavioral of blackjack is

	component rams is
		port (
			clk : in std_logic;
			we : in std_logic;
			addr : in std_logic_vector(5 downto 0);
			di : in std_logic_vector(3 downto 0);
			do : out std_logic_vector(3 downto 0)
	);
	end component rams;
	
	--Implementación
	component conv_7seg is 
		Port (
			x : in  STD_LOGIC_VECTOR (3 downto 0);
         display_o : out  STD_LOGIC_VECTOR (6 downto 0));
	end component conv_7seg;
   
   component divisor is
      port (
           reset: in STD_LOGIC;
           clk_entrada: in STD_LOGIC; -- reloj de entrada de la entity superior
           clk_salida: out STD_LOGIC -- reloj que se utiliza en los process del programa principal
       );
   end component divisor;
	------------------
	
	type estados is (S0ganado, S0perdido, carga, esperar_carta, pedir_carta, obtener_carta,
							 comp_carta, act_puntos, comp_puntos, esperar_boton);
	signal estado, est_sig: estados;
	
	signal cont, cont_sig : std_logic_vector(5 downto 0);
	signal ult_carta_out, ult_carta_sig : std_logic_vector(3 downto 0);
	signal puntos_out: std_logic_vector (5 downto 0);
	signal we, clk: std_logic;
	
begin
	
	-- RAM y Conexiones constantes
	cont_sig <= cont + "000001";
	puntos <= puntos_out;
	
--	ult_carta <= ult_carta_out; --Simulación
	
	display: conv_7seg port map (	--Implementación
		ult_carta_out,
		ult_carta
	);
	
	ram: rams port map (
		clk, we,
		cont, 
		"0000", ult_carta_sig
	);
   
--   clk <= clk_in; --Simulación

   div: divisor port map (	--Implementación
      reset,
      clk_in,
      clk
   );

	------------------
	
	
	
	--Cambios síncronos
	registros: process (clk, reset)
	begin
	
		if reset = '1' then
			cont <= "000000";
			ult_carta_out <= "0000";
			puntos_out <= "000000";
			estado <= S0ganado;
		elsif clk'event and clk = '1' then
			--contador
			if cont >= "110011" then --cont >=51
				cont <= "000000";
			else
				cont <= cont_sig;
			end if;
			
			-- otros registros
			case estado is
				when carga =>
					ult_carta_out <= "0000";
					puntos_out <= "000000";
				when obtener_carta =>
					ult_carta_out <= ult_carta_sig;
				when act_puntos =>
					puntos_out <= puntos_out + ("00" & ult_carta_out);
				when others =>
					--Nada
			end case;
			
			--estado
			estado <= est_sig;
		
		end if;
	end process registros;
	---------------------
	
	
	
	
	--Lógica combinacional
	comb: process (estado, inicio, plantarse, jugar, puntos_out, ult_carta_out)
	begin
	
		case estado is
			when S0ganado =>
				pierdo <= '0';
				we <= '0';
				if inicio = '1' then
					est_sig <= carga;
				else
					est_sig <= S0ganado;
				end if;
				
			when S0perdido =>
				pierdo <= '1';
				we <= '0';
				if inicio = '1' then
					est_sig <= carga;
				else
					est_sig <= S0perdido;
				end if;
				
			when carga =>
				pierdo <= '0';
				we <= '0';
				
				est_sig <= esperar_carta;
				
			when esperar_carta =>
				pierdo <= '0';
				we <= '0';	
				
				if plantarse = '0' then
					est_sig <= S0ganado;
				elsif jugar = '0' then
					est_sig <= pedir_carta;
				else
					est_sig <= esperar_carta;
				end if;
				
			when pedir_carta =>
				pierdo <= '0';
				we <= '1';
				est_sig <= obtener_carta;
			
			when obtener_carta =>
				pierdo <= '0';
				we <= '0';
				est_sig <= comp_carta;
				
			when comp_carta =>	
				pierdo <= '0';
				we <= '0';			
				if ult_carta_out = "0000" then
					est_sig <= pedir_carta;
				else
					est_sig <= act_puntos;
				end if;
			
			when act_puntos =>
				pierdo <= '0';
				we <= '0';
				
				est_sig <= comp_puntos;
				
			when comp_puntos =>
				pierdo <= '0';
				we <= '0';
				if puntos_out > "10101" then --puntos_out > 21
					est_sig <= S0perdido;
				else
					est_sig <= esperar_boton;
				end if;
            
          when esperar_boton =>
            pierdo <= '0';
				we <= '0';
            
            if plantarse = '1' and jugar = '1' then --Botones en  reposo
					est_sig <= esperar_carta;
				else
					est_sig <= esperar_boton;
				end if;
				
		end case;
		
	end process comb;

end Behavioral;

