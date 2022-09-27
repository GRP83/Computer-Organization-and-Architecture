.data
vv: .ascizz "Digite até qual posição do vetor deseja fazer a soma (Max10): "
vet: 
.align 2
.word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9		#vetor de 10 posições

.text
main:
	#pergunta o valor de parada ao usuario
	li $v0, 4
	la $a0, vv
	syscall
	
	#scan do inteiro informado pelo usuario
	li $v0, 5
	syscall
	
	#move o valor informado pelo usuário ao registrador t1
	move $t1, $v0
	
	jal pos_vet
	
	li $t6, 0	#atribui o valor 0 ao registrador t6
	jal soma_vet
	
	jal imprime
	
	li $v0, 10 #encerra programa
	syscall	
	
#descobre até qual posição do vetor será feita a soma
pos_vet:
	li $t2, 4 #para calculo da posição do vetor
	mul $t3, $t1, $t2 #t3 guarda o valor total do vetor
	jr $ra

#faz a soma conforme a posição informada pelo usuário	
soma_vet:
	lw $t4, vet($t6)	#carrega o vetor para o registrador t4
	add $t5, $t5, $t4	#t5 armazena as somas
	addi $t6, $t6, 4	#t6 acrescido de 4 para pular para a proxima posição do vetor
	bgt $t3, $t6, soma_vet	#se t3 for maior que o t6, volta para o soma_vet
	jr $ra
	
imprime:
	li $v0, 1	#imprime inteiro
	la $a0, ($t5)	#valor final está armazenado em t5
	syscall
	jr $ra

	