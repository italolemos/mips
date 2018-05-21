.data
    file:    .asciiz "string.in"
    fileOut: .asciiz "string.out"
    buffer:  .space 1024
    endFile: .asciiz "\r"
    endLine: .asciiz "\n"
    bigger_word: .space 1024
    smaller_word: .space 1024
    final_word: .space 1024
    maior: .word 0
    menor: .word 0
    
    str_data_end:
.text
    
    main:
        lb $t2, endLine    # $t2 representa o fim da linha
        la $s2, smaller_word  
	la $s3, bigger_word
	
        
    
        # open a file
        li $v0, 13         # open file code
        la $a0, file   # file name to open
        li $a1, 0          # flag for read only 0 = read; 1 write/create; 9 write/create/append
        li $a2, 0          # flag for ignore
        syscall            # open a file (file descriptor returned in $v0) 
    
    
        move $s0, $v0      # file descriptor saved in $s0
        

        # read file
        li   $v0, 14        # code to read file
        add  $a0, $s0, $0   # move o file descriptor para $a0	
        la   $a1, buffer    # address of buffer from which to read
        li   $a2, 1024      # hardcoded buffer length
        syscall             # read from file
    
        # print
        #li $v0, 4          # print string
        #la $a0, buffer
        #syscall
    
 	la $a1, buffer     # endereco do buffer (copia do conteudo do arquivo)
 		
        # close file
        li $v0, 16
        add $a0, $s0, $s0 
        syscall 
        
        addi $t8, $zero, 0   # controle para ler a primeira palavra
        
        jal readString 
        
readString:
     # $a0 contém o buffer
     li $t0, 0            # contador para o tamanho da string
     add $t3, $a1, $zero  # 
     loop:
         lb $t1, 0($a1)            # carregar o caracter atual em $t1
         beqz $t1, end_of_file     # fim do arquivo retorna 0 em $t1
         beq $t1, $t2, end_of_line # se ler um \n
         
         addi $a1, $a1, 1   # incrimenta o index do buffer 
         addi $t0, $t0, 1   # incrementa o contador
         
         #print atual byte
         #li $v0, 11
         #la $a0, ($t1)
         #syscall
            
         j loop
     end_of_line:
         # se $t8 = 0 lê a primeira palavra
         addi $a1, $a1, 1
         sub $t0, $t0, 1   # desconsidera o \n
         beq $t8, $zero, save_first_word
         
         beq $t8, $t0, concatenaPalavraAtualComMenor
         blt $t0, $t8, sobrescreveMenorPalavra          # Verifica a menor string
         beq $t9, $t0, concatenaPalavraAtualComMaior    
         bgt $t0, $t9, sobrescreveMaiorPalavra         # verifica a maior string
         
         
     j readString
     
end_of_file:
    beq $t0, $t8, concatenaPalavraAtualComMenor
    blt $t0, $t8, sobrescreveMenorPalavra
    beq $a2, $t0, concatenaPalavraAtualComMaior
    bgt $t0, $a2, sobrescreveMaiorPalavra
    
    #print menor palavra
    li $v0, 4
    la $a0, smaller_word
    syscall
     
    #print maior palavra
    li $v0, 4
    la $a0, bigger_word
    syscall     
                   
    # open a file
    li $v0, 13         # open file code
    la $a0, fileOut    # file name to open
    li $a1, 1          # flag for read only 0 = read; 1 write/create; 9 write/create/append
    li $a2, 0          # flag for ignore
    syscall            # open a file (file descriptor returned in $v0) 
      
    move $s6, $v0      # file descriptor
     
    # write file first address
    li $v0, 15
    move $a0, $s6   # move fd
    la $a1, smaller_word
    li $a2, 1024
    syscall
     
    # write file break line
    li $v0, 15
    move $a0, $s6   # move fd
    la $a1, endLine
    li $a2, 4
    syscall
     
    # write file second address
    li $v0, 15
    move $a0, $s6   # move fd
    la $a1, bigger_word
    li $a2, 1024
    syscall
     
     
    #close
    li $v0, 16
    move $a0, $s6
    syscall
    
exit:
     li $v0, 10
      # la $a0, ($t1)
      syscall        

save_first_word:
   #sw $t8, ($t0)          # menor
   #sw $t9, ($t0)          # 
   add $t8, $t0, $zero   # Tamanho da menor string
   add $t9, $t0, $zero   # Tamnho da maior string
   la $a3, buffer
   
   j copy_first_word 

copy_first_word:
    lb $t0, ($a3)              # endereco
    beq $t0, 10, readString     # 10 eh valor para \n
    #sw $t0, menor              # menor palavra
    #sw $t0, maior
    sb $t0, ($s2)              # carrega menor palavra
    sb $t0, ($s3)              # carrega maior palavra
    addi $a3, $a3, 1           # interador do buffer
    addi $s2, $s2, 1           # interador menor palavra
    addi $s3, $s3, 1           # interador maior palavra

    j copy_first_word

    
concatenaPalavraAtualComMenor:
    lb $t0, ($t3)        
    beqz $t0, end_of_file
    beq $t0, $t2, readString
    sb $t0, ($s2)                  
    addi $t3, $t3, 1               
    addi $s2, $s2, 1
                  
    j concatenaPalavraAtualComMenor  
    
concatenaPalavraAtualComMaior:
    lb $t0, ($t3)
    beqz $t0, end_of_file
    beq $t0, $t2, readString
    sb $t0, ($s3)                  
    addi $t3, $t3, 1               
    addi $s3, $s3, 1   
                
    j concatenaPalavraAtualComMaior
    

sobrescreveMenorPalavra:
    add $t8, $t0, $zero      # atualiza menor valor
    la $s2, smaller_word
    limpaMenorPalavra:
        sb $zero, ($s2)     # armazena o byte zero 
	addi $s2, $s2, 1    # incrementa
	lb $t0, ($s2)       # carrega novo byte
	bnez $t0, limpaMenorPalavra  # zero para sair
   la $s2, smaller_word
   
   j concatenaPalavraAtualComMenor

sobrescreveMaiorPalavra:
    add $t9, $t0, $zero    #atualiza maior valor
    la $s3, bigger_word
    limpaMaiorPalavra:
        sb $zero, ($s3)
	addi $s3, $s3, 1
	lb $t0, ($s3)
	bnez $t0, limpaMaiorPalavra
    la $s3, bigger_word
    
    j concatenaPalavraAtualComMaior