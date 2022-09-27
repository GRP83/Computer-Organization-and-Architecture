#3. Implemente em assembly do MIPS um procedimento que compare elementos de dois vetores de 10
#posi��es. Para cada posi��o i dos vetores, verificar se o elemento do primeiro vetor � igual ou maior que o
#do segundo. Caso positivo, o conte�do do segundo vetor deve ser atualizado com o valor do primeiro
#vetor, na posi��o atualmente analisada. Caso negativo, a atualiza��o deve ocorrer no primeiro vetor, com
#o valor contido no segundo vetor.

.data 
	vetor1: .word 4, 7, 2, 5, 8, 1, 8, 3, 2, 1   # cria��o do vetor 1
	vetor2: .word 1, 2, 3, 8, 1, 8, 5, 2, 7, 4   # cria��o do vetor 2
.text 

main:
	
	la $s0, 0   # �ndice para percorrer o vetor
	
	li $s1, 40  # condi��o de parada
	
	jal carrega_vetor      # fun��o para carregar os valores do vetor
	
	jal compara_vetores    # pula para a fun��o de compara��o dos vetores
	
carrega_vetor:
	
	lw $t1, vetor1($s0)  #carrega a primeira posi��o do vetor 1 no registrador t1
	lw $t2, vetor2($s0)  #carrega a primeira posi��o do vetor 2 no registrador t2
	
	j compara_vetores
	
compara_vetores:
	
	bgt $t1, $t2, atualiza # se o conteudo da posi��o i do vetor 1 for igual ou maior o do vetor 2 ele atualiza a posi��o do vetor 2
	move $t1, $t2          # se for menor ele move o conteudo da posi��o i do vetor 2 para o vetor 1
	
	addi $s0, $s0, 4       #percorrer o vetor
	beq $s0, $s1, termina_programa  # caso chegue ao final do vetor encerra o programa
	
	j carrega_vetor
atualiza: 
	
	move $t2, $t1        # a posi��o i do vetor 2 receber o conteudo da posi��o i do vetor 1
	j compara_vetores    # volta para a fun��o que compara os vetores

termina_programa:

	li $v0, 10 #encerra programa
	syscall	