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
