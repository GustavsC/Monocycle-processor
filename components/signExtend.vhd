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




	
