library ieee;
use ieee.numeric_bit.all;

entity controlUnit_tb is
end entity;

architecture tb of controlUnit_tb is

	component controlunit is
	port(
		--To datapath
		reg2loc: out bit;
		uncondBranch :out bit;
		branch: out bit;
		memRead: out bit;
		memToReg: out bit;
		aluOp: out bit_vector(1 downto 0) ;
		memWrite: out bit;
		aluSrc: out bit;
		regWrite: out bit;
		--FromDatapath
		opcode: in bit_vector(10 downto 0)
	);
	end component;
	
	signal reg2loc_out: bit;
	signal uncondBranch_out: bit;
	signal branch_out: bit;
	signal memRead_out: bit;
	signal memToReg_out: bit;
	signal aluOp_out: bit_vector(1 downto 0);
	signal memWrite_out: bit;
	signal aluSrc_out: bit;
	signal regWrite_out: bit;
	signal opcode_in: bit_vector(10 downto 0);
	
begin
	dut:controlunit
		port map(reg2loc_out,uncondBranch_out,branch_out,memRead_out,memToReg_out,aluOp_out,memWrite_out,aluSrc_out,regWrite_out,opcode_in);

	stimulus:process is
	begin
	assert false report "simulation start" severity note;
	
	
	opcode_in<="11111000000"; --STUR
	wait for 2 ns;
	
	opcode_in<="00000101101"; --B
	wait for 2 ns;
	
	opcode_in<="10001011000"; --ADD formato R
	wait for 2 ns;
	
	opcode_in<="11111000010"; --LDUR
	wait for 2 ns;
	
	opcode_in<="00010101101"; --B
	wait for 2 ns;
	
	opcode_in<="10110100101"; --CBZ
	wait for 2 ns;
	
	opcode_in<="10101010000"; --OR formato R
	wait for 2 ns;
	
	opcode_in<="11001011000"; --SUB formato R
	wait for 2 ns;
	
	opcode_in<="10001010000"; --ADD formato R
	wait for 2 ns;
	assert false report "simulation end" severity note;
	wait;
	end process;
end architecture;

