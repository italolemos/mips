.data
    file:    .asciiz "string.in"
    buffer:  .space 1024
    error:   .ascii "Arquivo não encontrado"
.text

    main:
        # open a file
        li $v0, 13    #open file
        la $a0, file  
        li $a1, 0     # flag for read only 0 = read; 1 write/create; 9 write/create/append
        li $a2, 0     # flag for ignore
        syscall       # open a file (file descriptor returned in $v0) 
    
    
        move $s0, $v0   # file descriptor saved in $s0
        

        # read file
        li   $v0, 14        #code to read file
        add  $a0, $s0, $0	
        la   $a1, buffer    # address of buffer from which to read
        li   $a2,  15     # hardcoded buffer length
        syscall             # read from file
    
        # print
        li $v0, 4          # print string
        la $a0, buffer
        syscall
    
 
        # close file
        li $v0, 16
        add $a0, $s0, $s0 
        syscall 


