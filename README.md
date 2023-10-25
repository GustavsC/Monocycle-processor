# Monocycle Processor
Monocycle processor (32 bits) in riscv architecture, made in VHDL and running in the GHDL 0.33 environment. Inspired in the processor LEGv8. 
## VHDL description of a monocycle processor

  - Data memory are not included in VHD files, it is inserted as ram.dat in testbench(completeProcessor_tb.vhd)
  - ram.dat (Data Memory) have 2KiB.
  - rom.dat (Instruction Memory) have 1 KiB.
  - "Read Data" in "data memory" is inserted directly in the processor through testbench "dmem_dato_in"
  - "Instruction" in "Instruction memory" is inserted directly in the processor through testbench "imem_data_in"

![InstructionTypes](https://user-images.githubusercontent.com/59322464/167226749-3e98f9ac-0cbc-418a-9572-9d75318cf995.png)

## Instructions available for use in the processor

Instructions with their respective opcodes, formats and effects:

| Instruction  | Effect/Meaning | Opcode | Format |
| ------------- | ------------- | ------------- | ------------- |
| LDUR  | Load a register with memory (ram.dat) content  | 11111000010 | Format D |
| STUR  | Store a register content in memory (ram.dat)  |11111000000|Format D|
| ADD  | Addition the content of two registers  | 10001011000 |Format R|
| SUB  | Subtracts the contents of two registers  | 11001011000 |Format R|
| AND  | Logical AND with the contents of two registers   | 10001010000 |Format R|
| ORR  | Logical OR  with the contents of two registers |10101010000|Format R|
| CBZ  | Compare And Branch on Zero  | 10110100 |Format CB|
| B  | Inconditional Branch |    000101 |Format B|

## Processor Datapath and Unit Control flow 

![Datapath_Control](https://github.com/GustavsC/Monocycle-processor/assets/59322464/f79fafb1-a07f-45a3-a457-9c9594f982d4)


Signals from the Control Unit and their respective effects within the data flow

![Control](https://github.com/GustavsC/Monocycle-processor/assets/59322464/c660b935-c0cf-47dd-9f4a-62b2fd0e9e9e)


## Rom.dat and Ram.dat
The rom.dat (Instruction Memory) and testbench (completeProcessor_tb.vhd) is loaded with a program:
![rom_program](https://github.com/GustavsC/Monocycle-processor/assets/59322464/2ddfaeeb-e448-45c7-b859-0ed168d4d0bf)


The ram.dat (Data Memory)  is loaded with 3 values, they are already implemented in the testbench (completeProcessor_tb.vhd).
