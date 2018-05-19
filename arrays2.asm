.data 
    intArray: .word 100:3
    myArray: .space 12   # Aloca espaco na memoria RAM
    newLine: .asciiz "\n"

.text
main:
    addi $s0, $zero, 4
    addi $s1, $zero, 10
    addi $s2, $zero, 12
    
    # index = $t0
    addi $t0, $zero, 0
    
    sw $s0, myArray($t0)   # store na localizacao 0, primeira posicao
    addi $t0, $t0, 4        # incrimenta o index
    
    sw $s1, myArray($t0)   # append na segunda posicao
    addi $t0, $t0, 4
    
    sw $s2, myArray($t0)
    
    # Recuperar valores
    lw $t6, myArray($t0)
    
    
    # clear $t0
    addi $t0, $zero, 0
    
    while:
         beq $t0, 12, exit
         
         lw $t6, myArray($t0)
         addi $t0, $t0, 4   # incrementa o iterador do index
         
         # print numero atual
         li $v0, 1
         move $a0, $t6
         syscall
         
          # print new line
         li $v0, 4
         la $a0, newLine 
         syscall
         
         j while
    
    exit:
        li $v0, 10
    	syscall
    
    
    
        