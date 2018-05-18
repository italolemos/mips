.data
     word1: .asciiz "italo"
     word2: .asciiz "lemos"
     array: .word word1 word2
     iterator: .word 0
     size:    .word 1
     end: .asciiz "\nend of loop"
     
.text
    main:
         la $s0, array
         la $t1, iterator
         la $t2, size
         
         li $t4, 0
         
         lw $t8, ($s0)
         
         li $v0, 4          # print string
         la $a0, ($t8)
         syscall
         
         
   
   countingWords:
                lb $a0, 0,($t8)
                beqz $a0, printSize
                addi $t1,$t1,1
                addi $t4, $t4, 1
		 
                j countingWords
   
   printSize:
            li $v0, 1
            move $a0, $t4
            syscall