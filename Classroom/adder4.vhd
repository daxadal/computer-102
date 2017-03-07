
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity adder_64bits is
	generic(N : natural := 64);
	port(
		cin: in std_logic;
		op1 : in std_logic_vector(N-1 downto 0);
		op2 : in std_logic_vector(N-1 downto 0);
		add: out std_logic_vector(N-1 downto 0);
		cout: out std_logic
	);
end adder_64bits;

architecture Behavioral of adder_64bits is
	component full_adder is
		port (
			a, b, c: in std_logic;
			s, p, g: out std_logic
		);
	end component full_adder;
	
	component uaa_2 is
		port (
			cin: in std_logic;
			p, g: in std_logic_vector (3 downto 0);
			cout: out std_logic_vector (3 downto 1);
			Pout, Gout: out std_logic
		);
	end component uaa_2;
	
	component uaa_2super is
		port (
			cin: in std_logic;
			p, g: in std_logic_vector (3 downto 0);
			cout: out std_logic_vector (4 downto 1)
		);
	end component uaa_2super;

	signal carry: std_logic_vector (N downto 0);
	signal carry_super: std_logic_vector (N/4 downto 0);
	signal carry_super2: std_logic_vector (N/16 downto 0);
	
	signal p, g, add_out: std_logic_vector (N-1 downto 0);
	signal p_super, g_super: std_logic_vector ((N-1)/4 downto 0);
	signal p_super2, g_super2: std_logic_vector ((N-1)/16 downto 0); --3 downto 0
	
begin
	
	--Generate full adder
	gen_adder: for i in 0 to N-1 generate
		cell_i: full_adder port map (
			op1(i), op2(i), carry(i),
			add_out(i), p(i), g(i)
		);	
	end generate gen_adder;
	
	--Generate nivel 0 uaa
	--Generate signals entre nivel 0 y nivel 1
	gen_uaa: for i in 0 to (N-1)/4 generate
		uaa_i: uaa_2 port map (
			carry(4*i),
			p(4*i+3 downto 4*i), g(4*i+3 downto 4*i),
			carry(4*i+3 downto 4*i+1),
			p_super(i), g_super(i)
		);
		carry0to1: if i > 0 generate
			carry(4*i) <= carry_super(i);
		end generate;
	end generate gen_uaa;
	
	carry_super(0) <= carry(0);
	carry(N) <= carry_super(N/4);

	--Generate nivel 1 uaa
	--Generate signals entre nivel 1 y nivel 2
	gen_super: for i in 0 to (N-1)/16 generate
		uaa_super_i: uaa_2 port map (
			carry_super(4*i),
			p_super(4*i+3 downto 4*i), g_super(4*i+3 downto 4*i),
			carry_super(4*i+3 downto 4*i+1),
			p_super2(i), g_super2(i)
		);
		carry1to2: if i > 0 generate
			carry_super(4*i) <= carry_super2(i);
		end generate;
	end generate gen_super;
	
	carry_super2(0) <= carry_super(0);
	carry_super(N/4) <= carry_super2(N/16);
	
	--Generate nivel 2 uaa (uaa final)
	gen_super2: for i in 0 to (N-1)/64 generate
		uaa_super2_i: uaa_2super port map (
			carry_super2(4*i),
			p_super2(4*i+3 downto 4*i), g_super2(4*i+3 downto 4*i),
			carry_super2(4*i+4 downto 4*i+1)
		);
		carry1to2: if i > 0 generate
			carry_super(4*i) <= carry_super2(i);
		end generate;
	end generate gen_super2;

	
	
	--Conectar entrada y salida
	carry(0) <= cin;
	add <= add_out; 
	cout <= carry(N);


end Behavioral;

