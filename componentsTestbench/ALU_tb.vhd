library ieee;
use ieee.numeric_bit.all;

entity ALU_tb is
end entity;

architecture tb of ALU_tb is
	
	component alu is
		generic(
			size: natural := 10 --bitsize
		);
		port(
			A, B: in bit_vector(size-1 downto 0); --inputs
			F: out bit_vector(size-1 downto 0 ) ; --output
			S: in bit_vector(3 downto 0 ) ; --opselection
			Z: out bit; --zeroflag
			Ov: out bit; -- overflowflag
			Co: out bit --carryout
			);
	end component alu;
	
	constant  size_in: integer:=4;
	signal A_in: bit_vector(size_in-1 downto 0);
	signal B_in: bit_vector(size_in-1 downto 0);
	signal F_out: bit_vector(size_in-1 downto 0);
	signal S_in: bit_vector(3 downto 0);
	signal Z_out: bit;
	signal Ov_out: bit;
	signal Co_out: bit;
begin
	dut: alu
		generic map(size_in)
		port map(A_in,B_in,F_out,S_in,Z_out,Ov_out,Co_out);
	
	stimulus:process is
	begin
	assert false report "simulation start" severity note;
	
	A_in<="1000"; --Not OR
	B_in<="1111";
	S_in<="1100";
	wait for 5 ns;
	
	A_in<="1000"; --SOMA
	B_in<="1000";
	S_in<="0001";
	wait for 5 ns;
	
		
	A_in<="0101"; --AND
	B_in<="1000";
	S_in<="0000";
	wait for 5 ns;
	
		
	A_in<="0101";--Subtracao
	B_in<="0110";
	S_in<="0110";
	wait for 5 ns;
	
		
	A_in<="0001";
	B_in<="0010";
	S_in<="0111";
	wait for 5 ns;
	
		
	A_in<="0001";
	B_in<="0010";
	S_in<="0011";
	wait for 5 ns;
	assert false report "Tudo certo" severity note;
	wait;
	end process;

end architecture;
		
	
