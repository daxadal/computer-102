

	library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity vgacore is
    port
    (
   	 reset: in std_logic;    -- reset
   	 clock_in: in std_logic;
   	 hsyncb: inout std_logic;    -- horizontal (line) sync
   	 vsyncb: out std_logic;    -- vertical (frame) sync
   	 rgb: out std_logic_vector(8 downto 0); -- red,green,blue colors
		 
		 x, y: in std_logic_vector (8 downto 0)
    );
end vgacore;

architecture vgacore_arch of vgacore is
signal clock: std_logic;
signal cont, cont_sig: std_logic_vector (3 downto 0);
signal hcnt: std_logic_vector(8 downto 0);    -- horizontal pixel counter
signal vcnt: std_logic_vector(9 downto 0);    -- vertical line counter
begin

A: process(clock,reset)
begin
    -- reset asynchronously clears pixel counter
    if reset='1' then
   	 hcnt <= "000000000";
    -- horiz. pixel counter increments on rising edge of dot clock
    elsif (clock'event and clock='1') then
   	 -- horiz. pixel counter rolls-over after 381 pixels
   	 if hcnt<380 then
   		 hcnt <= hcnt + 1;
   	 else
   		 hcnt <= "000000000";
   	 end if;
    end if;
end process;

B: process(hsyncb,reset)
begin
    -- reset asynchronously clears line counter
    if reset='1' then
   	 vcnt <= "0000000000";
    -- vert. line counter increments after every horiz. line
    elsif (hsyncb'event and hsyncb='1') then
   	 -- vert. line counter rolls-over after 528 lines
   	 if vcnt<527 then
   		 vcnt <= vcnt + 1;
   	 else
   		 vcnt <= "0000000000";
   	 end if;
    end if;
end process;

C: process(clock,reset)
begin
    -- reset asynchronously sets horizontal sync to inactive
    if reset='1' then
   	 hsyncb <= '1';
    -- horizontal sync is recomputed on the rising edge of every dot clock
    elsif (clock'event and clock='1') then
   	 -- horiz. sync is low in this interval to signal start of a new line
   	 if (hcnt>=291 and hcnt<337) then
   		 hsyncb <= '0';
   	 else
   		 hsyncb <= '1';
   	 end if;
    end if;
end process;

D: process(hsyncb,reset)
begin
    -- reset asynchronously sets vertical sync to inactive
    if reset='1' then
   	 vsyncb <= '1';
    -- vertical sync is recomputed at the end of every line of pixels
    elsif (hsyncb'event and hsyncb='1') then
   	 -- vert. sync is low in this interval to signal start of a new frame
   	 if (vcnt>=490 and vcnt<492) then
   		 vsyncb <= '0';
   	 else
   		 vsyncb <= '1';
   	 end if;
    end if;
end process;
	
	registros: process (reset, clock_in)
	begin
		
		if reset ='1' then 
			cont <= "0000";
		elsif clock_in'event and clock_in = '1' then 
			cont <= cont_sig;
		end if;
	end process;
	
	rectangulo: process(clock, vcnt, hcnt, x , y)
	begin
		if vcnt>x-2 and vcnt<x+2 then
			if hcnt>y-2 and hcnt<y+2 then
				rgb<= "111000111";
			end if;
		end if;
		if vcnt>0 and vcnt<317 then
			if hcnt>0 and hcnt<526 then
				rgb<= "000111000";
			else
				rgb<= "000000000";
			end if;
		end if;
	end process;

	
	cont_sig <= cont +1;
	clock <= cont(2);
	
end vgacore_arch;



