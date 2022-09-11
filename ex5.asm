.data 
	pergunta: .asciiz "Digite o número que deseja calcular o fatorial: "
	numero: .word
	resposta: .asciiz "O fatorial desse número é:  "
.text 
main:

	jal guarda_valor   #pula para a função para guardar o valor
	
	jal fatorial       #pula para a função que calcularo fatorial
	
	li $v0, 4          #imprime a frase da resposta
	la $a0, resposta
	
	syscall
	
	li $v0, 1 	   #imprime o valor do cálculo do fatorial
	move $a0, $t0 
	syscall
	
	li $v0, 10         #termina o programa
	syscall
	
guarda_valor: #função para realizar a pergunta e guardar o valor

	li $v0, 4         #faz a pergunta ao usuário
	la $a0, pergunta
	
	syscall
	
	li $v0, 5         #guarda a resposta do usuário
	la $a1, numero
	
	syscall
	
	move $t0, $v0      #guarda o fatorial em $t0
	move $t1, $v0      #guarda o fatorial em $t1
	move $t2, $v0      #guarda o fatorial em $t2
	
	addi $t2, $t2, -1  #registrador t2 para percorrer os valores do fatorial
	
	jr $ra            #retorna para a main
	
fatorial: #função que as comparações necessárias para o cálculo do fatorial
	
	li $s6, 1              #registrador usado para comparação
	bne $t1, $s6, soma     #se $t1 não for igual a $s6 vai para a função soma
	addi $t2, $t2, -1      #diminui o registrador para percorrer os valores do fatorial
	move $t0, $t3          #guarda o valor da soma no registrador $t0
	move $t1, $t2	       #guarda o nmero que está percorrendo o fatorial no registrador $t1 utilizado na soma

	bne $t2, $s6, fatorial #pula para fatorial até que o registrador que está percorrendo chegue em 1
	
	jr $ra                 #retorna para a main
	
soma:  #função para realizar a soma sucessiva
	
	add $t3, $t3, $t0      #realiza a soma dos valores
	addi $t1, $t1, -1      #decresce para ser usado na comparação até chegar em 1
	j fatorial             #retorna para a função fatorial
