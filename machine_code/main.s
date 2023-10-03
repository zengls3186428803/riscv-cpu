	.file	"main.c"
	.option nopic
	.attribute arch, "rv32i2p1"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	sum
	.type	sum, @function
sum:
	addi	sp,sp,-32
	sw	s0,28(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	add	a5,a4,a5
	mv	a0,a5
	lw	s0,28(sp)
	addi	sp,sp,32
	jr	ra
	.size	sum, .-sum
	.align	2
	.globl	fib
	.type	fib, @function
fib:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	sw	s1,20(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	lw	a5,-20(s0)
	beq	a5,zero,.L4
	lw	a4,-20(s0)
	li	a5,1
	bne	a4,a5,.L5
.L4:
	li	a5,1
	j	.L6
.L5:
	lw	a5,-20(s0)
	addi	a5,a5,-1
	mv	a0,a5
	call	fib
	mv	s1,a0
	lw	a5,-20(s0)
	addi	a5,a5,-2
	mv	a0,a5
	call	fib
	mv	a5,a0
	add	a5,s1,a5
.L6:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	lw	s1,20(sp)
	addi	sp,sp,32
	jr	ra
	.size	fib, .-fib
	.align	2
	.globl	main
	.type	main, @function
main:
	addi	sp,sp,-48
	sw	ra,44(sp)
	sw	s0,40(sp)
	addi	s0,sp,48
	sw	a0,-36(s0)
	sw	a1,-40(s0)
	li	a5,256
	sw	a5,-20(s0)
	li	a5,3
	sw	a5,-24(s0)
	li	a5,1
	sw	a5,-28(s0)
	lw	a1,-28(s0)
	lw	a0,-24(s0)
	call	sum
	sw	a0,-32(s0)
	lw	a0,-32(s0)
	call	fib
	mv	a4,a0
	lw	a5,-20(s0)
	sw	a4,0(a5)
.L8:
	j	.L8
	.size	main, .-main
	.ident	"GCC: (g2ee5e430018) 12.2.0"
