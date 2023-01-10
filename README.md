# risc-v-cpu-logic
## 所用软件
logisim-evolution

## 参考资料
《数字电子技术基础》阎石  第五版.pdf
RISC-V-Reader-Chinese-v2p1.pdf
计算机组成原理 唐朔飞 第三版

## 原则
一开始尽量使用较简单的元件，
然后在确定自己有能力制作出复杂元件的情况下，大胆地使用软件里提供的复杂元件

## 文件说明
my_CPU.circ 为主要文件
cu.ods 包含控制整个cpu的时序状态转换表
my_ALU.circ 包含一些简单计算功能的电路
my_memory.circ 包含一些具有存储功能的电路

## ？
1.logisim-evolution 不支持20个输入（变量）以上的电路自动生成功能。但是时序逻辑转换图里包含23个变量，cu.ods里的表虽然不大，但手动设计时序逻辑发生器仍需要很多时间，所以就放弃了。
2.只尝试实现了 “RISC-V-Reader-Chinese-v2p1.pdf”的第27页所描述的前37条指令（共47条，后10条没有尝试实现）