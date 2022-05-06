library ieee;
use ieee.numeric_bit.all;

library ieee;
use ieee.numeric_bit.all;
use std.textio.all;

entity ram16x4 is
  generic
  (
    data_file_name : string  := "ram.dat" --! arquivo com dados iniciais
  );
  port 
  (
    clock  : in  bit;
    addr   : in  bit_vector(63 downto 0);
    we     : in  bit;
    data_i : in  bit_vector(63 downto 0);
    data_o : out bit_vector(63 downto 0)
  );
end entity;

architecture behavioral of ram16x4 is

  type mem_type is array (0 to 255) of bit_vector(63 downto 0);

   --! Funcao para preenchimento da memoria com dados iniciais em arquivo
  impure function init_mem(file_name : in string) return mem_type is
    file     f       : text open read_mode is file_name;
    variable l       : line;
    variable tmp_bv  : bit_vector(63 downto 0);
    variable tmp_mem : mem_type;
  begin
    for i in mem_type'range loop
      readline(f, l);
      read(l, tmp_bv);
      tmp_mem(i) := tmp_bv;
    end loop;
    return tmp_mem;
  end;

  --! matriz de dados da memoria
  signal mem : mem_type := init_mem(data_file_name);

begin
  -- !escrita (sincrona) da memoria
  writeop: process(clock)
  begin
    if (clock='1' and clock'event) then
      if we='1' then
        mem(to_integer(unsigned(addr))) <= data_i;
      end if;
    end if;
  end process;
  -- !saida de dados da memoria
  data_o <= mem(to_integer(unsigned(addr)));

end architecture;






entity T6A1_tb is
end entity;

architecture tb of T6A1_tb is
	shared variable clock_end: boolean:=false;
	
	  component ram16x4
	  generic
	  (
		  data_file_name : string
	  );
	  port
	  (
		  clock  : in  bit;
		  addr   : in  bit_vector(63 downto 0);
		  we     : in  bit;
		  data_i : in  bit_vector(63 downto 0);
		  data_o : out bit_vector(63 downto 0)
	  );
	  end component;
	
	component polilegsc is
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
	end component;
	
	signal clock_in: bit;
	signal reset_in: bit;
	signal dmem_addr_out: bit_vector(63 downto 0);
	signal dmem_dati_out: bit_vector(63 downto 0);
	signal dmem_dato_in: bit_vector(63 downto 0);
	signal dmem_we_out: bit;
	signal imem_addr_out: bit_vector(63 downto 0);
	signal imem_data_in: bit_vector(31 downto 0);
	
	
    signal mem_we:         bit;
    signal mem_endereco:   bit_vector(63 downto 0);
    signal mem_dado_write: bit_vector(63 downto 0);
    signal mem_dado_read:  bit_vector(63 downto 0);
	signal clk_in:bit;

begin
	   clk_in <= (not clock_in);
	  
	  mem: ram16x4
       generic map
       ( 
         data_file_name => "ram.dat"
       )
       port map
       (
         clock=>  clock_in,
         addr=>   mem_endereco,
         we=>     mem_we,
         data_i=> mem_dado_write,
         data_o=> mem_dado_read
       );
	
	dut:polilegsc
		port map(clock_in,reset_in,dmem_addr_out,dmem_dati_out,dmem_dato_in,dmem_we_out,imem_addr_out,imem_data_in);

		clk: process is
		begin
			clock_in <= '0';
			wait for 0.5 ns;
			clock_in <= '1';
			wait for 0.5 ns;
			if(clock_end=true) then
				wait;
			end if;
	end process clk;
		
	stimulus:process is
	begin
	assert false report "simulation start" severity note;
	
	imem_data_in<="11111000010000000000001111100001";
	dmem_dato_in<="1000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="11111000010000001000001111100010";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000001001";
	wait for 1 ns;
	
	imem_data_in<="11111000010000010000001111100011";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000001111";
	wait for 1 ns;
	
	imem_data_in<="11001011000000110000000001000100";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="10110100000000000000000011100100";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="10001010000000010000000010000101";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="10110100000000000000000001100101";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="11001011000000100000000001100011";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="00010111111111111111111111111011";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="11001011000000110000000001000010";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="00010111111111111111111111111001";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="11111000000000001000001111100010";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="00010100000000000000000000000000";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="00000000000000000000000000000000";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="00000000000000000000000000000000";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;
	
	imem_data_in<="00000000000000000000000000000000";
	dmem_dato_in<="0000000000000000000000000000000000000000000000000000000000000000";
	wait for 1 ns;

	clock_end:=true;
	assert false report "Tudo certo" severity note;
	wait;
	end process;

end architecture;








	