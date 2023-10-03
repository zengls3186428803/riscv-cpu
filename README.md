# RISC CPU by Verilog for study

## usage
1. git-clone to your local computer 
```bash
git clone https://github.com/zengls3186428803/riscv-cpu.git
```
2. download vivado if you don't have, this is url for download vivado
```
https://www.xilinx.com/products/design-tools/vivado.html
```
3. (optional) download riscv-gnu-toolchain(please follow the README.md file for "riscv-gnu-toolchain")
```
https://github.com/riscv-collab/riscv-gnu-toolchain
```
4. (optional) you can modify machine/main.c, and remake final_hex.txt
```
make clean
make
```
5. modify rv32i_cpu_Design_Sources/riscv_mem file, change "/home/zengls/code/c/final_hex.txt" to /git-local-project-dir/machine_code/final_hex.txt
6. add rv32i_cpu_Design_Sources to Design Sources Directory in vivado,add rv32i_cpu_Simulation_Sources to Simulate Sources Directory
7. simulate (run tb.v) 
## description for directory and file
#### "rv32i_cpu_Design_Sources" is Design Sources(Verilog)
|--filename|description|
|----|-------------|
add_I_32.v |      adder in ALU         
branch.v    |     branch unit          
or_I_32.v    |    or in ALU
riscv_core.v  |   Top file, assemble all other module
sll_I_32.v   | shift_left_logic in ALU
srl_I_32.v|    shift_right_logic
alu_op_decision.v    | decide to ues which op according to opcode
bufif1_n.v            |     ...
pc.v      |   program_counter
riscv_cu.v |    riscv-control-unit
slt_I_32.v  | set_less_than
sub_I_32.v| sub in ALU
and_I_32.v |          and in ALU 
grg.v       |         general_register_group(X0-X31)     
register.v   |    ...
riscv_mem.v   | riscv-memory that contains program(mathine code) and data
sltu_I_32.v  | set_less_than_unsigned
xor_I_32.v| xor in ALU
branch_op_decision.v  | decide to use which op according to opcode
instruct_struct_spliter.v | ...
riscv_alu.v  | arithmetic_logic_unit
sign_extend.v | ...
sra_I_32.v| shift_right_arithmetic


relationship of modules
![](./resources/d_s.png)
#### "rv32i_cpu_Simulation_Sources" is Simluation Sources(testbench)
...
#### "machine_code"
|--filename|description|
|----|-------------|
final_hex.txt|machine code in hex
init.s |initialize sp(stack pointer)
main.c |main c program that contains three function for test
makefile |...
process.py |used to generate final_hex.txt(detail see makefile)