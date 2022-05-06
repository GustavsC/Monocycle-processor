# Monocycle-processor
VHDL description of a monocycle processor

- Instruction memory and Data memory are not included in VHD files, they are inserted as ram.dat in testbench

- "Read Data" in "data memory" is inserted directly in the processor through testbench "dmem_dato_in"
- "Instruction" in "Instruction memory" is inserted directly in the processor through testbench "imem_data_in"

![InstructionTypes](https://user-images.githubusercontent.com/59322464/167226749-3e98f9ac-0cbc-418a-9572-9d75318cf995.png)
