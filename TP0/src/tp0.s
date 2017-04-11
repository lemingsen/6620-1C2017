	.file	1 "tp0.c"
	.section .mdebug.abi32
	.previous
	.abicalls
	.rdata
	.align	2
$LC0:
	.ascii	"Error al decodificar\n\000"
	.text
	.align	2
	.globl	error
	.ent	error
error:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	la	$a0,__sF+176
	la	$a1,$LC0
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
	.end	error
	.size	error, .-error
	.rdata
	.align	2
$LC1:
	.ascii	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123"
	.ascii	"456789+/\000"
	.text
	.align	2
	.globl	indexOf
	.ent	indexOf
indexOf:
	.frame	$fp,56,$ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$ra,48($sp)
	sw	$fp,44($sp)
	sw	$gp,40($sp)
	move	$fp,$sp
	move	$v0,$a0
	sb	$v0,24($fp)
	sw	$zero,28($fp)
$L19:
	lw	$v0,28($fp)
	slt	$v0,$v0,64
	bne	$v0,$zero,$L22
	b	$L20
$L22:
	lw	$v1,28($fp)
	la	$v0,$LC1
	addu	$v0,$v1,$v0
	lbu	$v0,0($v0)
	sb	$v0,32($fp)
	lb	$v1,32($fp)
	lb	$v0,24($fp)
	bne	$v1,$v0,$L21
	lw	$v0,28($fp)
	sw	$v0,36($fp)
	b	$L18
$L21:
	lw	$v0,28($fp)
	addu	$v0,$v0,1
	sw	$v0,28($fp)
	b	$L19
$L20:
	la	$t9,error
	jal	$ra,$t9
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,36($fp)
$L18:
	lw	$v0,36($fp)
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	indexOf
	.size	indexOf, .-indexOf
	.globl	count
	.globl	count
	.section	.bss
	.align	2
	.type	count, @object
	.size	count, 4
count:
	.space	4
	.globl	linecount
	.globl	linecount
	.align	2
	.type	linecount, @object
	.size	linecount, 4
linecount:
	.space	4
	.globl	acum
	.globl	acum
	.align	2
	.type	acum, @object
	.size	acum, 4
acum:
	.space	4
	.globl	length
	.globl	length
	.align	2
	.type	length, @object
	.size	length, 4
length:
	.space	4
	.text
	.align	2
	.globl	doEncode
	.ent	doEncode
doEncode:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	sw	$a0,40($fp)
	lw	$v0,acum
	sll	$v1,$v0,1
	lw	$v0,40($fp)
	or	$v0,$v1,$v0
	sw	$v0,acum
	lw	$v0,count
	addu	$v0,$v0,1
	sw	$v0,count
	lw	$v1,count
	li	$v0,6			# 0x6
	bne	$v1,$v0,$L24
	lw	$v0,length
	addu	$v0,$v0,1
	sw	$v0,length
	lw	$v0,linecount
	addu	$v0,$v0,1
	sw	$v0,linecount
	lw	$v1,acum
	la	$v0,$LC1
	addu	$v0,$v1,$v0
	lb	$v0,0($v0)
	move	$a0,$v0
	la	$a1,__sF+88
	la	$t9,__sputc
	jal	$ra,$t9
	lw	$v1,linecount
	li	$v0,76			# 0x4c
	bne	$v1,$v0,$L26
	li	$a0,10			# 0xa
	la	$a1,__sF+88
	la	$t9,__sputc
	jal	$ra,$t9
	sw	$zero,linecount
$L26:
	sw	$zero,count
	sw	$zero,acum
$L24:
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	doEncode
	.size	doEncode, .-doEncode
	.align	2
	.globl	encode64
	.ent	encode64
encode64:
	.frame	$fp,56,$ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$ra,48($sp)
	sw	$fp,44($sp)
	sw	$gp,40($sp)
	move	$fp,$sp
	sw	$a0,56($fp)
	sw	$a1,60($fp)
	sw	$zero,24($fp)
$L28:
	lw	$v0,24($fp)
	lw	$v1,60($fp)
	sltu	$v0,$v0,$v1
	bne	$v0,$zero,$L31
	b	$L27
$L31:
	lw	$v1,56($fp)
	lw	$v0,24($fp)
	addu	$v0,$v1,$v0
	lbu	$v0,0($v0)
	sb	$v0,32($fp)
	li	$v0,7			# 0x7
	sw	$v0,28($fp)
$L32:
	lw	$v0,28($fp)
	bgez	$v0,$L35
	b	$L30
$L35:
	lb	$v1,32($fp)
	lw	$v0,28($fp)
	sra	$v0,$v1,$v0
	andi	$v0,$v0,0x1
	move	$a0,$v0
	la	$t9,doEncode
	jal	$ra,$t9
	lw	$v0,28($fp)
	addu	$v0,$v0,-1
	sw	$v0,28($fp)
	b	$L32
$L30:
	lw	$v0,24($fp)
	addu	$v0,$v0,1
	sw	$v0,24($fp)
	b	$L28
$L27:
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	encode64
	.size	encode64, .-encode64
	.align	2
	.globl	doDecode
	.ent	doDecode
doDecode:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	sw	$a0,40($fp)
	lw	$v0,acum
	sll	$v1,$v0,1
	lw	$v0,40($fp)
	or	$v0,$v1,$v0
	sw	$v0,acum
	lw	$v0,count
	addu	$v0,$v0,1
	sw	$v0,count
	lw	$v1,count
	li	$v0,8			# 0x8
	bne	$v1,$v0,$L36
	lw	$v0,length
	addu	$v0,$v0,1
	sw	$v0,length
	lw	$a0,acum
	la	$a1,__sF+88
	la	$t9,__sputc
	jal	$ra,$t9
	sw	$zero,count
	sw	$zero,acum
$L36:
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	doDecode
	.size	doDecode, .-doDecode
	.align	2
	.globl	decode64
	.ent	decode64
decode64:
	.frame	$fp,56,$ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$ra,48($sp)
	sw	$fp,44($sp)
	sw	$gp,40($sp)
	move	$fp,$sp
	sw	$a0,56($fp)
	sw	$a1,60($fp)
	sw	$zero,24($fp)
$L39:
	lw	$v0,24($fp)
	lw	$v1,60($fp)
	sltu	$v0,$v0,$v1
	beq	$v0,$zero,$L38
	lw	$v1,56($fp)
	lw	$v0,24($fp)
	addu	$v0,$v1,$v0
	lb	$v1,0($v0)
	li	$v0,61			# 0x3d
	bne	$v1,$v0,$L42
	b	$L38
$L42:
	lw	$v1,56($fp)
	lw	$v0,24($fp)
	addu	$v0,$v1,$v0
	lb	$v1,0($v0)
	li	$v0,10			# 0xa
	beq	$v1,$v0,$L41
	lw	$v1,56($fp)
	lw	$v0,24($fp)
	addu	$v0,$v1,$v0
	lb	$v0,0($v0)
	move	$a0,$v0
	la	$t9,indexOf
	jal	$ra,$t9
	sw	$v0,36($fp)
	lbu	$v0,36($fp)
	sb	$v0,32($fp)
	li	$v0,5			# 0x5
	sw	$v0,28($fp)
$L45:
	lw	$v0,28($fp)
	bgez	$v0,$L48
	b	$L41
$L48:
	lb	$v1,32($fp)
	lw	$v0,28($fp)
	sra	$v0,$v1,$v0
	andi	$v0,$v0,0x1
	move	$a0,$v0
	la	$t9,doDecode
	jal	$ra,$t9
	lw	$v0,28($fp)
	addu	$v0,$v0,-1
	sw	$v0,28($fp)
	b	$L45
$L41:
	lw	$v0,24($fp)
	addu	$v0,$v0,1
	sw	$v0,24($fp)
	b	$L39
$L38:
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	decode64
	.size	decode64, .-decode64
	.align	2
	.globl	process
	.ent	process
process:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	sw	$a0,40($fp)
	sw	$a1,44($fp)
	sw	$a2,48($fp)
	lw	$v0,40($fp)
	beq	$v0,$zero,$L50
	lw	$a0,44($fp)
	lw	$a1,48($fp)
	la	$t9,encode64
	jal	$ra,$t9
	b	$L49
$L50:
	lw	$a0,44($fp)
	lw	$a1,48($fp)
	la	$t9,decode64
	jal	$ra,$t9
$L49:
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	process
	.size	process, .-process
	.align	2
	.globl	closeProcess
	.ent	closeProcess
closeProcess:
	.frame	$fp,56,$ra		# vars= 16, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,56
	.cprestore 16
	sw	$ra,48($sp)
	sw	$fp,44($sp)
	sw	$gp,40($sp)
	move	$fp,$sp
	sw	$a0,56($fp)
	lw	$v0,56($fp)
	beq	$v0,$zero,$L53
	lw	$v0,count
	slt	$v0,$v0,6
	beq	$v0,$zero,$L53
	lw	$v0,count
	blez	$v0,$L53
$L55:
	lw	$v0,count
	bne	$v0,$zero,$L57
	b	$L56
$L57:
	move	$a0,$zero
	la	$t9,doEncode
	jal	$ra,$t9
	b	$L55
$L56:
	sw	$zero,24($fp)
$L58:
	lw	$v0,length
	sw	$v0,28($fp)
	lw	$v1,28($fp)
	sw	$v1,32($fp)
	lw	$a0,32($fp)
	bgez	$a0,$L62
	lw	$v0,32($fp)
	addu	$v0,$v0,3
	sw	$v0,32($fp)
$L62:
	lw	$v1,32($fp)
	sra	$v0,$v1,2
	sll	$v0,$v0,2
	lw	$a0,28($fp)
	subu	$v1,$a0,$v0
	li	$v0,4			# 0x4
	subu	$v1,$v0,$v1
	lw	$v0,24($fp)
	slt	$v0,$v0,$v1
	bne	$v0,$zero,$L61
	b	$L53
$L61:
	li	$a0,61			# 0x3d
	la	$a1,__sF+88
	la	$t9,__sputc
	jal	$ra,$t9
	lw	$v0,24($fp)
	addu	$v0,$v0,1
	sw	$v0,24($fp)
	b	$L58
$L53:
	la	$a0,__sF+88
	la	$t9,fflush
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,48($sp)
	lw	$fp,44($sp)
	addu	$sp,$sp,56
	j	$ra
	.end	closeProcess
	.size	closeProcess, .-closeProcess
	.rdata
	.align	2
$LC2:
	.ascii	"rb\000"
	.align	2
$LC3:
	.ascii	"Can't open input file\n\000"
	.text
	.align	2
	.globl	openInFile
	.ent	openInFile
openInFile:
	.frame	$fp,48,$ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$ra,40($sp)
	sw	$fp,36($sp)
	sw	$gp,32($sp)
	move	$fp,$sp
	sw	$a0,48($fp)
	lw	$a0,48($fp)
	la	$a1,$LC2
	la	$a2,__sF
	la	$t9,freopen
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	bne	$v0,$zero,$L63
	la	$a0,__sF+176
	la	$a1,$LC3
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L63:
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	openInFile
	.size	openInFile, .-openInFile
	.rdata
	.align	2
$LC4:
	.ascii	"wb\000"
	.align	2
$LC5:
	.ascii	"Can't open output file\n\000"
	.text
	.align	2
	.globl	openOutFile
	.ent	openOutFile
openOutFile:
	.frame	$fp,48,$ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$ra,40($sp)
	sw	$fp,36($sp)
	sw	$gp,32($sp)
	move	$fp,$sp
	sw	$a0,48($fp)
	lw	$a0,48($fp)
	la	$a1,$LC4
	la	$a2,__sF+88
	la	$t9,freopen
	jal	$ra,$t9
	sw	$v0,24($fp)
	lw	$v0,24($fp)
	bne	$v0,$zero,$L65
	la	$a0,__sF+176
	la	$a1,$LC5
	la	$t9,fprintf
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L65:
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	openOutFile
	.size	openOutFile, .-openOutFile
	.rdata
	.align	2
$LC6:
	.ascii	"Usage:\n"
	.ascii	" tp0 -h\n"
	.ascii	" tp0 -V\n"
	.ascii	" tp0 [OPTIONS]\n"
	.ascii	"Options:\n"
	.ascii	" -V, --version\t Print version and quit.\n"
	.ascii	" -h, --help \t Print this information.\n"
	.ascii	" -i, --input \t Location of the input file.\n"
	.ascii	" -o, --output \t Location of the output file.\n"
	.ascii	" -a, --action \t Program action: encode (default) or dec"
	.ascii	"ode.\n"
	.ascii	"Examples:\n"
	.ascii	" tp0 -a encode -i ~/input -o ~/output\n"
	.ascii	" tp0 -a decode\n\000"
	.text
	.align	2
	.globl	print_help
	.ent	print_help
print_help:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	la	$a0,__sF+88
	la	$a1,$LC6
	la	$t9,fprintf
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	print_help
	.size	print_help, .-print_help
	.rdata
	.align	2
$LC7:
	.ascii	"Version 1.0\n\000"
	.text
	.align	2
	.globl	print_version
	.ent	print_version
print_version:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	la	$a0,__sF+88
	la	$a1,$LC7
	la	$t9,fprintf
	jal	$ra,$t9
	move	$sp,$fp
	lw	$ra,32($sp)
	lw	$fp,28($sp)
	addu	$sp,$sp,40
	j	$ra
	.end	print_version
	.size	print_version, .-print_version
	.rdata
	.align	2
$LC8:
	.ascii	"Error: decode and encode selected.\n\000"
	.text
	.align	2
	.globl	selectionError
	.ent	selectionError
selectionError:
	.frame	$fp,40,$ra		# vars= 0, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,40
	.cprestore 16
	sw	$ra,32($sp)
	sw	$fp,28($sp)
	sw	$gp,24($sp)
	move	$fp,$sp
	la	$a0,__sF+176
	la	$a1,$LC8
	la	$t9,fprintf
	jal	$ra,$t9
	la	$t9,print_help
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
	.end	selectionError
	.size	selectionError, .-selectionError
	.rdata
	.align	2
$LC12:
	.ascii	"help\000"
	.align	2
$LC13:
	.ascii	"version\000"
	.align	2
$LC14:
	.ascii	"input\000"
	.align	2
$LC15:
	.ascii	"output\000"
	.align	2
$LC16:
	.ascii	"action\000"
	.data
	.align	2
$LC17:
	.word	$LC12
	.word	0
	.word	0
	.word	104
	.word	$LC13
	.word	0
	.word	0
	.word	118
	.word	$LC14
	.word	0
	.word	0
	.word	105
	.word	$LC15
	.word	0
	.word	0
	.word	111
	.word	$LC16
	.word	0
	.word	0
	.word	97
	.word	0
	.word	0
	.word	0
	.word	0
	.globl	memcpy
	.rdata
	.align	2
$LC9:
	.ascii	"encode\000"
	.align	2
$LC10:
	.ascii	"decode\000"
	.align	2
$LC11:
	.ascii	"a:i:o:vh\000"
	.align	2
$LC18:
	.ascii	"Option -%c requires an argument.\n\000"
	.align	2
$LC19:
	.ascii	"Unknown option character\n\000"
	.text
	.align	2
	.globl	main
	.ent	main
main:
	.frame	$fp,192,$ra		# vars= 144, regs= 3/0, args= 24, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,192
	.cprestore 24
	sw	$ra,184($sp)
	sw	$fp,180($sp)
	sw	$gp,176($sp)
	move	$fp,$sp
	sw	$a0,192($fp)
	sw	$a1,196($fp)
	li	$v0,-1			# 0xffffffffffffffff
	sw	$v0,32($fp)
	la	$v0,$LC9
	sw	$v0,40($fp)
	la	$v0,$LC10
	sw	$v0,44($fp)
	la	$v0,$LC11
	sw	$v0,48($fp)
	addu	$v0,$fp,56
	la	$v1,$LC17
	move	$a0,$v0
	move	$a1,$v1
	li	$a2,96			# 0x60
	la	$t9,memcpy
	jal	$ra,$t9
	sw	$zero,opterr
$L71:
	addu	$v0,$fp,56
	sw	$zero,16($sp)
	lw	$a0,192($fp)
	lw	$a1,196($fp)
	lw	$a2,48($fp)
	move	$a3,$v0
	la	$t9,getopt_long
	jal	$ra,$t9
	sw	$v0,36($fp)
	lw	$v1,36($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L73
	b	$L72
$L73:
	lw	$v0,36($fp)
	addu	$v0,$v0,-63
	sw	$v0,172($fp)
	lw	$v1,172($fp)
	sltu	$v0,$v1,56
	beq	$v0,$zero,$L89
	lw	$v0,172($fp)
	sll	$v1,$v0,2
	la	$v0,$L90
	addu	$v0,$v1,$v0
	lw	$v0,0($v0)
	.cpadd	$v0
	j	$v0
	.rdata
	.align	2
$L90:
	.gpword	$L85
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L75
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L83
	.gpword	$L81
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L82
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L89
	.gpword	$L84
	.text
$L75:
	lw	$v1,32($fp)
	li	$v0,-1			# 0xffffffffffffffff
	bne	$v1,$v0,$L71
	lw	$a0,optarg
	lw	$a1,40($fp)
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L77
	li	$v0,1			# 0x1
	sw	$v0,32($fp)
	b	$L71
$L77:
	lw	$a0,optarg
	lw	$a1,44($fp)
	la	$t9,strcmp
	jal	$ra,$t9
	bne	$v0,$zero,$L79
	sw	$zero,32($fp)
	b	$L71
$L79:
	la	$t9,selectionError
	jal	$ra,$t9
	b	$L71
$L81:
	lw	$a0,optarg
	la	$t9,openInFile
	jal	$ra,$t9
	b	$L71
$L82:
	lw	$a0,optarg
	la	$t9,openOutFile
	jal	$ra,$t9
	b	$L71
$L83:
	la	$t9,print_help
	jal	$ra,$t9
	move	$a0,$zero
	la	$t9,exit
	jal	$ra,$t9
$L84:
	la	$t9,print_version
	jal	$ra,$t9
	move	$a0,$zero
	la	$t9,exit
	jal	$ra,$t9
$L85:
	lw	$v1,optopt
	li	$v0,105			# 0x69
	beq	$v1,$v0,$L87
	lw	$v1,optopt
	li	$v0,111			# 0x6f
	beq	$v1,$v0,$L87
	lw	$v1,optopt
	li	$v0,97			# 0x61
	beq	$v1,$v0,$L87
	b	$L86
$L87:
	la	$a0,__sF+176
	la	$a1,$LC18
	lw	$a2,optopt
	la	$t9,fprintf
	jal	$ra,$t9
	b	$L88
$L86:
	la	$a0,__sF+176
	la	$a1,$LC19
	la	$t9,fprintf
	jal	$ra,$t9
$L88:
	la	$t9,print_help
	jal	$ra,$t9
	li	$a0,1			# 0x1
	la	$t9,exit
	jal	$ra,$t9
$L89:
	la	$t9,abort
	jal	$ra,$t9
$L72:
	.set	noreorder
	nop
	.set	reorder
$L91:
	addu	$v0,$fp,152
	move	$a0,$v0
	li	$a1,1			# 0x1
	li	$a2,12			# 0xc
	la	$a3,__sF
	la	$t9,fread
	jal	$ra,$t9
	sw	$v0,168($fp)
	addu	$v0,$fp,152
	lw	$a0,32($fp)
	move	$a1,$v0
	lw	$a2,168($fp)
	la	$t9,process
	jal	$ra,$t9
	lhu	$v0,__sF+12
	srl	$v0,$v0,5
	andi	$v0,$v0,0x1
	beq	$v0,$zero,$L91
	lw	$a0,32($fp)
	la	$t9,closeProcess
	jal	$ra,$t9
	la	$a0,__sF
	la	$t9,fclose
	jal	$ra,$t9
	la	$a0,__sF+88
	la	$t9,fclose
	jal	$ra,$t9
	move	$v0,$zero
	move	$sp,$fp
	lw	$ra,184($sp)
	lw	$fp,180($sp)
	addu	$sp,$sp,192
	j	$ra
	.end	main
	.size	main, .-main
	.align	2
	.ent	__sputc
__sputc:
	.frame	$fp,48,$ra		# vars= 8, regs= 3/0, args= 16, extra= 8
	.mask	0xd0000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.cpload	$t9
	.set	reorder
	subu	$sp,$sp,48
	.cprestore 16
	sw	$ra,40($sp)
	sw	$fp,36($sp)
	sw	$gp,32($sp)
	move	$fp,$sp
	sw	$a0,48($fp)
	sw	$a1,52($fp)
	lw	$v1,52($fp)
	lw	$v0,52($fp)
	lw	$v0,8($v0)
	addu	$v0,$v0,-1
	sw	$v0,8($v1)
	bgez	$v0,$L3
	lw	$v0,52($fp)
	lw	$v1,52($fp)
	lw	$a0,8($v0)
	lw	$v0,24($v1)
	slt	$v0,$a0,$v0
	bne	$v0,$zero,$L2
	lb	$v1,48($fp)
	li	$v0,10			# 0xa
	bne	$v1,$v0,$L3
	b	$L2
$L3:
	lw	$a1,52($fp)
	lw	$v1,0($a1)
	lbu	$a0,48($fp)
	move	$v0,$v1
	sb	$a0,0($v0)
	andi	$v0,$a0,0x00ff
	addu	$v1,$v1,1
	sw	$v1,0($a1)
	sw	$v0,24($fp)
	b	$L1
$L2:
	lw	$a0,48($fp)
	lw	$a1,52($fp)
	la	$t9,__swbuf
	jal	$ra,$t9
	sw	$v0,24($fp)
$L1:
	lw	$v0,24($fp)
	move	$sp,$fp
	lw	$ra,40($sp)
	lw	$fp,36($sp)
	addu	$sp,$sp,48
	j	$ra
	.end	__sputc
	.size	__sputc, .-__sputc
	.ident	"GCC: (GNU) 3.3.3 (NetBSD nb3 20040520)"
