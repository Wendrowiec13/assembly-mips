.data
bottom: .word 0
empty:    .asciiz     "The stack is empty.\n"
input:    .asciiz "1-push a number to stack 2-pop number from stack 3-close"

.text
main:
sw $sp, bottom

loop:
li $v0, 4
la $a0, input
syscall
li $v0, 5
syscall 
move $t0, $v0

option1:    
bne $t0, 1, option2
jal push
j loop

option2:    
bne $t0, 2, option3
jal pop
j loop

option3: 
bne $t0, 3, loop
li $v0, 10
syscall
j loop

push:
li $v0, 6
syscall
mfc1 $t0, $f0

subi $sp, $sp, 4
sw $t0, ($sp)
jr $ra

pop_notempty:
lw  $t0, ($sp)
addi $sp, $sp, 4
mtc1 $t0, $f12
li $v0, 2
syscall       
li $v0, 11
li $a0, '\n'
syscall
jr $ra

pop:
lw $t0, bottom
blt $sp, $t0, pop_notempty
li $v0, 4
la $a0, empty
syscall 
jr $ra