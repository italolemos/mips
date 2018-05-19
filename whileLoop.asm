.data
    

.text
    main:
        # i = 0
        addi $t0, $zero, 0
        
        
        while:
             bgt $t0, 10, exit  # condicao de saida
             
             # printa o interador a cada chamada
             li $v0, 1
             add $a0,$zero, $t0
             syscall
             
             addi $t0, $t0, 1   # i++
             
             j while            # retorna para o loop
           
        exit:
            li $v0, 10
            syscall