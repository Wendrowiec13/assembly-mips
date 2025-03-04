	.data
	
initial_msg: .asciiz "Please provide a seed\n"
new_line: .asciiz "\n"
	
	.text
main:
	li $v0, 4
	la $a0, initial_msg
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0
	
	# set seed to user input and set id of random number generator
	li $v0, 40
	li $a0, 0
	move $a1, $t0
	syscall

li $t3, 0 #initialize big_loop counter

big_loop:
	li $t2, 0
	
generate_char:
	li $a0, 0  # initialize id of random number generator
	li $a1, 123 # intialize upper bound
	li $v0, 42 # generate random int from 0 to 123
	syscall
	
	move $t1, $a0
	
	# check if generated int is equivalent to 0-9 or a-z or A-Z in ASCII
	beq $t1, 33, continue
	beq $t1, 35, continue
	beq $t1, 36, continue
	blt $t1, 48, generate_char
	bgt $t1, 57, third_check
	j fourth_check
	third_check:
		blt $t1, 65, generate_char
	fourth_check:
		bgt $t1, 90, fifth_check
	j continue
	fifth_check:
		blt $t1, 97, generate_char
		
	continue:
		li $v0, 11
		move $a0, $t1
		syscall
	
		addi $t2, $t2, 1
		blt $t2, 10, generate_char

addi $t3, $t3, 1
li $v0, 4
la $a0, new_line
syscall
blt $t3, 10, big_loop
	