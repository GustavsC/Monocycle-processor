library ieee;
use ieee.numeric_bit.all;

entity banco_registradores is
	port(
		clock: in bit;
		reset: in bit;
		regWrite: in bit;
		read_register_1, read_register_2, write_register:in bit_vector(4 downto 0);
		write_data: in bit_vector(63 downto 0);
		read_data_1,read_data_2: out bit_vector(63 downto 0)
	);
end banco_registradores;

architecture registrador_grande of banco_registradores is
	type memoria is array (0 to 31) of bit_vector(63 downto 0);
signal mem : memoria;
begin
	read_data_1<=mem(to_integer(unsigned(read_register_1)));
	read_data_2<=mem(to_integer(unsigned(read_register_2)));
process(clock)
	variable teste: unsigned(4 downto 0):= (others=>'1');
begin
	if((rising_edge(clock) and regWrite='1') and unsigned(write_register)/=teste) then
		mem(to_integer(unsigned(write_register)))<=write_data;
	end if;
	if(reset='1') then
		for i in 0 to 30 loop
			mem(i)<=(others=>'0');
		end loop;
	end if;
end process;
end architecture;

---------------------------------------------------------ULA-------------------------------------------------------
---------------------------------------------------------ULA-------------------------------------------------------
---------------------------------------------------------ULA-------------------------------------------------------
---------------------------------------------------------ULA-------------------------------------------------------
---------------------------------------------------------ULA-------------------------------------------------------
---------------------------------------------------------ULA-------------------------------------------------------
entity fulladder is
port(
	a,b,cin: in bit;
	s,cout: out bit
	);
end entity;

architecture somador of fulladder is
begin
	s<=((not(cin) and (a xor b)) or (cin and ((not(a) and not(b)) or (a and b))));
	cout<= ((a and b) or (cin and (a or b)));
end architecture;
----------------------------------------------------------------------------------------------------
entity somador_completo is
port(
	a,b: in bit_vector(63 downto 0);
	cin: in bit;
	saida: out bit_vector(63 downto 0);
	cout: out bit
);
end entity;

architecture complete_sum of somador_completo is
	
	component fulladder is
	port(
		a,b,cin: in bit;
		s,cout: out bit
		);
	end component;
	
	signal fio:bit_vector(63 downto 0);
begin
	primeira_passo: fulladder
		port map(a(0),b(0),cin,saida(0),fio(0));
	
	gen_fulladder:
	for I in 1 to 63 generate
		adicao:fulladder
			port map(a(I),b(I),fio(I-1),saida(I),fio(I));
	end generate gen_fulladder;
	cout<=fio(63);
end architecture;
--------------------------------------------------------------------------------------------------------------------
entity logica is
port(
	A_logico,B_logico: in bit_vector(63 downto 0);
	porta_nor: in bit;
	A_and_B, A_or_B: out bit_vector(63 downto 0)
	);
end entity;

architecture logicas of logica is
	component mux_2to1 is
	port(
		entrada,entrada_negada: in bit_vector(63 downto 0);
		seletor: in bit;
		saida: out bit_vector(63 downto 0)
		);
    end component mux_2to1;
	
	signal fio_A_nor_B: bit_vector(63 downto 0);
	signal fio_A_or_B: bit_vector(63 downto 0);
	
begin
	fio_A_or_B<= A_logico or B_logico;
	fio_A_nor_B<=A_logico and B_logico;
	
	A_and_B<=A_logico and B_logico;
	
	Nor_or: mux_2to1
		port map(fio_A_or_B,fio_A_nor_B,porta_nor,A_or_B);
	
	--A_or_B <= A_logico or B_logico;
end architecture;
-----------------------------------------------------------------------------------------------------------------
entity mux_2to1 is
port(
	entrada,entrada_negada: in bit_vector(63 downto 0);
	seletor: in bit;
	saida: out bit_vector(63 downto 0)
	);
end entity;

architecture selecao of mux_2to1 is
begin
	with seletor select
		saida<=entrada when '0',
			   entrada_negada when '1';
end architecture;	

----------------------------------------------------------------------------------------------------------------------
entity negador is
port(
	entrada: in bit_vector(63 downto 0);
	saida: out bit_vector(63 downto 0)
	);
end entity;

architecture nao of negador is
begin
	saida<=not(entrada);
end architecture;
------------------------------------------------------------------------------------------------------------------
entity mux_4to1 is
port(
	entrada_and,entrada_or,entrada_soma,entrada_SLT: in bit_vector(63 downto 0);
	seletor: in bit_vector(1 downto 0);
	saida: out bit_vector(63 downto 0)
	);
end entity;	

architecture contas of mux_4to1 is
begin
	with seletor select
	saida<= entrada_and when "00",
			entrada_or when "01",
			entrada_soma when "10",
			entrada_SLT when "11";
end architecture;
------------------------------------------------------------------------------------------------------------------
entity det_overflow is
port(
	a,b,soma: in bit;
	over: out bit
	);
end entity;

architecture agrsim of det_overflow is
begin
	over<=(((a and b) and not(soma)) or (soma and (not(a) and not(b))));
end architecture;
------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity maior is
port(
	 A, B: in bit_vector(63 downto 0);
	 maior_saida: out bit_vector(63 downto 0)
);
end entity;

architecture B_maior_A of maior is
begin
	process(A,B)
		variable testeA:unsigned(63 downto 0);
		variable testeB:unsigned(63 downto 0);
	begin
		testeA:=unsigned(A);
		testeB:=unsigned(B);
		if(testeB>testeA) then
			maior_saida(0)<='1';
		else
			maior_saida(0)<='0';
		end if;
	end process;
end architecture;
------------------------------------------------------------------------------------------------------------------
library ieee;
use ieee.numeric_bit.all;

entity det_zero is
port(
	a_mais_b: in bit_vector(63 downto 0);
	zero: out bit
);
end entity;

architecture det of det_zero is
begin
	process(a_mais_b)
		variable comparador: signed(63 downto 0):=(others=>'0');
		variable a_mais_b_signed: signed (63 downto 0);
	begin
		a_mais_b_signed:=signed(a_mais_b);
		if(a_mais_b_signed=comparador) then
			zero<='1';
		else
			zero<='0';
		end if;
	end process;
end architecture;
	

------------------------------------------------------------------------------------------------------------------
entity alu is
port(
	A, B: in bit_vector(63 downto 0); --inputs
	F: out bit_vector(63 downto 0 ) ; --output
	S: in bit_vector(3 downto 0 ) ; --opselection
	Z: out bit; --zeroflag
	Ov: out bit; -- overflowflag
	Co: out bit --carryout
	);
end entity alu;

architecture logica of alu is
	component negador is
	port(
		entrada: in bit_vector(63 downto 0);
		saida: out bit_vector(63 downto 0)
	);
	end component negador;
	
	component mux_2to1 is
	port(
		entrada,entrada_negada: in bit_vector(63 downto 0);
		seletor: in bit;
		saida: out bit_vector(63 downto 0)
		);
	end component mux_2to1;
	
	component logica is
	port(
		A_logico,B_logico: in bit_vector(63 downto 0);
		porta_nor: in bit;
		A_and_B, A_or_B: out bit_vector(63 downto 0)
		);
	end component;
	
	component mux_4to1 is
	port(
		entrada_and,entrada_or,entrada_soma,entrada_SLT: in bit_vector(63 downto 0);
		seletor: in bit_vector(1 downto 0);
		saida: out bit_vector(63 downto 0)
		);
	end component mux_4to1;	
	
	component somador_completo is
	port(
			a,b: in bit_vector(63 downto 0);
			cin: in bit;
			saida: out bit_vector(63 downto 0);
			cout: out bit
		);
	end component somador_completo;

	component det_overflow is
	port(
		a,b,soma: in bit;
		over: out bit
		);
	end component det_overflow;
	
	component det_zero is
	port(
		a_mais_b: in bit_vector(63 downto 0);
		zero: out bit
	);
	end component det_zero;
	
	component maior is
	port(
		 A, B: in bit_vector(63 downto 0);
		 maior_saida: out bit_vector(63 downto 0)
	);
	end component maior;
	
	signal ainvert: bit;
	signal binvert: bit;
	signal ccomplemento: bit;
	signal operacao: bit_vector(1 downto 0);
	signal fio_entrada_A_negada: bit_vector(63 downto 0);
	signal fio_entrada_B_negada:bit_vector(63 downto 0);
	signal fio_A:bit_vector(63 downto 0);
	signal fio_B:bit_vector(63 downto 0);
	signal fio_A_and_B:bit_vector(63 downto 0);
	signal fio_A_or_B:bit_vector(63 downto 0);
	signal fio_A_mais_B: bit_vector(63 downto 0);
	signal fio_A_menor_B: bit_vector(63 downto 0);
	signal fio_porta_nor: bit;
	signal F_fio: bit_vector(63 downto 0);
	
begin
	ainvert<=S(3);
	binvert<=S(2);
	operacao<= S(1) & S(0);
	ccomplemento<= S(3) or S(2);
	
	fio_porta_nor<=S(3) and S(2);
	
	Entrada_inicial_A: negador
		port map(A,fio_entrada_A_negada);
	
	Entrada_inicial_B: negador
		port map(B, fio_entrada_B_negada);
	
	Entrada_A:mux_2to1
		port map(A,fio_entrada_A_negada,ainvert,fio_A);
	
	Entrada_B: mux_2to1
		port map(B,fio_entrada_B_negada,binvert,fio_B);
	
	And_OR_A_B: logica
		port map(fio_A,fio_B,fio_porta_nor,fio_A_and_B,fio_A_or_B);
	
	Soma_A_B: somador_completo
		port map(fio_A,fio_B,ccomplemento,fio_A_mais_B,Co);
	
	Saidas_logicas: mux_4to1
		port map(fio_A_and_B,fio_A_or_B,fio_A_mais_B,B,operacao,F_fio);
	
	Check_over:det_overflow
		port map(fio_A(63),fio_B(63),fio_A_mais_B(63),Ov);
		
	maior_menor: maior
		port map(fio_A,fio_B,fio_A_menor_B);
	
	zero: det_zero
		port map(F_fio,Z);
	
	F<=F_fio;
		
end architecture;
---------------------------------------------------------ULA-------------------------------------------------------
---------------------------------------------------------ULA-------------------------------------------------------
---------------------------------------------------------ULA-------------------------------------------------------
---------------------------------------------------------ULA-------------------------------------------------------
---------------------------------------------------------ULA-------------------------------------------------------
---------------------------------------------------------ULA-------------------------------------------------------
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
entity decodificador is
	port (
		entrada: in bit_vector(31 downto 0);
		saida_B: out bit_vector(25 downto 0);
		saida_CBZ: out bit_vector(18 downto 0);
		saida_D: out bit_vector(8 downto 0)
	);
end decodificador;

architecture dec of decodificador is
begin
	saida_B<=entrada(25 downto 0);
	saida_CBZ<=entrada(23 downto 5);
	saida_D<=entrada(20 downto 12);
end architecture;

entity demux_generic is
	port(
		entrada_B:in bit_vector(63 downto 0);
		entrada_CBZ:in bit_vector(63 downto 0);
		entrada_D:in bit_vector(63 downto 0);
		seletor: in bit_vector(31 downto 0);
		saida:out bit_vector(63 downto 0)
	);
end demux_generic;

architecture selecao of demux_generic is
begin
	with seletor(31 downto 26) select
	saida<= entrada_B when "000101",
			entrada_CBZ when "101101",
			entrada_D when "111110",
			"0000000000000000000000000000000000000000000000000000000000000000" when others;
		
			
end architecture;

entity extensao_real is
	port(
		entrada_B: in bit_vector(25 downto 0);
		entrada_CBZ:in bit_vector(18 downto 0);
		entrada_D:in bit_vector(8 downto 0);
		saida_B: out bit_vector(63 downto 0);
		saida_CBZ: out bit_vector(63 downto 0);
		saida_D: out bit_vector(63 downto 0)
	);
end extensao_real;

architecture extensao of extensao_real is
begin
	saida_B(25 downto 0)<=entrada_B;
	saida_B(63 downto 26)<=(others=>entrada_B(25));
	
	saida_CBZ(18 downto 0)<= entrada_CBZ;
	saida_CBZ(63 downto 19)<=(others=>entrada_CBZ(18));
	
	saida_D(8 downto 0)<=entrada_D;
	saida_D(63 downto 9)<=(others=>entrada_D(8));
end architecture;
		
	
entity signExtend is
	port(
		i:in bit_vector(31 downto 0); --input
		o:out bit_vector(63 downto 0) --output
	);
end signExtend;

architecture sinal of signExtend is
	
	component decodificador is
	port (
		entrada: in bit_vector(31 downto 0);
		saida_B: out bit_vector(25 downto 0);
		saida_CBZ: out bit_vector(18 downto 0);
		saida_D: out bit_vector(8 downto 0)
	);
	end component;
	
	
	component extensao_real is
	port(
		entrada_B: in bit_vector(25 downto 0);
		entrada_CBZ:in bit_vector(18 downto 0);
		entrada_D:in bit_vector(8 downto 0);
		saida_B: out bit_vector(63 downto 0);
		saida_CBZ: out bit_vector(63 downto 0);
		saida_D: out bit_vector(63 downto 0)
	);
	end component;

	component demux_generic is
		port(
			entrada_B:in bit_vector(63 downto 0);
			entrada_CBZ:in bit_vector(63 downto 0);
			entrada_D:in bit_vector(63 downto 0);
			seletor: in bit_vector(31 downto 0);
			saida:out bit_vector(63 downto 0)
		);
	end component;
	
	signal fio_sinal_separado_B: bit_vector(25 downto 0);
	signal fio_sinal_separado_CBZ:bit_vector(18 downto 0);
	signal fio_sinal_separado_D: bit_vector(8 downto 0);
	signal fio_B: bit_vector(63 downto 0);
	signal fio_CBZ: bit_vector(63 downto 0);
	signal fio_D: bit_vector(63 downto 0);
begin
	
	separador:decodificador
		port map(i,fio_sinal_separado_B,fio_sinal_separado_CBZ,fio_sinal_separado_D);
	
	sinal_extendido: extensao_real
		port map(fio_sinal_separado_B,fio_sinal_separado_CBZ,fio_sinal_separado_D,fio_B,fio_CBZ,fio_D);
	
	demux_final:demux_generic
		port map(fio_B,fio_CBZ,fio_D,i,o);
		
end architecture;


entity alucontrol is
	port(
		aluop: in bit_vector(1 downto 0);
		opcode: in bit_vector(10 downto 0);
		aluCtrl: out bit_vector(3 downto 0)
	);
end entity;

architecture controle of alucontrol is
begin
	process(aluop,opcode)
	begin
		 case aluop is
			when "00" => 
				aluCtrl<="0010";
			when "01"=>
				aluCtrl<="0111";
			when "10" =>
				case opcode is
					when "10001011000"=>
						aluCtrl<="0010";
					when "11001011000"=>
						aluCtrl<="0110";
					when "10001010000"=>
						aluCtrl<="0000";
					when "10101010000"=>
						aluCtrl<="0001";
					when others=>
						aluCtrl<="1111";
					end case;
			when others=>
				aluCtrl<="1111";
			end case;
	end process;
end architecture;
						


entity controlunit is
	port(
		--To datapath
		reg2loc: out bit;
		uncondBranch :out bit;
		branch: out bit;
		memRead: out bit;
		memToReg: out bit;
		aluOp: out bit_vector(1 downto 0 ) ;
		memWrite: out bit;
		aluSrc: out bit;
		regWrite: out bit;
		--FromDatapath
		opcode: in bit_vector(10 downto 0)
);
end entity;

architecture controle of controlunit is
begin
	process(opcode)
	begin
		case opcode(10 downto 5) is
			when "100010" | "110010"| "101010" => --Formato R
				case opcode(4 downto 0) is
				when "11000" | "10000" => 	
					reg2loc<='0';
					uncondBranch<='0';
					branch<='0';
					memRead<='0';
					memToReg<='0';
					aluOp<="10";
					memWrite<='0';
					aluSrc<='0';
					regWrite<='1';
				when others=>
					reg2loc<='0';
					uncondBranch<='0';
					branch<='0';
					memRead<='0';
					memToReg<='0';
					aluOp<="00";
					memWrite<='0';
					aluSrc<='0';
					regWrite<='0';
				end case;
			when "111110" =>           --LDUR
				case opcode(4 downto 0) is
				when "00010" =>
					reg2loc<='1';
					uncondBranch<='0';
					branch<='0';
					memRead<='1';
					memToReg<='1';
					aluOp<="00";
					memWrite<='0';
					aluSrc<='1';
					regWrite<='1';
			
				when "00000"=> --SDUR
					reg2loc<='1';
					uncondBranch<='0';
					branch<='0';
					memRead<='0';
					memToReg<='1';
					aluOp<="00"; --Tem erro no slide
					memWrite<='1';
					aluSrc<='1';
					regWrite<='0';
				
				when others =>
				reg2loc<='0';
				uncondBranch<='0';
				branch<='0';
				memRead<='0';
				memToReg<='0';
				aluOp<="00";
				memWrite<='0';
				aluSrc<='0';
				regWrite<='0';
				end case;
	
			when "101101"=> --CBZ
				case opcode(3) is
					when '0' =>
						reg2loc<='1';
						uncondBranch<='0';
						branch<='1';
						memRead<='0';
						memToReg<='1';
						aluOp<="01";
						memWrite<='0';
						aluSrc<='0';
						regWrite<='0';
					when others => 
						reg2loc<='0';
						uncondBranch<='0';
						branch<='0';
						memRead<='0';
						memToReg<='0';
						aluOp<="00";
						memWrite<='0';
						aluSrc<='0';
						regWrite<='0';
					end case;
			
			when "000101"=>  --Branch
				reg2loc<='1';
				uncondBranch<='1';
				branch<='0';
				memRead<='0';
				memToReg<='1';
				aluOp<="00";
				memWrite<='0';
				aluSrc<='0';
				regWrite<='0';
			when others =>
				reg2loc<='0';
				uncondBranch<='0';
				branch<='0';
				memRead<='0';
				memToReg<='0';
				aluOp<="00";
				memWrite<='0';
				aluSrc<='0';
				regWrite<='0';
		end case;
	end process;
end architecture;

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
