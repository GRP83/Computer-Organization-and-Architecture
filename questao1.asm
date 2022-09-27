.data
	pergunta: .asciiz "Digite valor inteiro a ser encontrado: "
	resposta: .asciiz "A quantidade de transferências entre vetores foi: "
	enter: .asciiz " \n "
	
	vetor1: .word 1,2,3,44,55,6,7,8,9,11
	vetor2: .space 40


.text
main:
	
	#pede valor ao usuario
	li $v0, 4 # carrega o código de imprimir string para imrimir o texto que vai ser apresentado ao usuario
	la $a0, pergunta
	syscall

	#leitura/gravacao do inteiro digitado pelo usuario
	li $v0, 5 
	syscall

	#guarda valor digitado pelo usuario no registrador $t1
	move $t1, $v0

	#carrega posicao dos vetores para os registradores						
	la $a0, vetor1 #carrega posicao memoria vetor 1
	la $a1, vetor2 #carrega posicao memoria vetor 2
	
	#carrega controle de tamanho maximo dos vetores
	li $t2, 40
	#define registrador para controle do avanco nas posicoes dos vetores
	li $t3, 0
	#zera $v0, uma vez que vamos guardar nele o numero de trasnferencias efetuadas entre os vetores
	move $v0, $zero

transfere_valor:
	beq $t2, $a0, fim #verifica se o valor se o vetor já foi totalmente varrido, se foi encerra o programa
	#transfere conteudo do vetor 1 para o vetor 2	
	sw $a0, vetor2($t3) #transfere valor vetor 1 para vetor 2	
	addi $v0, $v0, 1#adiciona 1 ao contador de numeor de iterações
	beq $a0, $t1, fim #verifica se o valor sendo transferido é igual ao valor digitado pelo usuario, se nao for encerra o programa	
	addi $t3, $t3, 4 #adiciona mais 4 para passar para proxima posicao do vetor	
	lw $a0, vetor1($t3) #carrega proximo valro do vetor 1
	j transfere_valor #se chegou ate aqui chama novamente a rotina
	
fim:
	move $s1, $v0
	#pede valor ao usuario
	li $v0, 4 # carrega o código de imprimir string para imrimir o texto que vai ser apresentado ao usuario
	la $a0, resposta
	syscall

	li $v0, 1 # carrega o código de imprimir string		
	la $a0, ($s1) #imprime numero de vezes que a transferencia entre vetores foi efetuada
	syscall
	
	li $v0, 10 #encerra programa
	syscall																														


