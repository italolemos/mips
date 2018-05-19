.data
     message: .asciiz "Italo Lemos. \nHi, Everybody.\n"
.text
    main:
        jal displayMessage # jal executa a funcao
        
        addi $s0, $zero, 5
        
        # Executar outras ações após a função
        li $v0, 1
        add $a0, $zero, $s0
        syscall
        
        # Stop the execution   
        li $v0, 10
        syscall
            
    displayMessage:
         li $v0, 4   # display text
         la $a0, message
         syscall
         
         jr $ra     # volta para o lugar que chamou a funcao
