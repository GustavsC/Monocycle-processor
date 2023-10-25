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
