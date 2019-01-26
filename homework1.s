################################################################
# Name: Wenbin Wu
# Program: MIPS hw1
# Last modified: 24JUN17
#
# Description:
# Prompt the user to enter an integer between -20 and 5, repeat 
# if int1 is out of range, then prompt the user to input another
# integer less than 0, repeat if int2 is out of range.
# Calculate the result of 8*int1 - int2, then print the result
# to the screen.
#
# Pseudo-code:
# cout << prompt for int1;
# cin >> int1;
# if (int1 < -20 || int1 > 5) prompt for int1 again;
# cout << prompt for int2;
# cin >> int2;
# if (int2 >= 0) prompt for int2 again;
# compute result = 8*int1 - int2;
# cout << result;
#
# Registers:
# $s0 : store int1
# $s1 : store int2
# $t0 : counter for loop
# $t1 : temp storage for 8*int1
# $s2 : store 8*int1 - int2
#
################################################################

.data
	input1:		.asciiz "Enter an integer between -20 and 5:\n"
	input2:		.asciiz "Enter an integer less than 0:\n"
	output:		.asciiz "The result of 8*int1 - int2 is:\n"
	newline:	.byte '\n'
	
.text
	main:

	firstInput:  # prompt for int1, and store it
		la $a0, input1
		li $v0, 4
		syscall
		jal input	
		move $s0, $v0

		#  check if int1 is within range
		#  enter again if the number is 
		#  both less than -20 and 6 or
		#  both more than -20 and 6
		slti $t0, $s0, -20
		slti $t1, $s0, 6  #  check against 6 to include number 5
		beq $t0, $t1, firstInput
	
	secondInput:  # prompt for int2, and store it
		la $a0, input2
		li $v0, 4
		syscall
		jal input
		move $s1, $v0
		bgez $s1, secondInput

		# compute 8 * int1, store result in $t1
		addi $t0, $zero, 1  # counter
		move $t1, $s0	
	loop:	
		add $t1, $t1, $s0  # $t1 = $t1 + $s0
		addi $t0, $t0, 1  # counter++
		bne $t0, 8, loop

		# subtract the second integer from the frist
		sub $s2, $t1, $s1

		# print the result
		la $a0, output
		li $v0, 4
		syscall
		move $a0, $s2
		li $v0, 1
		syscall
		la $a0, newline
		li $v0, 4
		syscall
		
		# repeat the program 
		j main

	# input procedure
	input:
		li $v0, 5
		syscall
		beq $v0, 100, exit  # if input match sentinal, exit program
		jr $ra

	exit:
		li $v0, 10
		syscall