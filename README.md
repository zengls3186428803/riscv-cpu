# RISCV CPU by Verilog
- [RISCV CPU by Verilog](#riscv-cpu-by-verilog)
	- [Tools used during design and testing](#tools-used-during-design-and-testing)
	- [usage](#usage)
	- [supported instruction](#supported-instruction)
	- [description for some files](#description-for-some-files)
		- ["rv32im\_cpu\_Design\_Sources"](#rv32im_cpu_design_sources)
		- ["machine\_code"](#machine_code)

## Tools used during design and testing
|tool|download address|role|
|----|-------------|----|     
vivado|https://www.xilinx.com/support/download.html|Execute and simulate verilog programs
riscv-gnu-toolchain |https://github.com/riscv-collab/riscv-gnu-toolchain| Compile C language and assembly program into a binary program under the riscv instruction set architecture

## usage
1. git clone the project to your local machine
2. add "rv32im_cpu_Design_Sources" to vivado's "Design Sources"
3. modify a line in "rv32im_cpu_Simulation_Sources/tb.v"
modify the below path to your path
```
fptr = $fopen("/home/zengls/project_1/machine_code/final_ld.bin","r");
```
4. add "rv32im_cpu_Simulation_Sources" to vivado's "Simulation_Sources"


## supported instruction
```
lui,auipc,
jal,jalr,
beq,bne,blt,bge,bltu,bgeu
lb,lh,lw,lbu,lhu
sb,sh,sw
addi,slti,sltiu,xori,ori,andi,slli,srli,srai
add,sub,sll.slt,sltu,xor,srl,sra,or,and,
mul,mulh,mulhsu,mulhu,
div,divu,rem,remu
```
## description for some files
### "rv32im_cpu_Design_Sources"
|file|description|
|----|-------------|     
branch.v    |     branch unit          
riscv_core.v  |   Top file, assemble all other module
alu_op_decision.v    | decide to use which op according to opcode
pc.v      |   program_counter
riscv_cu.v |    riscv-control-unit
grg.v       |         general_register_group(X0-X31)     
riscv_mem.v   | riscv-memory that contains program(mathine code) and data
branch_op_decision.v  | decide to use which op according to opcode
riscv_alu.v  | arithmetic_logic_unit
sra_I_32.v| shift_right_arithmetic

### "machine_code"
|file|description|
|----|-------------|
final_hex.txt|machine code in hex
init.s |initialize sp(stack pointer)
main.c |main c program that contains three function for test
process.py |used to generate final_hex.txt(detail see makefile)
