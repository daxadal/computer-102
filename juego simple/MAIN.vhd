
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity MAIN is
	PORT(
		 jugar, reset: in std_logic;    -- reset
   	 clock_in: in std_logic;
   	 hsyncb: inout std_logic;    -- horizontal (line) sync
   	 vsyncb: out std_logic;    -- vertical (frame) sync
   	 rgb: out std_logic_vector(8 downto 0) -- red,green,blue colors
	);
end MAIN;

architecture Behavioral of MAIN is
	component asm is
		port(
			reset, jugar, clk_ball: in std_logic;
			x, y: out std_logic_vector (8 downto 0)
		);
	end component;
	
	component vgacore is
		 port
		 (
			 reset: in std_logic;    -- reset
			 clock_in: in std_logic;
			 hsyncb: inout std_logic;    -- horizontal (line) sync
			 vsyncb: out std_logic;    -- vertical (frame) sync
			 rgb: out std_logic_vector(8 downto 0); -- red,green,blue colors
			 
			 x, y: in std_logic_vector (8 downto 0)
		 );
	end component;

	signal cont, cont_sig: std_logic_vector (8 downto 0);
	signal x, y: std_logic_vector (8 downto 0);
	signal rgbaux: std_logic_vector(8 downto 0);
begin

	registros: process (reset, clock_in)
	begin
		
		if reset ='1' then 
			cont <= "000000000";
		elsif clock_in'event and clock_in = '1' then 
			cont <= cont_sig;
		end if;
	end process;
	
	cont_sig <= cont +1;
	
	asmcomp : asm port map (
		reset, jugar, cont(8),
		x, y
	);
	
	vgacomp: vgacore port map (
		reset,
		cont(2),
		hsyncb,
		vsyncb,
		rgbaux,
		x, y
	);

	rgb <= rgbaux;
	
end Behavioral;

