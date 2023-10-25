library ieee;
use ieee.numeric_bit.all;

entity signExtend_tb is
end entity;

architecture tb of signExtend_tb is
	
	component signExtend is
	port(
		i:in bit_vector(31 downto 0); --input
		o:out bit_vector(63 downto 0) --output
	);
	end component;
	
	signal i_in: bit_vector(31 downto 0);
	signal o_out: bit_vector(63 downto 0);
begin
	dut:signExtend
		port map(i_in,o_out);
	
	stimulus: process is
	begin
	assert false report "simulation start" severity note;
	i_in<="00010100000001000000000000000011"; -- Codigo Branch (B)
	wait for 2 ns;
	 
	i_in<="10110100100000000000000001100001"; --Codigo CBZ
	wait for 2 ns;
	
	i_in<="11111111111000000000000001100001"; --Codigo aleatorio
	wait for 2 ns;
	
	i_in<="11111000000011100011010100101011"; --Codigo D STUR
	wait for 2 ns;
	
	i_in<="11111000010010000000000000000000"; --Codigo D LDUR
	wait for 2 ns;
	
	i_in<="11111000000100000000000000000000"; --Codigo D STUR adress negativo
	wait for 2 ns;
	
	assert false report "simulation end" severity note;
	wait;
	end process;
end architecture;
