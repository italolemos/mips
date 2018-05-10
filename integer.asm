.data
    age: .word 23

.text
    li $v0, 1   # preparar para imprimir um inteiro
    lw $a0, age
    syscall
   
    