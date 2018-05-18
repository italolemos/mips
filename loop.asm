.data
 v: .word 10

.text
 main:
  li $t0, 1    #contador
  li $t1, 10   #numero de elementos do vetor
  li $t2, 0
  
  la $t3, v    # la carrega endereco na memoria da variavel
  
   loop:
     sw $t0,0($t3)
     addi $t3,$t3, 4    #4bytes de avanço
     addi $t2,$t2,1 
     bne $t1,$t2, loop
     
     
  