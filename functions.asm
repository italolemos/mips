.data
     message: .asciiz "Italo Lemos. \nHi, Everybody.\n"
.text
    main:
        jal displayMessage
        
    # Stop the execution   
    li $v0, 10
    syscall
            
    displayMessage:
         li $v0, 4   # display text
         la $a0, message
         syscall
         
         jr $ra