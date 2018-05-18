.data 
 message: .asciiz "Digite um número\n"
 numero:  .word 1
 quadrado: .word 1

.text
  main:
   # imprime a mensagem
   li $v0, 4
   la $a0, message
   syscall
   
   # lê inteiro
   li $v0, 5
   syscall
   
   #grava o numero na memoria
   sw $v0, numero
   
   # calcula o quadrado
   mul $t0, $v0, $v0
   
   # grava o quadrado
   sw $t0, quadrado
   
   # imprime inteiro
   li $v0, 1
   move $a0, $t0
   syscall
   