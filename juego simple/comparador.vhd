----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:10:24 11/25/2014 
-- Design Name: 
-- Module Name:    comparador - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity comparador is
	generic( 
		Hn: integer := 16;
		Vn: integer := 16
	)
	port (
		x_sig: in std_logic_vector ( Hn - 1 downto 0);
		y_sig: in std_logic_vector ( Vn - 1 downto 0 );
		res: out std_logic;
	);

end comparador;

architecture Behavioral of comparador is

begin


end Behavioral;

