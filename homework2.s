################################################################
# Name: Wenbin Wu
# Program: MIPS hw2
# Last modified: 29JUN17
#
# Description:
# Prompt the user to enter an integer k between 1 and 10, repeat 
# if k is out of range, then run 2 different cases depending on 
# value of k.
#
# case1: prompt for 10 integer inputs between 0 and 100, for each
# integer, display the the integer, store it in an array in reverse
# order, then display the array in normal order.
#
# case2: display a joke.
#
# Pseudo-code:
# cout << prompt for k;
# cin >> k;
# if (k < 1 || k > 10) cin > k;
# if (k < 5) goto case1;
# else goto case2;
# case1:
# while (i >= 0 && i <= 100) 
#	cout << i;
#	array[reverse order] = i;
#	cout << array
# case2:
#	cout << joke;
#
# Registers:
# $t9 : load prompt texts for use in input function
# $t8 : store the negative of the upper bound of range to 
#		check input integer against
# $t0 : holds memory addr of the array
# $t1 : holds memory addr of appropriate element in the array
#		to store input
# $t2 : loop counter
# $t4 : copy of $t1, used by printArray function
# $t5 : loop counter, used by printArray function
#
################################################################

.data
	array:		.space 40
	prompt:		.asciiz "Enter an integer between 1 and 10:\n"
	prompt2:	.asciiz "\nEnter a integer between 0 and 100:\n"
	invalid:	.asciiz "Invalid input, integer out of range. Exiting program...\n"
	joke1:		.asciiz "Question: What is the object-oriented way to become very wealthy?"
	joke2:		.asciiz "Answer: Multiple Inheritance."
	text1:		.asciiz "\nInteger entered: "
	text2:		.asciiz "\nArray elements: "
	space: 		.byte ' '

.text
main:
	la $t9, prompt  # prompt for integer k
	jal input
	
	blez $v0, main  # if k less or equal to zero, prompt for input again
	addi $t8, $v0, -10
	bgtz $t8, main # if k greater than 10, prompt for input again
	

	# jump to 2 different cases depending on input
	addi $t8, $v0, -5
	bgez $t8, case1  # if 5 <= k <= 10, goto case1
	j case2  # else go to case2

case1:
		la $t0, array  # $t0 =  base addr of array
		la $t1, 36($t0)  # $t1 = addr of last empty element of array
		li $t2, 0  # loop counter

	loop:
		la $t9, prompt2  # prompt for input
		jal input
		
		bltz $v0, error  # if k < 0, the input is out of range 
		addi $t8, $v0, -100 
		bgtz $t8, error  # if k > 100, the input is out of range
		
		sw $v0, ($t1)  # store the integer in the array
		addi $t2, $t2, 1  # increase loop counter
		
		li $v0, 4  # print text1
		la $a0, text1
		syscall
		li $v0, 1  # print the entered integer
		lw $a0, ($t1)
		syscall
		li $v0, 4  # print text2
		la $a0, text2
		syscall
		la $t4, ($t1)  # copy of $t1
		li $t5, 0  # loop counter for printing array elements
		jal printArray  # print every element stored in the array so far
		
		addi $t1, $t1, -4  # decrease the offset for array element
		bne $t2, 10, loop  # loop for input again
		j done

	printArray:
		lw $a0, ($t4)  # $a0 = array[i*4]
		li $v0, 1
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		
		addi $t4, $t4, 4
		addi $t5, $t5, 1  # counter++
		bne $t5, $t2, printArray # if print counter = input loop counter, then all elements entered are printed

		jr $ra
		
		# if integer input is invalid, exit the program
	error:
		li $v0, 4
		la $a0, invalid
		syscall
		j done

case2:
		li $v0, 4
		la $a0, joke1
		syscall
		
		li $v0, 4
		la $a0, space
		syscall
		
		li $v0, 4
		la $a0, joke2
		syscall
		
		j done

	# input function
input:	
	li $v0, 4
	la $a0, ($t9)
	syscall

	li $v0, 5
	syscall

	jr $ra

done:
	li $v0, 10
	syscall