library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity asm is
	port(
		reset, jugar, clk_ball: in std_logic;
		x, y: out std_logic_vector (8 downto 0)
	);
end asm;

architecture Behavioral of asm is
	type estados is (S0, iniciar, abajo_dr, arriba_dr, abajo_iz, arriba_iz);
	signal estado_act, estado_sig : estados;
	signal px, py, rpx, rpy: std_logic_vector (8 downto 0);
	
	constant lim_iz: std_logic_vector (8 downto 0) := (others => '0'); --0
	constant lim_dr: std_logic_vector (8 downto 0) := "111110100";--es 500
	constant lim_arr: std_logic_vector (8 downto 0) := (others => '0'); --0
	constant lim_ab: std_logic_vector (8 downto 0) := "100111101";--es 317	
	constant hor_ini: std_logic_vector (8 downto 0) := "100101100";--es 300
	constant vert_ini: std_logic_vector (8 downto 0) := "011001000";--es 200
begin

	registros: process (clk_ball, reset)
	begin
		if reset ='1' then
			estado_act <= S0;
			rpx <= (others => '0');
			rpy <= (others => '0');
		elsif clk_ball'event and clk_ball ='1' then
			estado_act <= estado_sig;
			rpx <= px;
			rpy <= py;
		end if;
	end process registros;
	
	combinacional: process (estado_act, jugar, rpx, rpy)
	begin
		case estado_act is
			when S0 =>
				if jugar ='0' then
					estado_sig <= S0;
				else
					estado_sig <= iniciar;
				end if;
			when iniciar =>
				px <= hor_ini;
				py <= vert_ini;
				estado_sig <= abajo_dr;
			when abajo_dr =>
				px <= rpx +1;
				py <= rpy +1;
				if rpy >= lim_ab then
					estado_sig <= arriba_dr;
				elsif rpx >= lim_dr then
					estado_sig <= abajo_iz;
				else
					estado_sig <= abajo_dr;
				end if;
			when arriba_dr =>
				px <= rpx +1;
				py <= rpy -1;
				if rpy <= lim_arr then
					estado_sig <= abajo_dr;
				elsif rpx >= lim_dr then
					estado_sig <= abajo_iz;
				else
					estado_sig <= arriba_dr;
				end if;
			when arriba_iz =>
				px <= rpx -1;
				py <= rpy -1;
				if rpy <= lim_arr then
					estado_sig <= abajo_iz;
				elsif rpx <= lim_iz then
					estado_sig <= arriba_dr;
				else
					estado_sig <= arriba_iz;
				end if;
			when abajo_iz =>
				px <= rpx -1;
				py <= rpy +1;
				if rpy>= lim_ab then
					estado_sig <= arriba_iz;
				elsif rpx <= lim_iz then
					estado_sig <= abajo_dr;
				else
					estado_sig <= abajo_iz;
				end if;
			end case;
				
	end process combinacional;

	x <= rpx;
	y <= rpy;
	
end Behavioral;

