

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
ENTITY simu_adder IS
END simu_adder;
 
ARCHITECTURE behavior OF simu_adder IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	constant N : natural := 32;
 
    COMPONENT adder
    PORT(
         cin : IN  std_logic;
         op1 : IN  std_logic_vector(N-1 downto 0);
         op2 : IN  std_logic_vector(N-1 downto 0);
         add : OUT  std_logic_vector(N downto 0)
        );
    END COMPONENT;
	 
	 COMPONENT adderIt
    PORT(
         cin : IN  std_logic;
         op1 : IN  std_logic_vector(N-1 downto 0);
         op2 : IN  std_logic_vector(N-1 downto 0);
         add : OUT  std_logic_vector(N downto 0)
        );
    END COMPONENT;
	 
	 COMPONENT adder1 
    PORT(
         cin : IN  std_logic;
         op1 : IN  std_logic_vector(N-1 downto 0);
         op2 : IN  std_logic_vector(N-1 downto 0);
         add : OUT  std_logic_vector(N downto 0)
        );
    END COMPONENT; 
	 
	 COMPONENT adder2
    PORT(
         cin : IN  std_logic;
         op1 : IN  std_logic_vector(N-1 downto 0);
         op2 : IN  std_logic_vector(N-1 downto 0);
         add : OUT  std_logic_vector(N downto 0)
        );
    END COMPONENT;    

   --Inputs
   signal cin : std_logic;
   signal op1 : std_logic_vector(N-1 downto 0);
   signal op2 : std_logic_vector(N-1 downto 0);

 	--Outputs
   signal add_basico : std_logic_vector(N downto 0);
	signal add_iter : std_logic_vector(N downto 0);
	signal add_1nivel : std_logic_vector(N downto 0);
	signal add_2niveles : std_logic_vector(N downto 0);
 
   constant clock_period : time := 10 ns;
	
	
	signal contador: std_logic_vector (2*N downto 0);
	signal reset, clock: std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut_basico: adder PORT MAP (
          cin => cin,
          op1 => op1,
          op2 => op2,
          add => add_basico
        );
		  
	uut_iter: adderIt PORT MAP (
          cin => cin,
          op1 => op1,
          op2 => op2,
          add => add_iter
        );
		  
	uut_1nivel: adder1 PORT MAP (
          cin => cin,
          op1 => op1,
          op2 => op2,
          add => add_1nivel
        );
		  
	uut_2niveles: adder2 PORT MAP (
          cin => cin,
          op1 => op1,
          op2 => op2,
          add => add_2niveles
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      reset <= '1';
      wait for 10 ns;	
		reset <= '0';

      wait;
   end process;

	cuenta: process (clock, reset)
	begin 
	
		if reset = '1' then
			contador <= (64=>'1', 50 downto 40=>'1', 32=> '1', 17=>'1', others => '0');
		elsif clock'event and clock = '1' then
			contador <= contador + 1;
		end if;
		
	end process;
	
	cin <= contador (0);
	op1 <= contador (N downto 1);
	op2 <= contador (2*N downto N+1);
	
END behavior;
