.data
    
.text
    addi $t0, $zero, 2000
    addi $t1, $zero, 10
    
    mult $t0, $t1
    
    # print results
    
    mflo $s0
    
    li $v0, 1
    add $a0, $zero, $s0 # o inteiro que quero impririr esta em $s0
    syscall