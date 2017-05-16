#include <mips/regdef.h>
#include <sys/syscall.h>

					.data  
					bufferr:  .space 75	# 4500 bytes para el buffer de lectura
					bufferw:  .space 76	# 4560 bytes para el buffer de escritura
					diction:  .asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
					p:		  .asciiz "="

					.text
					.align 2
					.globl base64_encode
					.ent base64_encode
					# Se crea el SRA 16 y LTA 0 y ABA 0 = 16 bytes
base64_encode:		subu sp, sp, 16 
					sw ra, 8(sp)
			        sw $fp, 4(sp)
			        sw gp, 0(sp)
			        move $fp, sp

			        # Se guardan los file descriptors en valores s
			        move s1, a0 # FD in
			        move s2, a1 # FD out

			        # Trae la informacion
			        b readIntoBuffer

inicio:				add t0, zero, zero # el puntero del bufferr va en 0
					add t6, zero, zero # el puntero del bufferw va en 0
					add t4, zero, zero # el indicador de fin de input va en 0

					# si va un mult de 75 bytes, pone un fin de linea en el 76 
for_loop:			beqz t6, inicializar
					addi t2, zero, 76 # t2 <- 76
					remu t1, t6, t2 # busco el resto de dividirlo por 76
					bnez t1, inicializar # si no da 0, continua
					addi t1, zero, 10 # guarda un \n
					la t2, bufferw # trae la direccion del bufferw
					addu t2, t2, t6 # le sumo el offset
					sb t1, 0(t2) # pone el fin de linea en el bufferw
					addi t6, t6, 1 # avanza el puntero de bufferw

					# inicializa en cero 
inicializar:		add t1, zero, zero
					add t2, zero, zero
					add t3, zero, zero

					# lee del buffer
					la t1, bufferr # trae la direccion del bufferr
					addu t1, t1, t0 # le sumo el offset
					lb t1, 0(t1) # t1 <- byte en bufferr
					beqz t1, escribirArchivo # directamente va a escribir el archivo
					addi t0, t0, 1 # avanza el puntero del bufferr

					la t2, bufferr # trae la direccion del bufferr
					addu t2, t2, t0 # le sumo el offset
					lb t2, 0(t2) # t2 <- byte en bufferr
					addi t4, zero, 1 # flag en 1
					beqz t2, terminoinput
					addi t0, t0, 1 # avanza el puntero del bufferr

					la t3, bufferr # trae la direccion del bufferr
					addu t3, t3, t0 # le sumo el offset
					lb t3, 0(t3) # t3 <- byte en bufferr
					add t4, zero, zero # flag en 0
					beqz t3, terminoinput
					addi t0, t0, 1 # avanza el puntero del bufferr

					b operar

terminoinput: 		addi t4, t4, 1 # se indica que termino el input y la cant de bits a rellenar

					# se opera
operar:				addi t5, zero, 16
					sll t1, t1, t5
					add t3, t3, t1 # <- t3 = t1 + t3
					addi t5, zero, 8
					sll t2, t5
					add t3, t3, t2 # <- n = t1 + t2 + t3

					addi t5, zero, 18 # t5 <- 18
					srl t1, t3, t5
					andi t1, t1, 63 # n1

					addi t5, zero, 12 # t5 <- 12
					srl t2, t3, t5
					andi t2, t2, 63 # n2

					addi t5, zero, 6 # t5 <- 6
					srl t5, t3, t5
					andi t5, t5, 63 # n3

					andi t3, t3, 63 # n4

					# busca los indices en el alfabeto y los escribe en el bufferw
					la t7, diction # trae la direccion del diccionario
					addu t7, t7, t1 # le suma el offset
					lb t7, 0(t7) # trae el byte correspondiente
					la t1, bufferw # trae la direccion de bufferw
					addu t1, t1, t6 # le suma el offset
					sb t7, 0(t1) # guarda el byte en bufferw
					addi t6, t6, 1 # se avanza el puntero de escritura

					la t7, diction # trae la direccion del diccionario
					addu t7, t7, t2 # le suma el offset
					lb t7, 0(t7) # trae el byte correspondientet6
					la t1, bufferw # trae la direccion de bufferw
					addu t1, t1, t6 # le suma el offset
					sb t7, 0(t1) #guarda el byte en bufferw
					addi t6, t6, 1 # se avanza el puntero de escritura

					bnez t5, notZero1 # Se fija si es un cero, entonces va un char de padding
					la t7, p # Trae la dir de padding
					lb t7, 0(t7) # Trae el caracter "="
					b write1
notZero1:			la t7, diction # trae la direccion del diccionario
					addu t7, t7, t5 # le suma el offset
					lb t7, 0(t7) # trae el byte correspondiente
write1:				la t1, bufferw # trae la direccion de bufferw
					addu t1, t1, t6 # le suma el offset
					sb t7, 0(t1) #guarda el byte en bufferw
					addi t6, t6, 1 # se avanza el puntero de escritura

					bnez t3, notZero2 # Se fija si es un cero, entonces va un char de padding
					la t7, p # Trae la dir de padding
					lb t7, 0(t7) # Trae el caracter "="
					b write2
notZero2:			la t7, diction # trae la direccion del diccionario
					addu t7, t7, t3 # le suma el offset
					lb t7, 0(t7) # trae el byte correspondiente
write2:				la t1, bufferw # trae la direccion de bufferw
					addu t1, t1, t6 # le suma el offset
					sb t7, 0(t1) #guarda el byte en bufferw
					addi t6, t6, 1 # se avanza el puntero de escritura

					# se fija si hay que vaciar buffer
					addi t7, zero, 75 # si lleno el bufer de escritura, lo guarda
					beq t0, t7, escribirArchivo # se escribe el bufferw
					addi t7, zero, 1 # si se termino la entrada de datos, lo guarda
					beq t4, t7, escribirArchivo # se escribe el bufferw

continuefor:		b for_loop

					# Read to file opened
readIntoBuffer:		li   v0, 3       # system call for read to file
					move a0, s1      # file descriptor 
					la   a1, bufferr   # address of buffer from which to read
					addi t0, t0, 75
					move   a2, t0       # buffer length
					syscall            # write to file

					# Reset buffers
					add t0, zero, zero # el puntero del bufferr va en 0
					add t6, zero, zero # el puntero del bufferw va en 0

					b for_loop

					# Write to file opened
escribirArchivo:	li   v0, 4       # system call for write to file
					move a0, s2      # file descriptor 
					la   a1, bufferw   # address of buffer from which to write
					move   a2, t6       # buffer length
					syscall            # write to file
					beqz t4, readIntoBuffer # si no llego el fin del input, busca mas datos

					# Close the file 
cerrarArchivo:		li   v0, 6       # system call for close file
					move a0, s6      # file descriptor to close
					syscall            # close file

					# Sale de la funcion
salir:				lw ra, 8(sp)
			        lw $fp, 4(sp)
		        	lw gp, 0(sp)
		        	addu sp, sp, 16
					j ra
					.end base64_encode

