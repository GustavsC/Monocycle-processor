library ieee;
use ieee.numeric_bit.all;

entity shiftleft is
	port(
		clock: in bit;
		entrada: in bit_vector(63 downto 0);
		saida: out bit_vector(63 downto 0)
	);
end entity;

architecture deslocando of shiftleft is
begin
	process(clock)
		variable multiplicando: unsigned(63 downto 0);
	begin
		multiplicando:=unsigned(entrada);
		if(rising_edge(clock)) then
			multiplicando:=multiplicando+multiplicando+multiplicando+multiplicando;
			saida<=bit_vector(multiplicando);
		end if;
	end process;
end architecture;

library ieee;
use ieee.numeric_bit.all;

entity mux_64bits is
	port(
		entrada_zero: in bit_vector(63 downto 0);
		entrada_um: in bit_vector(63 downto 0);
		seletor: in bit;
		saida_64bits: out bit_vector(63 downto 0)
	);
end entity;

architecture mux_final of mux_64bits is
begin
	with seletor select
		saida_64bits<=entrada_zero when '0',
					  entrada_um when '1';
end architecture;
		
entity mux_5bits is
	port(
		entrada_zero: in bit_vector(4 downto 0);
		entrada_um: in bit_vector(4 downto 0);
		seletor: in bit;
		saida_5bits: out bit_vector(4 downto 0)
	);
end entity;

architecture mux_final of mux_5bits is
begin
	with seletor select
		saida_5bits<=entrada_zero when '0',
					  entrada_um when '1';
end architecture;

library ieee;
use ieee.numeric_bit.all;

entity reg_contador is
	port(
		clock,reset: in bit;
		entrada_PC: in bit_vector(63 downto 0);
		saida_PC: out bit_vector(63 downto 0)
	);
end entity;

architecture PC of reg_contador is
begin
	process(clock)
	begin
		if(reset='1') then
			saida_PC<="0000000000000000000000000000000000000000000000000000000000000000";
		end if;
		
		if(rising_edge(clock)) then
			saida_PC<=entrada_PC;
		end if;
	end process;
end architecture;
		
library ieee;
use ieee.numeric_bit.all;		
		
entity datapath is
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
end entity datapath;

architecture fluxo_dados of datapath is
	component banco_registradores is
		port(
			clock: in bit;
			reset: in bit;
			regWrite: in bit;
			read_register_1, read_register_2, write_register:in bit_vector(4 downto 0);
			write_data: in bit_vector(63 downto 0);
			read_data_1,read_data_2: out bit_vector(63 downto 0)
		);
	end component;
	
	component alu is
	port(
		A, B: in bit_vector(63 downto 0); --inputs
		F: out bit_vector(63 downto 0); --output
		S: in bit_vector(3 downto 0); --opselection
		Z: out bit; --zeroflag
		Ov: out bit; -- overflowflag
		Co: out bit --carryout
		);
	end component;

	component signExtend is
		port(
			i:in bit_vector(31 downto 0); --input
			o:out bit_vector(63 downto 0) --output
		);
	end component;
	
	component shiftleft is
	port(
		clock: in bit;
		entrada: in bit_vector(63 downto 0);
		saida: out bit_vector(63 downto 0)
	);
	end component;

	component mux_64bits is
	port(
		entrada_zero: in bit_vector(63 downto 0);
		entrada_um: in bit_vector(63 downto 0);
		seletor: in bit;
		saida_64bits: out bit_vector(63 downto 0)
	);
	end component;
	
	component mux_5bits is
	port(
		entrada_zero: in bit_vector(4 downto 0);
		entrada_um: in bit_vector(4 downto 0);
		seletor: in bit;
		saida_5bits: out bit_vector(4 downto 0)
	);
	end component;
	
	component reg_contador is
	port(
		clock,reset: in bit;
		entrada_PC: in bit_vector(63 downto 0);
		saida_PC: out bit_vector(63 downto 0)
	);
	end component;
	
	signal write_register_instruction: bit_vector(4 downto 0);
	signal read_register_1_instruction: bit_vector(4 downto 0);
	signal read_register_2_instruction: bit_vector(4 downto 0);
	signal instruction: bit_vector(10 downto 0);
	signal fio_mux_bancoregistradores: bit_vector(4 downto 0);
	
	signal fio_read_data_1_ula:bit_vector(63 downto 0);
	signal fio_read_data_2_ula:bit_vector(63 downto 0);
	signal fio_sinal_extendido: bit_vector(63 downto 0);
	signal fio_mux_to_ula:bit_vector(63 downto 0);
	signal fio_resultado_ula:bit_vector(63 downto 0);
	
	signal fio_mux_to_write_data: bit_vector(63 downto 0);
	
	signal fio_dado_deslocado: bit_vector(63 downto 0);
	
	signal fio_alu_soma: bit_vector(63 downto 0);
	signal fio_alu_soma_quatro_bytes: bit_vector(63 downto 0);
	signal fio_PC: bit_vector(63 downto 0);
	signal fio_saida: bit_vector(63 downto 0);
	
	signal soma_alu: bit_vector(3 downto 0);
	signal soma_quatro: bit_vector(63 downto 0);
	
	
begin
	soma_alu<="0010";
	soma_quatro<="0000000000000000000000000000000000000000000000000000000000000100";
	
	write_register_instruction<=imOut(4 downto 0);
	read_register_1_instruction<=imOut(9 downto 5);
	read_register_2_instruction<=imOut(20 downto 16);
	instruction<=imOut(31 downto 21);
	
	dmIn<=fio_read_data_2_ula;
	opcode<=instruction;
	dmAddr<=fio_resultado_ula;
	imAddr<=fio_saida;
	
	registradores: banco_registradores
		port map(clock,reset,regWrite,read_register_1_instruction,fio_mux_bancoregistradores,write_register_instruction,
					fio_mux_to_write_data,fio_read_data_1_ula,fio_read_data_2_ula);
	
	mux_registradores: mux_5bits
		port map(read_register_2_instruction,write_register_instruction,reg2loc,fio_mux_bancoregistradores);
	
	Unidade_logica:alu
		port map(fio_read_data_1_ula,fio_mux_to_ula,fio_resultado_ula,aluCtrl,zero,open,open);
	
	mux_ula:mux_64bits
		port map(fio_read_data_2_ula,fio_sinal_extendido,aluSrc,fio_mux_to_ula);
	
	sinais:signExtend
		port map(imOut,fio_sinal_extendido);
	
	deslocador:shiftleft
		port map(clock,fio_sinal_extendido,fio_dado_deslocado);
	
	mux_memtoreg:mux_64bits
		port map(fio_resultado_ula,dmOut,memToReg,fio_mux_to_write_data);
	
	alu_soma: alu
		port map(fio_dado_deslocado,fio_saida,fio_alu_soma,soma_alu,open,open,open);
		
	multiplexador_das_ulas:mux_64bits
		port map(fio_alu_soma_quatro_bytes,fio_alu_soma,pcsrc,fio_PC);
		
	alu_soma_quatro_bytes: alu
		port map(fio_saida,soma_quatro,fio_alu_soma_quatro_bytes,soma_alu,open,open,open);
	
	PC:reg_contador
		port map(clock,reset,fio_PC,fio_saida);
		
end architecture fluxo_dados;
--###################################################################################################################
--############################################ DATAPATH END HERE ####################################################
--###################################################################################################################
