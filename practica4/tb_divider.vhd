----------------------------------------------------------------------------------
-- Company:        Universidad Complutense de Madrid
-- Engineer:       TOC&TC
-- 
-- Create Date:    
-- Design Name:    Divisor secuencial
-- Module Name:    tb_divider - beh 
-- Project Name:   Practica 5
-- Target Devices: Spartan-3 
-- Tool versions:  ISE 14.1
-- Description:    Testbech del divisor secuencial de numeros 8 bits
-- Dependencies: 
-- Revision: 
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity tb_divider is

end tb_divider;

architecture beh of tb_divider is
component maquina_divisor
    port (clk   : in  std_logic;
        reset : in  std_logic;
        divisor  : in  std_logic_vector(2 downto 0);  -- dividendo
        dividendo  : in  std_logic_vector(5 downto 0);  -- divisor
        inicio   : in  std_logic;
	ready : out std_logic;
	cociente   : out std_logic_vector(5 downto 0)  -- cociente
        );
  end component;
  
  component maquina_divisor2
    port (clk   : in  std_logic;
        reset : in  std_logic;
        divisor  : in  std_logic_vector(2 downto 0);  -- dividendo
        dividendo  : in  std_logic_vector(5 downto 0);  -- divisor
        inicio   : in  std_logic;
	ready : out std_logic;
	cociente   : out std_logic_vector(5 downto 0)  -- cociente
        );
  end component;
  
  component maquina_divisor3 
    port (clk   : in  std_logic;
        reset : in  std_logic;
        divisor  : in  std_logic_vector(2 downto 0);  -- dividendo
        dividendo  : in  std_logic_vector(5 downto 0);  -- divisor
        inicio   : in  std_logic;
	ready : out std_logic;
	cociente   : out std_logic_vector(5 downto 0)  -- cociente
        );
  end component;


  signal clk, rst, inicio, ready, ready2, ready3 : std_logic;
  signal divisor                   : std_logic_vector(2 downto 0);
  signal cociente, cociente2, cociente3, dividendo       : std_logic_vector(5 downto 0);
  
begin


  -------------------------------------------------------------------------------
  -- Component instantiation
  -------------------------------------------------------------------------------

  i_dut : maquina_divisor
    port map (clk, rst, divisor, dividendo, inicio, ready, cociente);
	 
	i_dut2 : maquina_divisor2
    port map (clk, rst, divisor, dividendo, inicio, ready2, cociente2);
	 
	i_dut3 : maquina_divisor3
    port map (clk, rst, divisor, dividendo, inicio, ready3, cociente3);

  -----------------------------------------------------------------------------
  -- Process declaration
  -----------------------------------------------------------------------------
  -- Input clock
  p_clk : process
  begin
    clk <= '0', '1' after 5 ns;
    wait for 10 ns;
  end process p_clk;

  -- External reset
  p_rst : process
  begin
    rst <= '1';
    wait for 250 ns;
    rst <= '0';
    wait;
  end process p_rst;

  p_driver : process
    

  begin
    inicio <= '0';
    wait for 250 ns;
    dndo_loop : for v_i in 1 to 63 loop
      dividendo <= std_logic_vector(to_unsigned(v_i, 6));
      dsor_loop : for v_j in 1 to 7 loop
        divisor <= std_logic_vector(to_unsigned(v_j, 3));
        wait until rising_edge(clk);
        inicio    <= '1';
        wait until rising_edge(clk);
        inicio    <= '0';
        wait until ready = '1' and ready2 = '1';
        wait until rising_edge(clk);
       end loop dsor_loop;
    end loop dndo_loop;
    wait;
  end process p_driver;

end beh;
