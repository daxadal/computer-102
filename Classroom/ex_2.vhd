
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity asm is
	port(
		clk, rst_n, ini : in std_logic;
		clave: in std_logic_vector (3 downto 0);
		dir: out std_logic_vector (6 downto 0);
		fin, error, encontrada: out std_logic
	);
end asm;

architecture Behavioral of asm is

	component rams_02a is
		port (clk: in std_logic;
		dina: in std_logic_vector(3 downto 0);
		addra: in std_logic_vector(4 downto 0);
		wea: in std_logic;
		ena: in std_logic;
		douta: out std_logic_vector(3 downto 0));
	end component rams_02a;
	
	type estados is (S0ok, S0error, carga, lectura1, lectura2, sig_lect, comp_ij, escritura, waitIni_ok, waitIni_error);
	signal estado, estsig: estados;
	signal i, j: std_logic_vector (6 downto 0);
	signal Rclave, douta: std_logic_vector (3 downto 0);
	signal ena, wea: std_logic;
	signal Renc, enc_aux: std_logic;
begin

	dir <= i;
	encontrada <= enc_aux;

	ram_obj: rams_02a port map (
		clk => clk,
		ena => ena,
		wea => wea,
		addra => i(4 downto 0),
		dina => Rclave,
		douta => douta
	);
	
	registros: process (clk, rst_n)
	begin
	
		if rst_n = '1' then
			i <= (others => '0');
			j <= "0000110";
			Rclave <= (others => '0');
			Renc <= '0';
			estado <= S0ok;
		elsif clk'event and clk='1' then
			--Cambios de i
			if estado = carga then
				i <= (others => '0');
			elsif estado = sig_lect then
				i <= i+1;
			else
				i <= i;
			end if;
			--Cambios de j
			if estado = escritura then
				j <= j+1;
			else
				j <= j;
			end if;
			--Cambios de Rclave
			if estado = carga then
				Rclave <= clave;
			else
				Rclave <= Rclave;
			end if;
			--Cambios de estado
			estado <= estsig;
			--Cambios de Renc
			if estado = carga then
				Renc <= '0';
			elsif enc_aux = '1' then
				Renc <= '1';
			else
				Renc <= Renc;
			end if;
		end if;
		
	end process;
	
	comb: process (estado, ini, i, j, douta, Rclave, Renc)
	begin 
	
		if douta = Rclave and estado /= S0error 
				and estado /= waitIni_error and estado /= carga then
			enc_aux <= '1';
		else
			enc_aux <= '0';
		end if;
		
		case estado is
			when S0ok =>
				ena <= '0';
				wea <= '0';
				fin <= '1';
				error <= '0';
				if ini = '1' then
					estsig <= carga;
				else
					estsig <= S0ok;
				end if;
				
			when S0error =>
				ena <= '0';
				wea <= '0';
				fin <= '1';
				error <= '1';
				if ini = '1' then
					estsig <= carga;
				else
					estsig <= S0error;
				end if;
				
			when carga =>
				ena <= '0';
				wea <= '0';
				fin <= '0';
				error <= '0';
				if j = "0000000" then
					estsig <= escritura;
				else
					estsig <= lectura1;
				end if;
				
			when lectura1 =>
				ena <= '1';
				wea <= '0';
				fin <= '0';
				error <= '0';
				estsig <= lectura2;
				
			when lectura2 =>
				ena <= '0';
				wea <= '0';
				fin <= '0';
				error <= '0';
				estsig <= sig_lect;
				
			when sig_lect =>
				ena <= '0';
				wea <= '0';
				fin <= '0';
				error <= '0';
				estsig <= comp_ij;
				
			when comp_ij =>
				ena <= '0';
				wea <= '0';
				fin <= '0';
				error <= '0';
				if i >= j then
					if Renc = '1' then
						estsig <= waitIni_ok;
					else
						estsig <= escritura;
					end if;
				else
					estsig <= lectura1;
				end if;
				
			when escritura =>
				ena <= '1';
				wea <= '1';
				fin <= '0';
				error <= '0';
				estsig <= waitIni_error;
				
			when waitIni_ok =>
				ena <= '0';
				wea <= '0';
				fin <= '1';
				error <= '0';
				if ini = '0' then
					estsig <= S0ok;
				else
					estsig <= waitIni_ok;
				end if;
				
			when waitIni_error =>
				ena <= '0';
				wea <= '0';
				fin <= '1';
				error <= '1';
				if ini = '0' then
					estsig <= S0error;
				else
					estsig <= waitIni_error;
				end if;
				
		end case;
	
	end process;

end Behavioral;

