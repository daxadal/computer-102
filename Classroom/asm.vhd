
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity asm is
	port(
		clk, rst_n, ini : in std_logic;
		clave: in std_logic_vector (3 downto 0);
		dir: out std_logic_vector (6 downto 0);
		fin, error: out std_logic
	);
end asm;

architecture Behavioral of asm is

	component ram is
		port (
			clk, ena, wea: in std_logic;
			addra: in std_logic_vector (6 downto 0);
			dina: in std_logic_vector (3 downto 0);
			douta: out std_logic_vector (3 downto 0)
		);
	end component ram;
	
	type estados is (S0ok, S0error, carga, lectura1, lectura2, sig_lect, comp_ij, escritura, waitIni_ok, waitIni_error);
	signal estado, estsig: estados;
	signal i, j: std_logic_vector (6 downto 0);
	signal Rclave, douta: std_logic_vector (3 downto 0);
	signal ena, wea: std_logic;
begin

	dir <= i;

	ram_obj: ram port map (
		clk => clk,
		ena => ena,
		wea => wea,
		addra => i,
		dina => Rclave,
		douta => douta
	);
	
	registros: process (clk, rst_n)
	begin
	
		if rst_n = '1' then
			i <= (others => '0');
			j <= (others => '0');
			Rclave <= (others => '0');
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
		end if;
		
	end process;
	
	comb: process (estado, ini, i, j, douta, Rclave)
	begin 
	
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
				if douta = Rclave then
					estsig <= waitIni_ok;
				else
					estsig <= sig_lect;
				end if;
				
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
					estsig <= escritura;
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

