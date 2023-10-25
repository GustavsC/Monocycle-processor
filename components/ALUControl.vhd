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
