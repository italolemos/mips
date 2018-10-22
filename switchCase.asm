.data
     tabela: .word L0, L1, L2, L3
.text
     li $s1, 15   #g
     li $s2, 20   #h
     li $s3, 10   #i
     li $s4, 5    #j
     li $s5, 0   #k
     
     la $t4, tabela  # $t4 endereços da tabela
     
     # testar se k é menor que zero
     slt $t3, $s5, $zero
     bne $t3, $zero, exit      # se $t3 for 1 vai pro exit

     # testar se k é menor que 4
     slti $t3, $s5, 4
     beq $t3, $zero, exit      # se $t3 for maior que 4 vai pro exit
     
     sll $t1, $s5, 2
     add $t1, $t1, $t4
     lw $t0, 0($t1)
     
     jr $t0
     
L0: 
    add $s0, $s3, $s4
    j exit    
L1:
   add $s0, $s1, $s2  
   j exit
L2:
   sub $s0, $s1, $s2
   j exit
L3:
  sub $s0, $s3, $s4
  j exit
     
         
     
exit:
     li $v0, 10
     syscall
     
