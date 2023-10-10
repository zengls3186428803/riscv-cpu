	.file	"main.c"
	.option nopic
	.attribute arch, "rv32i2p1_m2p0"
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
	.globl	gcd
	.type	gcd, @function
gcd:
	addi	sp,sp,-32
	sw	ra,28(sp)
	sw	s0,24(sp)
	addi	s0,sp,32
	sw	a0,-20(s0)
	sw	a1,-24(s0)
	lw	a5,-24(s0)
	bne	a5,zero,.L4
	lw	a5,-20(s0)
	j	.L5
.L4:
	lw	a4,-20(s0)
	lw	a5,-24(s0)
	rem	a5,a4,a5
	mv	a1,a5
	lw	a0,-24(s0)
	call	gcd
	mv	a5,a0
.L5:
	mv	a0,a5
	lw	ra,28(sp)
	lw	s0,24(sp)
	addi	sp,sp,32
	jr	ra
	.size	gcd, .-gcd
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
	beq	a5,zero,.L7
	lw	a4,-20(s0)
	li	a5,1
	bne	a4,a5,.L8
.L7:
	li	a5,1
	j	.L9
.L8:
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
.L9:
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
	addi	sp,sp,-64
	sw	ra,60(sp)
	sw	s0,56(sp)
	addi	s0,sp,64
	sw	a0,-52(s0)
	sw	a1,-56(s0)
	li	a5,256
	sw	a5,-20(s0)
	li	a5,260
	sw	a5,-24(s0)
	li	a5,3
	sw	a5,-28(s0)
	li	a5,1
	sw	a5,-32(s0)
	lw	a1,-32(s0)
	lw	a0,-28(s0)
	call	sum
	sw	a0,-36(s0)
	lw	a5,-36(s0)
	mul	a5,a5,a5
	sw	a5,-36(s0)
	lw	a5,-36(s0)
	srai	a4,a5,31
	andi	a4,a4,3
	add	a5,a4,a5
	srai	a5,a5,2
	sw	a5,-36(s0)
	lw	a0,-36(s0)
	call	fib
	mv	a4,a0
	lw	a5,-20(s0)
	sw	a4,0(a5)
	li	a1,48
	li	a0,60
	call	gcd
	mv	a4,a0
	lw	a5,-24(s0)
	sw	a4,0(a5)
.L11:
	j	.L11
	.size	main, .-main
	.ident	"GCC: (g2ee5e430018) 12.2.0"
