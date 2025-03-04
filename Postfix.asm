.data
prompt1:	.asciiz		"Enter a string containing a postfix expression: "
finalState:	.asciiz		"The total is "
newLine:	.asciiz		"\n"
buffer:		.space 		256
stack:		.space		256
#variable declarations
#c = $t5
#d = $t6
.text
.globl main
main:
    la $a0, prompt1
    addi $v0, $zero, 4
    syscall

    li $v0, 8 # read string to buffer
    la $a0, buffer
    li $a1, 64
    syscall

    li $t0, 0	# stackSize = $t0
    li $t1, 0	# val = $t1
    li $t2, 0	# i = $t2
    li $t3, 1	# multiplier = $t3
    while:
        la $s0, newLine # \n = $s0
        la $s1, buffer  # buffer = $s1
        li $s2, ' '
        li $s3, '+'
        li $s4, '-'
        li $s5, '*'
        li $s6, '/'
        la $s7, stack # stack = $s7

    	add $t7, $t2, $s1
    	lb $t5, 0($t7) # c = buffer[i]
    	beq $t5, $s0, afterWhile
    	beq $t5, $zero, afterWhile
    	addi $t2, $t2, 1 # i++

    	add $t7, $t2, $s1
    	lb $t6, 0($t7) # d = buffer[i+1]
    	add $t7, $t2, $s1
    	lb $t8, 0($t7)
    	sub $t7, $t2, $s1
    	
    	if1:
            beq $t5, $s2, while #if(c == ' ')
        if2:
       	    bne $t5, 36, if3  
            addi $sp, $sp, -16 # if(c == '$')
            sw $t1, 12($sp)
            sw $t2, 8($sp)
            sw $t3, 4($sp)
            sw $ra, 0($sp)

            move $a0, $t0
            jal superAddStack
            move $t0, $v0

            lw $ra, 0($sp)      
            lw $t3, 4($sp)
            lw $t2, 8($sp)
            lw $t1, 12($sp)
            addi $sp, $sp, 16
    	    b while
    	if3:
   	    bne $t5, 94, if3A
            addi $sp, $sp, -16 # if(c == '^')
            sw $t1, 12($sp)
            sw $t2, 8($sp)
            sw $t3, 4($sp)
            sw $ra, 0($sp)

            move $a0, $t0
            jal secondPowerStack
            move $t0, $v0

            lw $ra, 0($sp)      
            lw $t3, 4($sp)
            lw $t2, 8($sp)
            lw $t1, 12($sp)
            addi $t2, $t2, 1
            addi $sp, $sp, 16
    	    b while
        if3A:
            bne $t5, $s3, if4  
            addi $sp, $sp, -16 # if(c == '+')
            sw $t1, 12($sp)
            sw $t2, 8($sp)
            sw $t3, 4($sp)
            sw $ra, 0($sp)

            move $a0, $t0
            jal addStack
            move $t0, $v0

            lw $ra, 0($sp)      
            lw $t3, 4($sp)
            lw $t2, 8($sp)
            lw $t1, 12($sp)
            addi $sp, $sp, 16
    	    b while
        if4:
            bne $t5, $s5, if5 
            addi $sp, $sp, -16
            sw $t1, 12($sp) # if(c == '*')
            sw $t2, 8($sp)
            sw $t3, 4($sp)
            sw $ra, 0($sp)

            move $a0, $t0
            jal multStack
            move $t0, $v0

            lw $ra, 0($sp)      
            lw $t3, 4($sp)
            lw $t2, 8($sp)
            lw $t1, 12($sp)
            addi $sp, $sp, 16
            b while
        if5:
            bne $t5, $s6, if5A # if(c == '/')
            addi $sp, $sp, -16
            sw $t1, 12($sp)
            sw $t2, 8($sp)
            sw $t3, 4($sp)
            sw $ra, 0($sp)

            move $a0, $t0
            jal divStack
            move $t0, $v0

            lw $ra, 0($sp)      
            lw $t3, 4($sp)
            lw $t2, 8($sp)
            lw $t1, 12($sp)
            addi $sp, $sp, 16
            b while
        if5A:

            beq $t5, $s4, if5B # if (c == '-')
            b afterIfs
            if5B:
                slti $t4, $t6, '1'  
                bgtz $t4, insideIfs #if((d <= '0')
            if5C:
                slti $t4, $t6, '9'
                bgtz $t4, afterIfs  #if(d >= '9')
            insideIfs:
                addi $sp, $sp, -16
                sw $t1, 12($sp)
                sw $t2, 8($sp)
                sw $t3, 4($sp)
                sw $ra, 0($sp)

                move $a0, $t0
                jal subStack
                move $t0, $v0

                lw $ra, 0($sp)      
                lw $t3, 4($sp)
                lw $t2, 8($sp)
                lw $t1, 12($sp)
                addi $sp, $sp, 16
                b while
        afterIfs:
            li $t1, 0
            li $t3, 1

        while2:
            beq $t5, $s2, afterWhile2   #(c != ' ')
            beq $t5, $zero, afterWhile2 #(c != '\0')
            beq $t5, $s0, afterWhile2   #(c != '\n')
            if6:
                bne $t5, $s4, if7A
                li $t3, -1
            if7A:
                slti $t4, $t5, '0'  
                bgtz $t4, afterIfs2
                if7B:
                    slti $t4, $t5, ':'  
                    beq $t4, $zero, afterIfs2
                    li $t9, 10
                    mult $t9, $t1       
                    mflo $t9            # $t9 = val*10
                    li $t8, '0'
                    sub $t7, $t5, $t8   # $t7 = c-'0'
                    add $t1, $t9, $t7   # val = (val*10) + (c-'0')
            afterIfs2:
                add $t7, $t2, $s1
                lb $t5, 0($t7)      # c = buffer[i]
                addi $t2, $t2, 1    # i++
                b while2
        afterWhile2:
            mult $t1, $t3
            mflo $t1            # val = val * multiplier
            add $t7, $t0, $s7
            sb $t1, 0($t7)      # stack[stackSize] = val
            addi $t0, $t0, 1
            b while
    afterWhile:
        la $a0, finalState
        addi $v0, $zero, 4
        syscall # print final message
        addi $t9, $t0, -2
        add $t8, $t9, $s7
        lb $a0, 0($t8)
        addi $v0, $zero, 1
        syscall
        li $t2, 0
        li $t5, '('
        li $t6, ')'
        infixLoop:
        	add $t4, $t2, $s1
        	lb $t3, 0($t4) # load character from string
        	#li $v0, 11
        	#la $a0, ($t3)
        	#syscall
        	addi $t2, $t2, 1
        	beq $t3, $s2, infixLoop
        	beq $t3, $s3, pushOperatorToStack
        	beq $t3, $s4, pushOperatorToStack
        	beq $t3, $s5, pushOperatorToStack
        	beq $t3, $s6, pushOperatorToStack
        	addi $sp, $sp, -4
        	sw $t3, 0($sp)
        	beq $t3, 10, printInfix # exit if enter is encountered
        	beq $t3, $zero, printInfix # exit if end of string
        	j infixLoop
        pushOperatorToStack:
        	lw $t7, 0($sp)
        	lw $t8, 4($sp)
        	addi $sp, $sp, 8
        	addi $sp, $sp, -20
        	sw $t6, 0($sp)
        	sw $t7, 4($sp)
        	sw $t3, 8($sp)
        	sw $t8, 12($sp)
        	sw $t5, 16($sp)
        	j infixLoop
        printInfix:
        	lw $t9, 0($sp)
        	beq $t3, 10, exit # exit if enter is encountered
        	beq $t3, $zero, exit # exit if end of string
        	addi $sp, $sp, 4
        	li $v0, 11
        	move $a0, $t9
        	syscall
        	j printInfix
        exit:
    		li $v0, 10
    		syscall
addStack:
    la $t1, stack # stack = $t1
    addi $t2, $a0, -2
    addi $t3, $a0, -1
    add $t2, $t1, $t2
    add $t3, $t1, $t3
    lb $t4, 0($t2)
    lb $t5, 0($t3)
    add $t0, $t4, $t5 # result = $t0
    sb $t0, 0($t2)
    addi $a0, $a0, -1 # stackSize = $a0
    move $v0, $a0
    jr $ra

multStack:
    la $t1, stack
    addi $t2, $a0, -2
    addi $t3, $a0, -1
    add $t2, $t1, $t2
    add $t3, $t1, $t3
    lb $t4, 0($t2)
    lb $t5, 0($t3)
    mult $t4, $t5
    mflo $t0
    sb $t0, 0($t2)
    addi $a0, $a0, -1
    move $v0, $a0
    jr $ra

divStack:
    la $t1, stack
    addi $t2, $a0, -2
    addi $t3, $a0, -1
    add $t2, $t1, $t2
    add $t3, $t1, $t3
    lb $t4, 0($t2)
    lb $t5, 0($t3)
    div $t4, $t5
    mflo $t0
    sb $t0, 0($t2)
    addi $a0, $a0, -1
    move $v0, $a0
    jr $ra

subStack:
    la $t1, stack
    addi $t2, $a0, -2
    addi $t3, $a0, -1
    add $t2, $t1, $t2
    add $t3, $t1, $t3
    lb $t4, 0($t2)
    lb $t5, 0($t3)
    sub $t0, $t4, $t5
    sb $t0, 0($t2)
    addi $a0, $a0, -1
    move $v0, $a0
    jr $ra

superAddStack:
    la $t1, stack
    addi $t2, $a0, -3
    addi $t3, $a0, -2
    addi $t4, $a0, -1
    add $t2, $t1, $t2
    add $t3, $t1, $t3
    add $t4, $t1, $t4
    lb $t5, 0($t2)
    lb $t6, 0($t3)
    lb $t7, 0($t4)
    add $t0, $t6, $t5
    add $t0, $t0, $t7
    sb $t0, 0($t2)
    addi $a0, $a0, -2
    move $v0, $a0
    jr $ra

secondPowerStack:
    la $t1, stack
    addi $t2, $a0, -1
    add $t2, $t1, $t2
    lb $t4, 0($t2)
    mul $t0, $t4, $t4
    sb $t0, 0($t2)
    addi $a0, $a0, -1
    move $v0, $a0
    jr $ra