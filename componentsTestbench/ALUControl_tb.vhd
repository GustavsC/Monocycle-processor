library ieee;
use ieee.numeric_bit.all;

entity ALUControl_tb is
end entity;

architecture tb of ALUControl_tb is
	
	component alucontrol is
	port(
		aluop: in bit_vector(1 downto 0);
		opcode: in bit_vector(10 downto 0);
		aluCtrl: out bit_vector(3 downto 0)
	);
	end component;
	
	signal aluop_in: bit_vector(1 downto 0);
	signal opcode_in:  bit_vector(10 downto 0);
	signal aluCtrl_out: bit_vector(3 downto 0);

begin
	dut:alucontrol
		port map(aluop_in,opcode_in,aluCtrl_out);
		
		
	stimulus: process is
	begin
	assert false report "simulation start" severity note;
	
	aluop_in<="01";
	opcode_in<="11110000111";
	wait for 2 ns;
	
	aluop_in<="00";
	opcode_in<="11110001111";
	wait for 2 ns;

	aluop_in<="00";
	opcode_in<="11110100111";
	wait for 2 ns;
	
	aluop_in<="10";
	opcode_in<="10001011000";
	wait for 2 ns;
	
	aluop_in<="10";
	opcode_in<="10001010000";
	wait for 2 ns;
	
	aluop_in<="10";
	opcode_in<="10101010000";
	wait for 2 ns;
	
	aluop_in<="11";
	opcode_in<="10101010000";
	wait for 2 ns;
	
	assert false report "simulation end" severity note;
	wait;
	end process;
end architecture;
