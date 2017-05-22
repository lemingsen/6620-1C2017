#include <mips/regdef.h>
#include <sys/syscall.h>

					.data  
					bufferr:	.space 76	# 4500 bytes para el buffer de lectura (r)
					bufferw:	.space 76	# 4560 bytes para el buffer de escritura (w)
					tbufr:		.word 75 # Tamanio del buffer de read
					tbufw: 		.word 76 # Tamanio del buffer de write
					diction:	.asciiz "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
					p:			.asciiz "="
					a:			.asciiz "A"
					error0:     .asciiz "Error: input.txt.\n"
					error1:     .asciiz "Error: output.txt.\n"
					error2:     .asciiz "Error: decode and encode selected.\n"
					error3:     .asciiz "Option -%c requires an argument.\n"
					error4:     .asciiz "Unknown option character\n"
					error5:		.asciiz "Error: fin diccionario\n"
					error6:		.asciiz "Error: error de lectura"
					.extern errmsg 6
					errmsg:     .word error0, error1, error2, error3, error4, error5, error6
					tamdict:	.byte 63 # Tamanio del diccionario - 1
					bufferb: 	.space 5 # Buffer de busqueda en diccionario
					bufferi:	.space 4 # Buffer de indices encontrador
					
					.text
					.align 2
					.globl base64_encode
					.ent base64_encode
# BASE64_ENCODE
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
			        b read_into_buffer_e

inicio_e:			add t0, zero, zero # el puntero del bufferr va en 0
					add t6, zero, zero # el puntero del bufferw va en 0
					add t4, zero, zero # el indicador de fin de input va en 0

					# si va un mult de 75 bytes, pone un fin de linea en el 76 
for_loop_e:			beqz t6, inicializar_e
					addi t2, zero, 76 # t2 <- 76
					remu t1, t6, t2 # busco el resto de dividirlo por 76
					bnez t1, inicializar_e # si no da 0, continua
					addi t1, zero, 10 # guarda un \n
					la t2, bufferw # trae la direccion del bufferw
fin_linea_e:		addu t2, t2, t6 # le sumo el offset
					sb t1, 0(t2) # pone el fin de linea en el bufferw
					addi t6, t6, 1 # avanza el puntero de bufferw

					# inicializa en cero 
inicializar_e:		add t1, zero, zero
					add t2, zero, zero
					add t3, zero, zero

					# lee del buffer
					la t1, bufferr # trae la direccion del bufferr
					addu t1, t1, t0 # le sumo el offset
					lb t1, 0(t1) # t1 <- byte en bufferr
					beqz t1, escribir_archivo_e # directamente va a escribir el archivo
					addi t0, t0, 1 # avanza el puntero del bufferr

					la t2, bufferr # trae la direccion del bufferr
					addu t2, t2, t0 # le sumo el offset
					lb t2, 0(t2) # t2 <- byte en bufferr
					addi t4, zero, 1 # flag en 1
					beqz t2, termino_input_e
					addi t0, t0, 1 # avanza el puntero del bufferr

					la t3, bufferr # trae la direccion del bufferr
					addu t3, t3, t0 # le sumo el offset
					lb t3, 0(t3) # t3 <- byte en bufferr
					add t4, zero, zero # flag en 0
					beqz t3, termino_input_e
					addi t0, t0, 1 # avanza el puntero del bufferr

					b operar_e

termino_input_e:	addi t4, t4, 1 # se indica que termino el input y la cant de bits a rellenar

					# se opera
operar_e:			addi t5, zero, 16
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

					bnez t5, not_zero1_e # Se fija si es un cero, entonces va un char de padding
					la t7, p # Trae la dir de padding
					lb t7, 0(t7) # Trae el caracter "="
					b write1_e
not_zero1_e:		la t7, diction # trae la direccion del diccionario
					addu t7, t7, t5 # le suma el offset
					lb t7, 0(t7) # trae el byte correspondiente
write1_e:			la t1, bufferw # trae la direccion de bufferw
					addu t1, t1, t6 # le suma el offset
					sb t7, 0(t1) #guarda el byte en bufferw
					addi t6, t6, 1 # se avanza el puntero de escritura

					bnez t3, not_zero2_e # Se fija si es un cero, entonces va un char de padding
					la t7, p # Trae la dir de padding
					lb t7, 0(t7) # Trae el caracter "="
					b write2_e
not_zero2_e:		la t7, diction # trae la direccion del diccionario
					addu t7, t7, t3 # le suma el offset
					lb t7, 0(t7) # trae el byte correspondiente
write2_e:			la t1, bufferw # trae la direccion de bufferw
					addu t1, t1, t6 # le suma el offset
					sb t7, 0(t1) #guarda el byte en bufferw
					addi t6, t6, 1 # se avanza el puntero de escritura

					# se fija si hay que vaciar buffer
debe_escribir_e:	addi t7, zero, 75 # si lleno el bufer de escritura, lo guarda
					beq t0, t7, escribir_archivo_e # se escribe el bufferw
					addi t7, zero, 1 # si se termino la entrada de datos, lo guarda
					beq t4, t7, escribir_archivo_e # se escribe el bufferw

continue_for_e:		b for_loop_e

					# Read to file opened
read_into_buffer_e:	li   v0, 3       # system call for read to file
					move a0, s1      # file descriptor 
					la   a1, bufferr   # address of buffer from which to read
					addi t0, t0, 75
					move   a2, t0       # buffer length
					syscall            # write to file

					# Reset buffers
					add t0, zero, zero # el puntero del bufferr va en 0
					add t6, zero, zero # el puntero del bufferw va en 0

					b for_loop_e

					# Write to file opened
escribir_archivo_e:	li   v0, 4       # system call for write to file
					move a0, s2      # file descriptor 
					la   a1, bufferw   # address of buffer from which to write
					move   a2, t6       # buffer length
					syscall            # write to file
					beqz t4, read_into_buffer_e # si no llego el fin del input, busca mas datos

					# Close the file 
cerrar_archivo_e:	li   v0, 6       # system call for close file
					move a0, s2      # file descriptor to close
					syscall            # close file

					# Sale de la funcion
salir_encode:		lw ra, 8(sp)
			        lw $fp, 4(sp)
		        	lw gp, 0(sp)
		        	addu sp, sp, 16
					j ra
					.end base64_encode

# BASE64_DECODE
					.globl base64_decode
					.ent base64_decode
					# Se crea el SRA 16 y LTA 0 y ABA 0 = 16 bytes
base64_decode:		subu sp, sp, 16 
					sw ra, 8(sp)
			        sw $fp, 4(sp)
			        sw gp, 0(sp)
			        move $fp, sp

			        # Se guardan los file descriptors en valores s
			        move s1, a0 # FD in
			        move s2, a1 # FD out

inicio_d:			add t0, zero, zero # el puntero del bufferr va en 0
					add t6, zero, zero # el puntero del bufferw va en 0
					add t4, zero, zero # el indicador de fin de input va en 0

			        # Trae la informacion
			        b read_into_buffer_d

					# inicializa en cero 
for_loop_d:			add t1, zero, zero
					add t2, zero, zero
					add t3, zero, zero
					add t5, zero, zero

					# lee del buffer
					la t1, bufferr # trae la direccion del bufferr
					addu t1, t1, t0 # le sumo el offset
					lb t1, 0(t1) # t1 <- byte en bufferr
					bnez t1, fin_linea_d # Si no termino el archivo, va a verificar fin de linea
fin_archivo_d:		li t4, 1 # Sino, pone el flag en 1 para avisar fin de archivo
					beqz t1, escribir_archivo_d # va a escribir el archivo
fin_linea_d:		addi t2, zero, 10 # Char de fin de linea
					bne t1, t2, leer_bufferb_d # Si no es un fin de linea, lee en buffer
					addi t0, t0, 1 # Sino lo ignora y avanza el puntero del bufferr

					# Carga en el bufferb el siguiente word de bufferr
leer_bufferb_d:		la t1, bufferr # trae la direccion del bufferr
					addu t1, t1, t0 # le sumo el offset
					addi t0, t0, 4 # avanza el puntero del bufferr
					la t2, bufferb # Trae la direccion del bufferb
					lb t3, 0(t1) # t1 <- byte en bufferr
					sb t3, 0(t2) # Guarda el word en el bufferb
					lb t3, 1(t1) # t1 <- byte en bufferr
					sb t3, 1(t2) # Guarda el word en el bufferb
					lb t3, 2(t1) # t1 <- byte en bufferr
					sb t3, 2(t2) # Guarda el word en el bufferb
					lb t3, 3(t1) # t1 <- byte en bufferr
					sb t3, 3(t2) # Guarda el word en el bufferb

					# Se fija si hay algun char de padding y lo reemplaza por 'A'
					la t1, bufferb # Trae la direccion del buffer
					lb t1, 0(t1) # Trae el primer byte
					la t2, p # Trae el padding
					lb t2, 0(t2) # Trae el char "="
					bne t2, t1, verificar_sig_d # Compara con el byte de padding
					la t2, a
					lb t2, 0(t2)
					la t1, bufferb # Trae la direccion del buffer
					sb t2, 0(t1)
verificar_sig_d:	la t1, bufferb # Trae la direccion del buffer
					lb t1, 1(t1) # Trae el 2do byte
					la t2, p # Trae el padding
					lb t2, 0(t2) # Trae el char "="
					bne t2, t1, verificar_sig_d1 # Compara con el byte de padding
					la t2, a
					lb t2, 0(t2)
					la t1, bufferb # Trae la direccion del buffer
					sb t2, 1(t1)
verificar_sig_d1:	la t1, bufferb # Trae la direccion del buffer
					lb t1, 2(t1) # Trae el 3er byte
					la t2, p # Trae el padding
					lb t2, 0(t2) # Trae el char "="
					bne t2, t1, verificar_sig_d2 # Compara con el byte de padding
					la t2, a
					lb t2, 0(t2)
					la t1, bufferb # Trae la direccion del buffer
					sb t2, 2(t1)
verificar_sig_d2:	la t1, bufferb # Trae la direccion del bufferdebe_escribir_d
					lb t1, 3(t1) # Trae el 2do byte
					la t2, p # Trae el padding
					lb t2, 0(t2) # Trae el char "="
					bne t2, t1, buscar_d # Compara con el byte de padding
					la t2, a
					lb t2, 0(t2)
					la t1, bufferb # Trae la direccion del buffer
					sb t2, 3(t1)

					# Se busca en el diccionario los indices de los 4 char
buscar_d:			add s5, zero, zero # Indice del bufferb
inicio_buscar_d:	add t7, zero, zero # Indice del diccionario
					la s4, bufferb # Direccion de bufferb
					add s4, s4, s5 # Suma el offset
					lb s3, 0(s4) # Elemento a buscar
buscar_loop_d:		la s7, diction # trae la direccion del diccionario
					addu s7, s7, t7 # le suma el offset
					lb s7, 0(s7) # Trae el byte a comparar
comparar_d:			beq s3, s7, siguiente_d # Si encontro el byte que buscaba, guarda el indice
					addi s7, zero, 63 # Tamanio del diccionario
					beq t7, s7, error_fin_dic_d # error fin de diccionario
					addi t7, t7, 1 # Se incrementa el buscador
					b buscar_loop_d # Se sigue buscando
siguiente_d:		la s4, bufferi # Direccion del bufferi
					add s4, s4, s5 # Suma el offset 
					sb t7, 0(s4) # Guarda el byte encontrado
					addi s5, s5, 1 # Le suma uno al indice del buffer
					addi t7, zero, 4
					bne s5, t7, inicio_buscar_d # Si no llega a 4 elementos, busca los demas

					# Trae los indices encontrados
trae_indices:		la s4, bufferi # Direccion del bufferb (con los indices cargados)
					lb t1, 0(s4) # t1 <- 1er indice
					lb t2, 1(s4) # t2 <- 2do indice
					lb t3, 2(s4) # t3 <- 3er indice
					lb t5, 3(s4) # t5 <- 4to indice

					# Opera
					addi t7, zero, 18
					sll t1, t1, t7 # t1 << 18
					addi t7, zero, 12
					sll t2, t2, t7 # t2 << 12
					addi t7, zero, 6 
					sll t3, t3, t7 # t3 << 6
					addu t1, t1, t2
					addu t1, t1, t3
					addu t1, t1, t5 # N = t1 + t2 + t3 + t5

					# Separa N en 3 char 
					addi t7, zero, 16
					srl t2, t1, t7 # t1 <- (N >> 16)
					andi t2, t2, 255 # N1
					addi t7, zero, 8
					srl t3, t1, t7 # t3 <- (N >> 8)
					andi t3, t3, 255 # N2
					andi t5, t1, 255 # N3

					# Los guarda en el bufferw
					la t1, bufferw # Trae la direccion de bufferw
					addu t1, t1, t6 # Le suma el offset
					sb t2, 0(t1) # Guarda el byte
					addi t6, t6, 1 # Avanza el puntero
					# Se fija si es un 0, utilizado para padding, para saltearlo
					beqz t3, escribir_sig_d
					la t1, bufferw # Trae la direccion de bufferw
					addu t1, t1, t6 # Le suma el offset
					sb t3, 0(t1) # Guarda el byte
					addi t6, t6, 1 # Avanza el puntero
					# Se fija si es un 0, utilizado para padding, para saltearlo
escribir_sig_d:		beqz t5, debe_escribir_d
					la t1, bufferw # Trae la direccion de bufferw
					addu t1, t1, t6 # Le suma el offset
					sb t5, 0(t1) # Guarda el byte
					addi t6, t6, 1 # Avanza el puntero

					# se fija si hay que vaciar buffer
debe_escribir_d:	addi t7, t6, 3 # le suma 3 al tam actual del bufferw
					la t2, tbufw # Tam del bufferw
					lw t2, 0(t2) 
					bge t7, t2, escribir_archivo_d # se escribe el bufferw
					addi t4, zero, 1 # flag en 1
					beq t6, s6, escribir_archivo_d # si ya escribio la linea se escribe el bufferw
					add t4, zero, zero # flag en 0

continue_for_d:		b for_loop_d

					# Read to file opened
read_into_buffer_d:	li   v0, 3       # system call for read to file
					move a0, s1      # file descriptor 
					la   a1, bufferr   # address of buffer from which to read
					addi t0, t0, 76
					move   a2, t0       # buffer length
					syscall            # write to file

					move s6, v0 # Guardo la cantidad de bytes leidos
					addi t0, zero, -1
					beq s6, t0, error_lectura_d
					divu s6, s6, 4
					mul s6, s6, 3 # Cantidad de bytes a escribir

					# Reset buffers
					add t0, zero, zero # el puntero del bufferr va en 0
					add t6, zero, zero # el puntero del bufferw va en 0

					b for_loop_d

error_fin_dic_d:	la $a0, errmsg
					lw $a0, 20($a0)
					li $v0, 4
					syscall
					b cerrar_archivo_d 

error_lectura_d:	la $a0, errmsg
					lw $a0, 24($a0)
					li $v0, 4
					syscall
					b cerrar_archivo_d 

					# Write to file opened
escribir_archivo_d:	li   v0, 4       # system call for write to file
					move a0, s2      # file descriptor 
					la   a1, bufferw   # address of buffer from which to write
					move   a2, t6       # buffer length
					syscall            # write to file
					beqz t4, read_into_buffer_d # si no llego el fin del input, busca mas datos

					# Close the file 
cerrar_archivo_d:	li   v0, 6       # system call for close file
					move a0, s2      # file descriptor to close
					syscall            # close file

					# Sale de la funcion
salir_decode:		lw ra, 8(sp)
			        lw $fp, 4(sp)
		        	lw gp, 0(sp)
		        	addu sp, sp, 16
					j ra
					.end base64_decode
