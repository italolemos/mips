.data
v: .word
 
.text
li $t1,1
li $t2,10
li $t3,0
la $t4,v

loop:
   sw $t1,0($t4)
   addi $t4,$t4,4
   addi $t3,$t3,1
   bne $t2,$t3,loop
   syscall