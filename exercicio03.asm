.data
    file:    .asciiz "string.in"
    buffer:  .space 1024
    endFile: .asciiz "\r"
    endLine: .asciiz "\n"
    bigger_word: .space 1024
    smaller_word: .space 1024
    error:   .ascii "Arquivo não encontrado"
.text
    
    main:
        lb $t2, endLine    # $t2 representa o fim da linha
    
        # open a file
        li $v0, 13         # open file code
        la $a0, file  # file name to open
        li $a1, 0          # flag for read only 0 = read; 1 write/create; 9 write/create/append
        li $a2, 0          # flag for ignore
        syscall            # open a file (file descriptor returned in $v0) 
    
    
        move $s0, $v0      # file descriptor saved in $s0
        

        # read file
        li   $v0, 14        #code to read file
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
        #li $v0, 16
        #add $a0, $s0, $s0 
        #syscall 
        
        jal readString 
readString:
     # $a0 contém o buffer
     li $t0, 0  # contador da palavra
     li $t3, 0  #
     loop:
         lb $t1, 0($a1)     # carregar o caracter atual
         beq $t1, $t2, exit
         
         addi $a1, $a1, 1   # incrimenta o index do buffer 
         addi $t0, $t0, 1   # incrementa o contador
         
         #print atual byte
         li $v0, 11
         la $a0, ($t1)
         syscall
            
         j loop
     exit:
         li $v0, 10
         # la $a0, ($t1)
         syscall        

	
