#base64_encode

.text
.align 	2
.globl	base64_encode
.ent	base64_encode

base64_encode:			#int base64_encode(int infd, int outfd)
.set	noreorder
.cpload	$t9
.set	reorder
subu	$sp, $sp, 48	#1 para gp, 1 para fp, 1 para ra, 1 para a0, 1 para a1 y 7 extra
sw		$gp, 40($sp)
sw		$fp, 36($sp)
sw		$ra, 32($sp)
move	$fp, $sp
sw		$a0, 48($fp)	#File descriptor de entrada
sw		$a1, 44($fp)	#File descriptor de salida
lw		$a0, 48($fp)
addu	$a1, $fp, 16	#Buffer de 16($fp) a 28($fp) tamaño 12
li		$a2, 12
la		$t9, read
jal		$ra, $t9
li		$a0, 1			#Encode = 1
addu	$a1, $fp, 16
move	$a2, v0
lw		$a3, 44($fp)
la		$t9, process
jal		$ra, $t9
lhu		$v0, __sF+12	#Revisar esto
srl		$v0, $v0,5
andi	$v0, $v0, 0x1
beq		$v0, $zero, base64_encode
move	$sp, $fp
lw		$gp, 40($sp)
lw		$fp, 36($sp)
lw		$ra, 32($sp)
addu	$sp, $sp, 48
j		$ra
.end	base64_encode

#base64_decode

.text
.align 	2
.globl	base64_encode
.ent	base64_encode

base64_decode:			#int base64_decode(int infd, int outfd)
.set	noreorder
.cpload	$t9
.set	reorder
subu	$sp, $sp, 48	#1 para gp, 1 para fp, 1 para ra, 1 para a0, 1 para a1 y 7 extra
sw		$gp, 40($sp)
sw		$fp, 36($sp)
sw		$ra, 32($sp)
move	$fp, $sp
sw		$a0, 48($fp)	#File descriptor de entrada
sw		$a1, 44($fp)	#File descriptor de salida
lw		$a0, 48($fp)
addu	$a1, $fp, 16	#Buffer de 16($fp) a 28($fp) tamaño 12
li		$a2, 12
la		$t9, read
jal		$ra, $t9
li		$a0, 0			#Encode = 0
addu	$a1, $fp, 16
move	$a2, v0
lw		$a3, 44($fp)
la		$t9, process
jal		$ra, $t9
lhu		$v0, __sF+12	#Revisar esto
srl		$v0, $v0,5
andi	$v0, $v0, 0x1
beq		$v0, $zero, base64_encode
move	$sp, $fp
lw		$gp, 40($sp)
lw		$fp, 36($sp)
lw		$ra, 32($sp)
addu	$sp, $sp, 48
j		$ra
.end	base64_encode

#process

.text
.align	2
.ent	process

process:				#void process(int encode, char* buffer, size_t amount, int outfd)
.set	noreorder
.cpload	$t9
.set	reorder
subu	$sp, $sp, 24	#gp, fp, ra, a0, a1, a2 y a3
sw		$gp, 8($sp)
sw		$fp, 4($sp)
sw		$ra, 0($sp)
move	$fp, $sp
sw		$a0, 24($fp)
sw		$a1, 20($fp)
sw		$a2, 16($fp)
sw		$a3, 12($fp)
subu	$t1, $a0, 1
move	$a0, $a1
move	$a1, $a2
move	$a2, $a3
beqz	$t1, encode64
la		$t9, decode64
jal		$ra, $t9
move	$sp, $fp
lw		$gp, 8($sp)
lw		$fp, 4($sp)
lw		$ra, 0($sp)
addu	$sp, $sp, 20
j		$ra
.end	process

#encode64

.text
.align	2
.ent	encode64
encode64:				#void encode64(char * const input, size_t amount, int outfd)
.set	noreorder
.cpload	$t9
.set	reorder
subu	$sp, $sp, 32	#gp, fp, ra, a0 = input, a1 = amount, a2 = outfd, t1 = i, t2 = j, t3 = aChar
sw		$gp, 20($sp)
sw		$fp, 16($sp)
sw		$ra, 12($sp)
move	$fp, $sp
sw		$a0, 32($fp)
sw		$a1, 28($fp)
sw		$a2, 24($fp)
move	$t1, $zero
sw		$t1, 8($fp)

$for1_encode64:
lw		$t1, 8($fp)
lw		$a1, 28($fp)
sltu	$v0, $t1, $a1
beqz	$v0, $end_encode64
lw		$a0, 32($fp)
addu	$t3, $a0, $t1
lbu		$t3, 0($t3)
sb		$t3, 0($fp)
li		$t2, 7			#DECODE_SIZE - 1 = 8 - 1 = 7
sw		$t2, 4($fp)

$L1
lw		$t2, 4($fp)
bgez	$t2, $L2
lw		$t1, 8($fp)
addu	$t1, $t1, 1
sw		$t1, 8($fp)
b		$for1_encode64

$L2
lw		$t2, 4($fp)
lw		$t3, 0($fp)
sra		$t4, $t3, $t2
andi	$t4, $t4, 0x1
move	$a0, $t4
lw		$a1, 24($fp)
la		$t9, doEncode
jal		$ra, $t9
lw		$t2, 4($fp)
subu	$t2, $t2, 1
sw		$t2, 4($fp)
b		$L1

$end_encode64:
move	$sp, $fp
lw		$gp, 20($sp)
lw		$fp, 16($sp)
lw		$ra, 12($sp)
addu	$sp, $sp, 32
j		$ra
.end	encode64

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

.rdata
.align	2
$ALPHABET:
.ascii	"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123"
.ascii	"456789+/\000"
	
#doEncode

.text
.align	2
.ent	doEncode
doEncode:				#void doEncode(int value, int outfd)
.set	noreorder
.cpload $t9
.set	reorder
subu	$sp, $sp, 16	#gp, fp, ra, a0 = value, a1 = outfd, t1 = count, t2 = linecount, t3 = acum, t4 = length
sw		$gp, 8($sp)
sw		$fp, 4($sp)
sw		$ra, 0($sp)
move	$fp, $sp
sw		$a0, 16($fp)
sw		$a1, 12($fp)
lw		$t1, count
subu	$t1, $t1, 1
sw		$t1, count
lw		$v0, acum
sll		$t3, v0, 1
or		$t3, $t3, $a0
sw		$t3, acum
li		$v0, 6			#ENCODE_SIZE = 6
beq		$t1, $v0, L3
b		$end_doEncode

$L3:
lw		$t2, linecount
addu	$t2, $t2, 1
sw		$t2, linecount
lw		$t4, length
addu	$t4, $t4, 1
sw		$t4, length
lw		$t3, acum
la		$v0, $ALPHABET
addu	$v0, $v0, $t3	#Revisar esto. Puede que sea al reves
lw		$a0, 12($fp)
move	$a1, v0
li		$a2, 1
la		$t9, write
jal		$ra, $t9
lw		$t2, linecount
li		$v0, 76
beq		$t2, $v0, $L4
b		$end_doEncode

$L4:
lw		$a0, 12($fp)
li		$a1, 10
li		$a2, 1
la		$t9, write
jal		$ra, $t9
sw		$zero, linecount
sw		$zero, count
sw		$zero, acum

$end_doEncode:
move	$sp, $fp
lw		$gp, 8($sp)
lw		$fp, 4($sp)
lw		$ra, 0($sp)
addu	$sp, $sp, 12
j		$ra
.end	doEncode

#decode64

.text
.align	2
.ent	decode64
decode64:				#void decode64(char * const input, size_t amount, int outfd)
.set	noreorder
.cpload	$t9
.set	reorder
subu	$sp, $sp, 32	#gp, fp, ra, a0 = input, a1 = amount, a2 = outfd, t1 = i, t2 = j, t3 = aChar
sw		$gp, 20($sp)
sw		$fp, 16($sp)
sw		$ra, 12($sp)
move	$fp, $sp
sw		$a0, 32($fp)
sw		$a1, 28($fp)
sw		$a2, 24($fp)
li		$t1, 0
sw		$t1, 8($fp)

$for1_decode64:
lw		$t1, 8($fp)
lw		$a1, 28($fp)
sltu	$v0, $t1, $a1
lw		$a0, 32($fp)
addu	$v1, $a0, $t1
lbu		$v1, 0($v1)
li		$t4, 61
sne		$v1, $v1, $t4
and		$v0, $v0, $v1
beqz	$v0, $end_decode64

$for1_decode64_cond_ok:
lw		$t1, 8($fp)
lw		$a0, 32($fp)
addu	$v1, $a0, $t1
lbu		$v1, 0($v1)
li		$t4, 10
bne		$v1, $t4, $if1_decode64
b		$for1_decode64_cont

$if1_decode64:
lw		$t1, 8($fp)
lw		$a0, 32($fp)
addu	$v0, $a0, $t1
lbu		$a0, 0($v0)
la		$t9, indexOf
jal		$ra, $t9
move	$t3, $v0
sw		$t3, 0($fp)
li		$t2, 5
sw		$t2, 4($fp)

$for2_decode64:
lw		$t2, 4($fp)
bltz	$t2, $for1_decode64_cont
lw		$t3, 0($fp)
srl		$v0, $t3, $t2
andi	$a0, $v0, 0x1
lw		$a1, 24($fp)
la		$t9, doDecode
jal		$ra, $t9
lw		$t2, 4($fp)
subu	$t2, $t2, 1
sw		$t2, 4($fp)
b		$for2_decode64

$for1_decode64_cont:
lw		$t1, 8($fp)
addu	$t1, $t1, 1
sw		$t1, 8($fp)
b		$for1_decode64


$end_for1_decode64:
lw		$t1, 8($fp)
addu	$t1, $t1, 1
sw		$t1, 8($fp)
b		$for1_decode64

$end_decode64:
move	$sp, $fp
lw		$gp, 20($sp)
lw		$fp, 16($sp)
lw		$ra, 12($sp)
addu	$sp, $sp, 32
j		$ra
.end	decode64

#doDecode

.text
.align	2
.ent	doDecode
doDecode:				#void doDecode(int value, int outfd)
.set	noreorder
.cpload $t9
.set	reorder
subu	$sp, $sp, 16	#gp, fp, ra, a0 = value, a1 outfd
sw		$gp, 8($sp)
sw		$fp, 4($sp)
sw		$ra, 0($sp)
move	$fp, $sp
sw		$a0, 16($fp)
sw		$a1, 12($fp)
lw		$v0, acum
sll		$v0, $v0, 1
or		$v0, $v0, $a0
sw		$v0, acum
lw		$v1, count
addu	$v1, $v1, 1
sw		$v1, count
li		$t1, 8
bne		$v1, $t1, $end_doDecode
lw		$v1, length
addu	$v1, $v1, 1
sw		$v1, length
move	$a0, $a1
move	$a1, $v0
li		$a2, 1
la		$t9, write
jal		$ra, $t9
move	acum, $zero
move	count, $zero

$end_doDecode:
move	$sp, $fp
lw		$gp, 8($sp)
lw		$fp, 4($sp)
lw		$ra, 0($sp)
addu	$sp, $sp, 16
j		$ra
.end	doDecode