--Complete ALU

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
