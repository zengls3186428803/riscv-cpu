# RISCV CPU by Verilog
- [RISCV CPU by Verilog](#riscv-cpu-by-verilog)
	- [Tools used during design and testing](#tools-used-during-design-and-testing)
	- [usage](#usage)
	- [supported instruction](#supported-instruction)
	- [description for some files](#description-for-some-files)
		- ["rv32im\_cpu\_Design\_Sources"](#rv32im_cpu_design_sources)
		- ["machine\_code"](#machine_code)
	- [设计cpu过程中的问题与解决方法](#设计cpu过程中的问题与解决方法)
		- [如何设计控制器（Control Unit）？](#如何设计控制器control-unit)
		- [如何防止竞争冒险？](#如何防止竞争冒险)
		- [设计CU状态机时使用三段式状态机](#设计cu状态机时使用三段式状态机)
		- [指令与数据--冯诺依曼结构](#指令与数据--冯诺依曼结构)
		- [一个寄存器什么时候不需要reset端口？](#一个寄存器什么时候不需要reset端口)
		- [sel\_xxx(数据选择线) 通过组合逻辑直接控制还是作为CU的一个状态？](#sel_xxx数据选择线-通过组合逻辑直接控制还是作为cu的一个状态)
		- [如何判断一个多周期部件执行完了？](#如何判断一个多周期部件执行完了)
		- [多周期部件的初始化](#多周期部件的初始化)

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

## 设计cpu过程中的问题与解决方法
### 如何设计控制器（Control Unit）？
CU控制功能部件在什么时钟做什么事情（CU不需要管功能部件如何完成这些事情）。

CU是一个时序逻辑电路，发给部件的控制信号是CU的状态，“先做什么，再做什么“就是状态的迁移。

### 如何防止竞争冒险？
下降沿修改CU状态机，上升沿更新寄存器。

这样可以防止出现"WE还没来得及置位，数据上升（下降）沿就已经结束"

### 设计CU状态机时使用三段式状态机
三段式状态机的状态跳转是组合逻辑，状态更新是时序逻辑。

### 指令与数据--冯诺依曼结构
把代码和数据放到同一个内存中，代码在低地址空间,数据在高地址空间（由高地址向低地址生长的栈），因此初始的时候需要把sp指针指向高地址（在init.s文件中使用的lui x2，0xff）

### 一个寄存器什么时候不需要reset端口？
当这个寄存器里的值总是被更新后再被使用，那就不需要reset端口。

### sel_xxx(数据选择线) 通过组合逻辑直接控制还是作为CU的一个状态？
尽量通过组合逻辑直接控制。当一条指令使用多次“sel_xxx”时，组合逻辑无法控制了，就把选择信号作为CU的一个状态

### 如何判断一个多周期部件执行完了？
如果这个部件的时钟周期只有1,2个，那可以在CU内部记录执行到哪一个状态了；

如果有很多个时钟周期，可以让这个部件执行完的时候置一个finish标志位，CU只需要根据finish来决定是否跳转到下一个状态还是等待部件继续执行。
mul,div,divu就是采用finish标志来标记执行结束的。

### 多周期部件的初始化
多周期部件需要初始化（mul,div,divu都有初始化周期），我采用了同步初始化。
mul（div,divu）一共需要34个时钟周期（1个时钟周期同步初始化，1个时钟周期部件初始化（把一些寄存器清0），32个时钟周期执行运算）（在第34个时钟周期将finish置1）