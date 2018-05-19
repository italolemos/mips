.data
    message: .asciiz "The numbers are equal"
    message2: .asciiz "The numbers are not equal"
.text
    main:
        addi $t0, $zero, 10
        addi $t1, $zero, 10
        
        beq $t0, $t1, numbersEqual
        bne $t0, $t1, numbersNotEqual
        beq
    
       # end of the program
       li $v0, 10
       syscall
    
    numbersEqual:
        li $v0, 4
        la $a0, message
        syscall
    
    numbersNotEqual:
        li $v0, 4
        la $a0, message2
        syscall