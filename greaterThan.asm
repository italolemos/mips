.data 
    message: .asciiz "The number is greater than the other"
    message2: .asciiz "The number is less than the other"

.text
    addi $t0, $zero, 1
    addi $t1, $zero, 200
    
    bgt $t0, $t1, printMessage
    # bgtz compara com zero
    blt $t0, $t1, printLessMessage  # less than
    
    li $v0, 10
    syscall
    
    printMessage:
         li $v0, 4
         la $a0, message
         syscall
    
    printLessMessage:
        li $v0, 4
        la $a0, message2
        syscall
           