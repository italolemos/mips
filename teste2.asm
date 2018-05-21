.data  
arquivoentrada: .asciiz "string.in"     
arquivosaida: .asciiz "string.out"
buffer: .space 1024
carriageReturn: .asciiz "\r"
linefeed: .asciiz "\n"
menorpalavra: .space 1024
maiorpalavra: .space 1024
str_data_end: .asciiz "\n"
.text
main:
	jal abrirArquivo
	jal imprimebuffer
	la $a0, buffer
	lb $t2,linefeed
	lb $t5,carriageReturn
	la $s2, menorpalavra  
	la $s3, maiorpalavra
	add $a1, $zero, 0
	jal lerpalavras
	jr $ra


abrirArquivo:
	li   $v0, 13       # system call for open file
	la   $a0, arquivoentrada      # input file name
	li   $a1, 0        # flag for reading
	li   $a2, 0        # mode is ignored
	syscall            # open a file 
	move $s0, $v0      # save the file descriptor 

# reading from file just opened
	
	li   $v0, 14       # system call for reading from file
	move $a0, $s0      # file descriptor 
	la   $a1, buffer   # address of buffer from which to read
	li   $a2,  1024  # hardcoded buffer length
	syscall            # read from file
	jr $ra

imprimebuffer:	
	li $v0, 4
	la $a0, buffer
	syscall
	jr $ra
	
lerpalavras:
	addi $t0, $zero, 0 #zerando o contador, $t0 guarda o tamanho da string;
	add $t3, $a0, $zero
    	loop: 
            lb $t1, 0($a0) # carrega o proximo byte dentro de t1;
            beqz $t1, fimarquivo # se $t1 for 0 (fim do arquivo) pula pra saida;
            beq $t1, $t2, fimpalavra #se t1 for \n nova palavra
            addi $a0, $a0, 1 # incrementa o pointeiro da string;
            addi $t0, $t0, 1 # incrementa o contador;
            
            #print atual byte
            li $v0, 11
            la $a0, ($t1)
            syscall
         
            j loop 
    	fimpalavra:
    	#salva tamanho da string e posicao
    	#primeira palavra: a1 == 0
    		addi $a0, $a0, 1
    		sub $t0, $t0, 1 #subtrai um por conta do \r que n�o foi considerado
    		beqz $a1, salvaPrimeiraPalavra
    		beq $a1, $t0, concatenaPalavraAtualComMenor
		blt $t0, $a1, sobrescreveMenorPalavra
		beq $a2, $t0, concatenaPalavraAtualComMaior
		bgt $t0, $a2, sobrescreveMaiorPalavra
		j lerpalavras
	fimarquivo:
    		beq $a1, $t0, concatenaPalavraAtualComMenor
		blt $t0, $a1, sobrescreveMenorPalavra
		beq $a2, $t0, concatenaPalavraAtualComMaior
		bgt $t0, $a2, sobrescreveMaiorPalavra
		j fechaArquivo 	    

    
salvaPrimeiraPalavra:
 	add $a1, $t0, $zero #a1 guarda o tamanho da menor string
 	add $a2, $t0, $zero #a2 guarda o tamanho da maior string
 	la $a3, buffer
 	#transferir palavra para menorpalavra
 	j copiaPrimeiraPalavra
 	
copiaPrimeiraPalavra:  
	lb $t0, ($a3)                  # get character at address  
	beq $t0, $t2, lerpalavras
	sb $t0, ($s2)                  # carrega na string menorpalavra
	sb $t0, ($s3) #carrega na maiorpalavra
	addi $a3, $a3, 1               # string1 pointer points a position forward  
	addi $s2, $s2, 1               # same for finalStr pointer  
	addi $s3, $s3, 1   
	j copiaPrimeiraPalavra              # loop 

concatenaPalavraAtualComMenor:
	lb $t0, ($t3)        
	beqz $t0, fechaArquivo
	beq $t0, $t2, lerpalavras
	sb $t0, ($s2)                  
	addi $t3, $t3, 1               
	addi $s2, $s2, 1               
	j concatenaPalavraAtualComMenor

concatenaPalavraAtualComMaior:
	lb $t0, ($t3)
	beqz $t0, fechaArquivo
	beq $t0, $t2, lerpalavras
	sb $t0, ($s3)                  
	addi $t3, $t3, 1               
	addi $s3, $s3, 1               
	j concatenaPalavraAtualComMaior              

sobrescreveMenorPalavra:
	add $a1, $t0, $zero #sobrescreve menor valor
	la $s2, menorpalavra
	limpaMenorPalavra:
		sb $zero, ($s2)
		addi $s2, $s2, 1
		lb $t0, ($s2)
		bnez $t0, limpaMenorPalavra
	la $s2, menorpalavra
	j concatenaPalavraAtualComMenor

sobrescreveMaiorPalavra:
	add $a2, $t0, $zero #sobrescreve maior valor
	la $s3, maiorpalavra
	limpaMaiorPalavra:
		sb $zero, ($s3)
		addi $s3, $s3, 1
		lb $t0, ($s3)
		bnez $t0, limpaMaiorPalavra
	la $s3, maiorpalavra
	j concatenaPalavraAtualComMaior

fechaArquivo:

	li $v0, 13
	la $a0, arquivosaida
	li $a1, 1
	li $a2, 0
	syscall  # File descriptor gets returned in $v0

	move $a0, $v0  # Syscall 15 requieres file descriptor in $a0
	li $v0, 15
	la $a1, menorpalavra
	la $a2, str_data_end
	la $a3, menorpalavra
	#subu $a2, $a2, $a3  # computes the length of the string, this is really a constant
	syscall
	li $v0, 16  # $a0 already has the file descriptor
	syscall

	li   $v0, 10       # system call for close file
	syscall            # close file
	jr $ra
