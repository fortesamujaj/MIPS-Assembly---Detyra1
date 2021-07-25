.data				
messageOne:	.asciiz "Enter the number of terms of series : "
messageTwo:	.asciiz "\nFibonnaci Series : "
messageThree:	.asciiz " "		

.text
.globl main

main:
	#Printimi i stringut: "Enter the number of terms of series : "

	li   $v0, 4					# System call code per print_str
	la   $a0, messageOne		# Adresa e string-ut per printim
	syscall						# Printo string-un
	
	#Leximi i numrit x nga tastiera
	
	li   $v0, 5					# System call code per read_int
	syscall						# Vlera e x tashme gjendet ne $v0
	
	#Ruajtja e vleres se regjistrit $v0 ne $t1
	
	addi $t1, $v0, 0			# (x) ruaje inputin ne regjistrin $t1
	
	#Printimi i stringut: "\nFibonnaci Series : "
	
	li   $v0, 4					# System call code per print_str
	la   $a0, messageTwo		# Adresa e string-ut per printim
	syscall						# Printo string-un
	
	#Inicializimi i vleres se regjistrit $a0
	
	addi $a0, $zero, 0			# $a0 --> i, i=0

   #-------------------------While Loop-----------------------------------#
	
loop:
	#Kushti if(i>=x) perfundo main funksionin
	
	bge  $a0, $t1, done			# Nese $a0 >= $t1 goto etiketa done
	
	#Alokimi i hapsires ne stack
	
	addi $sp, $sp, -4			# Alokimi i 4 bytes ne stack per i
	sw   $a0, 0($sp)			# E "push" i ne stack.
	jal fibonnaci				# Thirret funksioni fibonnaci.
	
	#Printimi i returned value te funksionit fibonnaci
	
	addi $a0, $v0, 0
	li   $v0, 1					# System call code per print_int
	syscall						# Printo integer-in
	
	#Printimi i stringut: " "
	
	li   $v0, 4					# System call code per print_str
	la   $a0, messageThree		# Adresa e string-ut per printim
	syscall						# Printo string-un
	
	#Dealokimi i hapsires se rezervuar ne stack
	
	lw   $a0, 0($sp)			# E "restore" $a0 origjinale
	addi $sp, $sp, 4			# E "pop" $a0 nga stack
	
	#Inkrementimi i argumentit per 1
	addi $a0, $a0, 1			# i++
	
	#Vazhdo perseri me unazen
	j loop						# jump to loop ose goto loop

done:
	#Exit the main function
	li   $v0, 10				# System call code per exit
	syscall

   #------------------------Fibonnaci Function----------------------------#
   
fibonnaci:

	#Kodi i dhene per kushtin (x==1)||(x==0)
	
	beq   $a0, 1, 	return_one	# Nese x==1 kthe 1, ose goto return_one
	beqz  $a0,	return_zero		# Nese x==0 kthe 0, ose goto return_zero
	
	#Alokimi i hapsires se nevojshme ne memorie
	
	addi  $sp, $sp, -12			# Alokimi i hapsires ne stack per 3 numra te plote
	sw    $ra,  8($sp)			# $ra -> $sp + 8
	sw    $a0,  4($sp)			# $a0 -> $sp + 4 
	
	#fib(x-1) + fib (x-2)
	
	addi  $a0, $a0, -1			# x-1
	jal fibonnaci				# fib(x-1)
	sw    $v0, 0($sp)			# fib(x-1) -> $sp + 0
	
	lw    $a0, 4($sp)			# E "restore" parametrin origjinal
	addi  $a0, $a0, -2			# x-2
	jal fibonnaci				# fib(x-2)

	
	lw   $t0, 0($sp)			# fib(x-1) -> $t0
	add  $v0, $t0, $v0			# fib(x-1) + fib(x-2) -> $v0
	
	#Dealokimi i hapsires se rezervuar ne stack
	
	lw   $ra, 8($sp)			# E "restore" return adresen
	addi $sp, $sp, 12			# Dealokon hapsiren ne stack
	jr   $ra					# Kce te return address
	
return_one:

	#Kthimi i vleres 1
	
	addi  $v0, $zero, 1			# Vlera 1 vendoset ne $v0
	jr $ra						# Kce te return address
	
return_zero:
	
	#Kthimi i vleres 0
	
	addi  $v0, $zero, 0			# Vlera 0 vendoset ne $v0
	jr $ra						# Kce te return address
	

	

	
	
	