# RISCV CPU by Verilog for study
- [RISCV CPU by Verilog for study](#riscv-cpu-by-verilog-for-study)
	- [usage](#usage)
	- [supported instruction(instruction detail see RISC-V-Reader)](#supported-instructioninstruction-detail-see-risc-v-reader)
	- [description for some files](#description-for-some-files)
		- ["rv32im\_cpu\_Design\_Sources"](#rv32im_cpu_design_sources)
		- ["rv32im\_cpu\_Simulation\_Sources"](#rv32im_cpu_simulation_sources)
		- ["machine\_code"](#machine_code)
	- [problems in design and solutions](#problems-in-design-and-solutions)
		- [如何设计控制器（Control Unit）？](#如何设计控制器control-unit)
		- [下降沿修改CU状态机，上升沿更新寄存器](#下降沿修改cu状态机上升沿更新寄存器)
		- [设计CU状态机时，一段式状态机有问题，改用三段式状态机](#设计cu状态机时一段式状态机有问题改用三段式状态机)
		- [指令与数据--冯诺依曼结构](#指令与数据--冯诺依曼结构)
		- [一个寄存器什么时候不需要reset端口？](#一个寄存器什么时候不需要reset端口)
		- [sel\_xxx 通过组合逻辑直接控制还是作为CU的一个状态？](#sel_xxx-通过组合逻辑直接控制还是作为cu的一个状态)
		- [如何判断一个多周期部件执行完了？](#如何判断一个多周期部件执行完了)
		- [多周期部件的初始化](#多周期部件的初始化)



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
4. (optional) you can modify machine/main.c, and re-compile
```
make clean
make
```

## supported instruction(instruction detail see RISC-V-Reader)
(https://www.cs.sfu.ca/~ashriram/Courses/CS295/assets/books/rvbook.pdf)
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
|filename|description|
|----|-------------|     
branch.v    |     branch unit          
riscv_core.v  |   Top file, assemble all other module
alu_op_decision.v    | decide to ues which op according to opcode
pc.v      |   program_counter
riscv_cu.v |    riscv-control-unit
grg.v       |         general_register_group(X0-X31)     
riscv_mem.v   | riscv-memory that contains program(mathine code) and data
branch_op_decision.v  | decide to use which op according to opcode
instruct_struct_spliter.v | ...
riscv_alu.v  | arithmetic_logic_unit
sra_I_32.v| shift_right_arithmetic

### "rv32im_cpu_Simulation_Sources"
...

### "machine_code"
|filename|description|
|----|-------------|
final_hex.txt|machine code in hex
init.s |initialize sp(stack pointer)
main.c |main c program that contains three function for test
makefile |...
process.py |used to generate final_hex.txt(detail see makefile)

## problems in design and solutions
### 如何设计控制器（Control Unit）？
CU控制功能部件在什么时钟做什么事情（CU不需要管功能部件如何完成这些事情）
CU是一个时序逻辑电路，发给部件的控制信号是CU的状态，先做什么，再做什么就是状态的迁移。

### 下降沿修改CU状态机，上升沿更新寄存器
例如addr_reg_WE=1，代表要往address regitser写入地址，为了使写入的时候addr_reg_WE已经为1，我选择在下降沿修改状态机，在上升沿更新寄存器

### 设计CU状态机时，一段式状态机有问题，改用三段式状态机
有问题的一段式状态机见/resouces/cu.v
问题在：case----LOAD_INST_2（第90行左右）
```verilog
			`LOAD_INST_2: begin
				pc_WE <= 0;
				addr_reg_WE <= 0;
				data_reg_WE <= 0;
				inst_reg_WE <= 1;
				grg_WE <= 0;
				mem_RE <= 0;
				mem_WE <= 0;
				case(opcode)
					7'b0110011 : state <= `EXEC_R;
					7'b0010011 : state <= `EXEC_RI;
					7'b0100011 : state <= `EXEC_S_0;
					7'b0000011 : state <= `EXEC_L_0;
					7'b1100011 : state <= `EXEC_B;
					7'b1101111 : state <= `EXEC_JAL;
					7'b1100111 : state <= `EXEC_JALR;
					7'b0110111 : state <= `EXEC_LUI;
					7'b0010111 : state <= `EXEC_AUIPC;
				endcase
```
这里想要进行状态跳转，跳转依赖opcode,但这时，指令还没有写入inst_reg(指令寄存器),因此无法跳转，导致状态机在 LOAD_INST_2 状态停留两次。

修改后的三段式状态机在/rv32i_cpu_Design_Sources/riscv_cu.v

三段式状态机解决上述问题的原因在于：三段式状态机的状态跳转是组合逻辑，状态更新和输出是时序逻辑。
一般如果状态机不依赖外部输入，可用一段式，否则，优先使用三段式。

### 指令与数据--冯诺依曼结构
我把代码和数据放到了同一个内存中了，代码在低地址空间,数据在高地址空间（由高地址向低地址生长的栈），因此初始的时候需要把sp指针指向高地址（例如我是在init.s文件中使用lui x2，0xff）

### 一个寄存器什么时候不需要reset端口？
当这个寄存器里的值总是被更新后再被使用，那就不需要reset端口。

### sel_xxx 通过组合逻辑直接控制还是作为CU的一个状态？
尽量通过组合逻辑直接控制，当发现组合逻辑出问题时再用CU控制（好像说了跟没说一样）

### 如何判断一个多周期部件执行完了？
如果这个部件的时钟周期只有1,2个，那可以用CU的state来区分执行到哪一个状态了；
如果有很多个时钟周期，可以让这个部件执行完的时候置一个finish标志位，CU只需要根据finish来决定是否跳转到下一个状态or等待部件继续执行。
mul,div,divu就是采用finish标志来标记执行结束的。

### 多周期部件的初始化
多周期部件需要初始化（mul,div,divu都有初始化周期），我采用了同步初始化。
mul（div,divu）一共需要34个时钟周期（1个时钟周期同步初始化，1个时钟周期部件初始化（把一些寄存器清0），32个时钟周期执行运算）（在第34个时钟周期将finish置1)