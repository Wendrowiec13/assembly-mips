# casear cipher
	.data
	buffer: .space 17
	
	.text
main:
	li $v0, 5 # ask user what he wants to do 0 - cipher 1 - decipher 2 - modification
	syscall
	move $t5, $v0
	
	li $v0, 8 # input string
        la $a0, buffer # load byte space into address
        li $a1, 17 # allocate the byte space for string
        syscall
        
        la $t0, buffer
        move $t0, $a0 # save string to t0
        
        blt $t5, 2, nonModified # if user wants to just cipher or decipher something
        
        li $v0, 12 # load first letter from user
        syscall
        
        move $t1, $v0 # move first letter to $t1
        
        li $t2, 0 # initialize counter
        
        add $t4, $t0, $t2
        lb $t3, 0($t4) # load character from string
        sub $t1, $t1, $t3
        la $a0, ($t1)
        li $v0, 1
        syscall
        j cipherLoop
        
        nonModified:
        	li $v0, 5 # load key
        	syscall
        	move $t1, $v0
        	
        	li $t6, 26
        	div $t1, $t6
        	mfhi $t1
        
        	beq $t5, $zero, cipherLoop # go to cipher loop
        	beq $t5, 1, decipherLoop # go to decipher loop

cipherLoop:
	add $t4, $t0, $t2
        lb $t3, 0($t4) # load character from string
        beq $t3, 10, exit # exit if enter is encountered
        beq $t3, $zero, exit # exit if end of string
        ble $t3, 90, capitalLetter
        
        addu $t3, $t3, $t1 # shift character by key
        bgt $t3, 122, substract # so that z + 1 = a
        blt $t3, 97, addition # so that a - 1 = z
        j continue
        addition:
        	addi $t3, $t3, 26
        	j continue
        substract:
        	subi $t3, $t3, 26
        continue:
       		sb $t3, 0($t4) # save character
        	addi $t2, $t2, 1 # increment counter
        	j cipherLoop
        
        capitalLetter:
        	addu $t3, $t3, $t1 # shift character by key
        	bgt $t3, 90, capitalSubstract # so that Z + 1 = A
        	blt $t3, 65, capitalAdd # so that A - 1 = Z
        	j capitalContinue
        	capitalAdd:
        		addi $t3, $t3, 26
        		j capitalContinue
        	capitalSubstract:
        		subi $t3, $t3, 26
        	capitalContinue:
        		sb $t3, 0($t4) # save character
        		addi $t2, $t2, 1 # increment counter
        		j cipherLoop

decipherLoop:
	add $t4, $t0, $t2
        lb $t3, 0($t4) # load character from string
        beq $t3, 10, exit # exit if enter is encountered
        beq $t3, $zero, exit # exit if end of string
        ble $t3, 90, capitalLetterDecipher
        
        subu $t3, $t3, $t1 # shift character by key
        bgt $t3, 122, substractDecipher # so that z + 1 = a
        blt $t3, 97, additionDecipher # so that a - 1 = z
        j continueDecipher
        additionDecipher:
        	addi $t3, $t3, 26
        	j continueDecipher
        substractDecipher:
        	subi $t3, $t3, 26
        continueDecipher:
       		sb $t3, 0($t4) # save character
        	addi $t2, $t2, 1 # increment counter
        	j decipherLoop
        
        capitalLetterDecipher:
        	subu $t3, $t3, $t1 # shift character by key
        	bgt $t3, 90, capitalSubstractDecipher # so that Z + 1 = A
        	blt $t3, 65, capitalAddDecipher # so that A - 1 = Z
        	j capitalContinueDecipher
        	capitalAddDecipher:
        		addi $t3, $t3, 26
        		j capitalContinueDecipher
        	capitalSubstractDecipher:
        		subi $t3, $t3, 26
        	capitalContinueDecipher:
        		sb $t3, 0($t4) # save character
        		addi $t2, $t2, 1 # increment counter
        		j decipherLoop

exit:
	la $a0, buffer # reload byte space to primary address
        move $a0, $t0 # primary address = t0 address (load pointer)
        li $v0, 4 # print string
        syscall
        li $v0, 10 # end program
        syscall
	