library ieee;
use ieee.numeric_bit.all;

entity polilegsc is
port(
	clock, reset: in bit;
	-- Data Memory
	dmem_addr: out bit_vector(63 downto 0);
	dmem_dati: out bit_vector(63 downto 0);
	dmem_dato: in bit_vector(63 downto 0);
	dmem_we: out bit;
	--Instruction Memory
	imem_addr: out bit_vector(63 downto 0);
	imem_data: in bit_vector(31 downto 0)
) ;
end entity;

architecture UC_mais_FD of polilegsc is
	
	component alucontrol is
	port(
		aluop: in bit_vector(1 downto 0);
		opcode: in bit_vector(10 downto 0);
		aluCtrl: out bit_vector(3 downto 0)
	);
	end component;
	
	component controlunit is
	port(
		--To datapath
		reg2loc: out bit;
		uncondBranch :out bit;
		branch: out bit;
		memRead: out bit;
		memToReg: out bit;
		aluOp: out bit_vector(1 downto 0) ;   --0 10000000001 0101000000000000000000000000000000000000000000000000
		memWrite: out bit; 
		aluSrc: out bit;
		regWrite: out bit;
		--FromDatapath
		opcode: in bit_vector(10 downto 0) --0 10000000110 0000000001000000000000000000000000000000000000000000
	);
	end component;
	
	component datapath is
	port(
		--Common
		clock: in bit;
		reset: in bit;
		--FromControlUnit
		reg2loc: in bit;
		pcsrc: in bit;
		memToReg: in bit;
		aluCtrl: in bit_vector(3 downto 0);
		aluSrc: in bit;
		regWrite: in bit;
		--ToControlUnit
		opcode: out bit_vector(10 downto 0);
		zero: out bit;
		--IMinterface
		imAddr: out bit_vector(63 downto 0);
		imOut: in bit_vector(31 downto 0);
		-- DMinterface
		dmAddr: out bit_vector(63 downto 0);
		dmIn: out bit_vector(63 downto 0);
		dmOut: in bit_vector(63 downto 0)
	);
	end component;
	
	signal fio_reg2loc: bit;
	signal fio_pcsrc: bit;
	signal fio_memToReg: bit;
	signal fio_aluCtrl: bit_vector(3 downto 0);
	signal fio_aluSrc: bit;
	signal fio_regWrite: bit;
	signal fio_zero_and_branch: bit;
	signal fio_zero: bit;
	signal fio_branch:bit;
	signal fio_memRead: bit;
	signal fio_memWrite:bit;
	
	signal fio_uncondbranch:bit;
	signal fio_aluOp: bit_vector(1 downto 0);
	signal fio_opcode: bit_vector(10 downto 0);
	
begin
	fio_zero_and_branch<=fio_zero and fio_branch;
	fio_pcsrc<=fio_zero_and_branch or fio_uncondbranch;
	dmem_we<=fio_memWrite;
	
	fluxo_de_dados:datapath
		port map(clock,reset,fio_reg2loc,fio_pcsrc,fio_memToReg,fio_aluCtrl,fio_aluSrc,fio_regWrite,fio_opcode,fio_zero,imem_addr,imem_data,
					dmem_addr,dmem_dati,dmem_dato);
	
	controle:controlunit
		port map(fio_reg2loc,fio_uncondbranch,fio_branch,fio_memRead,fio_memToReg,fio_aluOp,fio_memWrite,fio_aluSrc,fio_regWrite,fio_opcode);
		
	alu_controle:alucontrol
		port map(fio_aluOp,fio_opcode,fio_aluCtrl);

end architecture;
