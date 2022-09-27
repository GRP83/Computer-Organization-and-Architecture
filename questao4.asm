.data
	
	vetor1: .word 6,2,4,6,5,7,9,8,9,1
	vetor2: .word 5,3,4,5,6,8,9,1,6,5
	vetor3: .space 40
	
	enter: .asciiz " \n "
	virg: .asciiz ","
	
	desvetor1: .asciiz "Vetor1: "
	desvetor2: .asciiz "Vetor2: "
	desvetor3: .asciiz "Vetor3: "

.text
main:

	#carrega posicao de memoria dos vetores para os registradores						
	la $a0, vetor1 #carrega posicao memoria vetor 1
	la $a1, vetor2 #carrega posicao memoria vetor 2
	la $a2, vetor3 #carrega posicao memoria vetor 3
		
	#carrega controle de tamanho maximo dos vetor1, vetor2, vetor3,para poder avançar pelo sregistros
	li $t3, 40
	
	#define registrador para controle do avanco nas posicoes dos vetores
	li $t4, 0

avança_dentro_dos_vetores:
	beq $t4, $t3, fim #verifica se os valores dos vetores já foram totalmente varridos, se já foram chama a função fim
	
	lw $s1, vetor1($t4) #avança a posição do vetor para proximo valor do vetor1
	lw $s2, vetor2($t4) #avança a posição do vetor para proximo valor do vetor2
	lw $s3, vetor3($t4) #avança a posição do vetor para proximo valor do vetor3

	beq $s1,$s2, multiplicacao #verifica se o valor da posicao atual do vetor1 é igual ao valor da posicao atual do vetor 2, se for chama a multiplicacao
	
	slt $s7,$s1,$s2 #verifica se o valor da posicao atual do vetor1 é menor do que o valor da posicao atual do vetor 2, se for o resutlado de $s7 será 1, se não for o resultado de $s7 será 0
	beq $s7, 1, multiplicacao #no caso de ser menor $s7 = 1, entao chama a multiplicacao
	beq $s7, 0, divisao #no caso de ser maior $s7 = 0, entao chama a divisao
		
			
multiplicacao:
	move $t6, $s1 #registrador usado para guardar o valor a ser usado como  multiplicando da operação de multiplicação
	move $t8, $s2 #registrador usado para guardar o valor a ser usado como  multiplicador da operação de multiplicação
	move $t9, $zero   #registrador usado para guardar o controle de loop(repetições) necessárias para implementar a multiplicação através de somas sucessivas.
	move $t7, $zero   #registrador utilizado para guardar o resultado da multiplicação

	move $t7, $t6    #executa primeira instrução de soma, o que significa multiplicacao por 1
        addi $t9, $t9, 1 #incrementa o controle de loop (repetição) em uma unidade
        
multiplica: #executa a multiplicacao atraves de somas consecutivas, através de loop controlado pelo segundo termo da multiplicacao guardado no registrador $t8. o qual é comparado com $t9 (incrementado a cada repetição do loop)
	
	beq $t8, $t9, fim_operacao #assim que o limite de repetições for alcançado, chamamos o procedimento fim da operação.
	   add $t7, $t7, $t6 #adiciona mais uma unidade do multiplicando ao resultado
	   addi $t9, $t9, 1 #incrementa uma unidade no registrador de controle do total de laços a serem executados no loop
	   j multiplica #chama novamente o loop, até encerrar a necessidade de repetições que é testado na entrada pelo beq
	   
divisao:
	move $t6, $s1 #registrador usado para guardar o valor a ser usado como  multiplicando da operação de multiplicação
	move $t8, $s2 #registrador usado para guardar o valor a ser usado como  multiplicador da operação de multiplicação
	move $t9, $zero   #registrador usado para guardar o controle de loop(repetições) necessárias para implementar a multiplicação através de somas sucessivas.
	move $t7, $zero   #registrador utilizado para guardar o resultado da multiplicação

	sub $t7, $t6, $t8 #executa primeira instrução de soma		
        addi $t9, $t9, 1 #incrementa o controle de loop (repetição)
divide:
	beq $t8, $t9, fim_operacao #assim que o limite de repetições for alcançado, chamamos o procedimento fim da operação.
	   sub $t7, $t6, $t8 #diminui uma unidade do dividendo do registrador de controle do total de laços a serem executados no loop
	   addi $t9, $t9, 1 #incrementa uma unidade no registrador de controle do total de laços a serem executados no loop
	   j divide #chama novamente o loop, até encerrar a necessidade de repetições que é testado na entrada pelo beq
	   
fim_operacao:
	sw $t7,vetor3($t4) #apos o calculo de multiplicacao ou divisao, guarda o valor de resultado do calculo na posição atual do vetor 3
        addi $t4, $t4, 4 #incrementa 4 no registrador $t4 que controla a posição atual dos tres vetores sendo varridos.
	j avança_dentro_dos_vetores #chama novamente a rotina para que se avance para a proxima posicao dos vetores
	   
fim:

	li $v0, 4 # imprime um enter
	la $a0, enter
	syscall	

	li $v0, 4 # imrpime label de descricao do vetor 1
	la $a0, desvetor1
	syscall	

	li $v0, 4 # imprime um enter
	la $a0, enter
	syscall	
		
	move $t0, $zero #zera o controle para imprimir os elementos do vetor
	move $t9, $zero #zera o controle para imprimir os elementos do vetor
	addi $t9, $t9, 40  #atualiza para 40, que é o tamanho de todos os vetores
	
	j imprime_vetor1 #imprime elementos do vetor 1

	li $v0, 4 # imprime virgula
	la $a0, virg
	syscall
	
controla_impressao_vetor1:

	beq $t0,$t9, prepara_variaveis_imprime_vetor2 #contorle a impressao de todos os elementos do vetor1, e ao final chama a impressao dos elementos do vetor 2
	li $v0, 4 # carrega o código de imprimir string para imrimir o texto que vai ser apresentado ao usuario

	la $a0, virg #immprime virgula para separar elementos
	syscall
	j imprime_vetor1 #chama a rotina novamente ate que todos os elementos do vetor 1 sejam impressos

imprime_vetor1:	
	li $v0, 1 	
	lw $a0, vetor1($t0) #imprime o valor do elementos atual
	syscall
	addi $t0, $t0, 4 #incrementa controle para avançar para proximo elemento 
	j controla_impressao_vetor1 #chama novamente ate que todos os valroes do vetor sejam varridos	
	
prepara_variaveis_imprime_vetor2:
	li $v0, 4 # imprime um enter
	la $a0, enter
	syscall	
	li $v0, 4 # imrpime label de descricao do vetor 1
	la $a0, desvetor2
	syscall
	li $v0, 4 # imprime um enter
	la $a0, enter
	syscall
	
	move $t0, $zero
	move $t9, $zero
	addi $t9, $t9, 40
	j imprime_vetor2
	li $v0, 4 # carrega o código de imprimir string para imrimir o texto que vai ser apresentado ao usuario
	la $a0, virg
	syscall
	
controla_impressao_vetor2:
	beq $t0,$t9, prepara_variaveis_imprime_vetor3
	li $v0, 4 # carrega o código de imprimir string para imrimir o texto que vai ser apresentado ao usuario
	la $a0, virg
	syscall
	j imprime_vetor2 

imprime_vetor2:	
	li $v0, 1	
	lw $a0, vetor2($t0)
	syscall
	addi $t0, $t0, 4
	j controla_impressao_vetor2
	

prepara_variaveis_imprime_vetor3:
	li $v0, 4 # carrega o código de imprimir string para imrimir o texto que vai ser apresentado ao usuario
	la $a0, enter
	syscall	
	li $v0, 4 # carrega o código de imprimir string para imrimir o texto que vai ser apresentado ao usuario
	la $a0, desvetor3
	syscall
	li $v0, 4 # carrega o código de imprimir string para imrimir o texto que vai ser apresentado ao usuario
	la $a0, enter
	syscall	
	move $t0, $zero
	move $t9, $zero
	addi $t9, $t9, 40
	j imprime_vetor3
	li $v0, 4 # carrega o código de imprimir string para imrimir o texto que vai ser apresentado ao usuario
	la $a0, virg
	syscall
	
controla_impressao_vetor3:
	beq $t0,$t9, encerra
	li $v0, 4 # carrega o código de imprimir string para imrimir o texto que vai ser apresentado ao usuario
	la $a0, virg
	syscall
	j imprime_vetor3 

imprime_vetor3:	

	li $v0, 1	
	lw $a0, vetor3($t0)
	syscall

	addi $t0, $t0, 4
	j controla_impressao_vetor3
			
encerra:	 
	li $v0, 10 #encerra programa
	syscall	

imprime_enter:
	li $v0, 4 # imprime enter
	la $a0, enter
	syscall	