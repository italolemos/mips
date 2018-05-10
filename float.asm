.data
    PI: .float 3.14
    
.text
    li $v0, 2 #code to print float
    lwc1 $f12, PI
    syscall