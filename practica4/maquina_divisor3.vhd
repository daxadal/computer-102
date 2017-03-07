
-- Eric García de Ceca Elejoste 3º DG -- División optimizada y corregida

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity maquina_divisor3 is
	generic (
		N: natural := 6;
		M: natural := 3
	);
    port (
		clk   : in  std_logic;
      reset : in  std_logic;
      divisor  : in  std_logic_vector(M-1 downto 0);  -- dividendo
      dividendo  : in  std_logic_vector(N-1 downto 0);  -- divisor
      inicio   : in  std_logic;
		ready : out std_logic;
		cociente   : out std_logic_vector(N-1 downto 0)  -- cociente
    );
  end maquina_divisor3;


architecture Behavioral of maquina_divisor3 is
	type estados is (S0, carga, comp_dvs, corr_dvs, resta2, cociente0, cociente1, sig_div);
	signal est_act, est_sig: estados;
	
	signal rdn, rds, rdn_sig, rds_sig: std_logic_vector(N downto 0); -- entrada y salida de registros dividendo y divisor
	signal rc, rc_sig: std_logic_vector(N-1 downto 0);	-- entrada y salida del registro cociente
	signal rk, rk_sig: std_logic_vector(N-M downto 0);	-- entrada y salida del registro incremento
	
	signal ceros: std_logic_vector(N-M-1 downto 0);
begin

	cociente <= rc;
	ceros <= (others=>'0');

	registros: process (reset, clk)
	begin
		if reset = '1' then
			est_act <= S0;
		elsif clk'event and clk = '1' then
			est_act <= est_sig;
			rdn <= rdn_sig;
			rds <= rds_sig;
			rc <= rc_sig;
			rk <= rk_sig;
		end if;
	end process registros;
	
	comb: process (est_act, inicio, rdn, rds, rc, rk, dividendo, divisor)
	begin
		case est_act is
			when S0 =>
				ready <= '1';
				
				rdn_sig <= rdn;
				rds_sig <= rds;
				rc_sig <= rc;
				rk_sig <= rk;
				
				if inicio = '1' then
					est_sig <= carga;
				else
					est_sig <= S0;
				end if;
				
			when carga =>
				ready <= '0';
				
				rdn_sig <= '0' & dividendo;
				rds_sig <= '0' & divisor & ceros;
				rc_sig <= (others => '0');
				rk_sig <= (others => '0');
					
				if dividendo < (ceros & divisor) then
					est_sig <= S0;
				else
					est_sig <= comp_dvs;
				end if;


			when comp_dvs => --nuevo
				ready <= '0';
				
				rdn_sig <= rdn;
				rds_sig <= rds;
				rc_sig <= rc;
				rk_sig <= rk;
				
				if rdn(N downto N-M) > rds(N downto N-M) then
					est_sig <= corr_dvs;
				else
					est_sig <= resta2;
				end if;
				
			when corr_dvs => --nuevo
				ready <= '0';
				
				rdn_sig <= rdn;
				rds_sig <= rds (N-1 downto 1) & '0';
				rc_sig <= rc;
				rk_sig <= rk - 1;
				
				est_sig <= comp_dvs;
			
			when resta2 => --resta2
				ready <= '0';
				
				rdn_sig <= rdn;
				rds_sig <= rds;
				rc_sig <= rc;
				rk_sig <= rk;
				
				if rdn < rds then
					est_sig <= cociente0;
				else
					est_sig <= cociente1;
				end if;
				
			when cociente0 => --c0_2
				ready <= '0';
				
				rdn_sig <= rdn;
				rds_sig <= rds;
				rc_sig <=  rc(N-2 downto 0) & '0';
				rk_sig <= rk;
				
				est_sig <= sig_div;
				
			when cociente1 => --c1_2
				ready <= '0';
				
				rdn_sig <= rdn - rds;
				rds_sig <= rds;
				rc_sig <=  rc(N-2 downto 0) & '1';
				rk_sig <= rk;
				
				est_sig <= sig_div;
				
			when sig_div => 
				ready <= '0';
				
				rdn_sig <= rdn;
				rds_sig <= '0' & rds(N downto 1);
				rc_sig <=  rc;
				rk_sig <= rk + 1;
				
				if rk < N-M and rk(N-M) = '1' then -- ademas rk > 0
					est_sig <= resta2;
				else
					est_sig <= S0;
				end if;
				
		end case;
	
	end process comb;


end Behavioral;

