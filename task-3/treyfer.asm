section .rodata
	global sbox
	global num_rounds
	sbox db 126, 3, 45, 32, 174, 104, 173, 250, 46, 141, 209, 96, 230, 155, 197, 56, 19, 88, 50, 137, 229, 38, 16, 76, 37, 89, 55, 51, 165, 213, 66, 225, 118, 58, 142, 184, 148, 102, 217, 119, 249, 133, 105, 99, 161, 160, 190, 208, 172, 131, 219, 181, 248, 242, 93, 18, 112, 150, 186, 90, 81, 82, 215, 83, 21, 162, 144, 24, 117, 17, 14, 10, 156, 63, 238, 54, 188, 77, 169, 49, 147, 218, 177, 239, 143, 92, 101, 187, 221, 247, 140, 108, 94, 211, 252, 36, 75, 103, 5, 65, 251, 115, 246, 200, 125, 13, 48, 62, 107, 171, 205, 124, 199, 214, 224, 22, 27, 210, 179, 132, 201, 28, 236, 41, 243, 233, 60, 39, 183, 127, 203, 153, 255, 222, 85, 35, 30, 151, 130, 78, 109, 253, 64, 34, 220, 240, 159, 170, 86, 91, 212, 52, 1, 180, 11, 228, 15, 157, 226, 84, 114, 2, 231, 106, 8, 43, 23, 68, 164, 12, 232, 204, 6, 198, 33, 152, 227, 136, 29, 4, 121, 139, 59, 31, 25, 53, 73, 175, 178, 110, 193, 216, 95, 245, 61, 97, 71, 158, 9, 72, 194, 196, 189, 195, 44, 129, 154, 168, 116, 135, 7, 69, 120, 166, 20, 244, 192, 235, 223, 128, 98, 146, 47, 134, 234, 100, 237, 74, 138, 206, 149, 26, 40, 113, 111, 79, 145, 42, 191, 87, 254, 163, 167, 207, 185, 67, 57, 202, 123, 182, 176, 70, 241, 80, 122, 0
	num_rounds dd 10

section .text
	global treyfer_crypt
	global treyfer_dcrypt

; void treyfer_crypt(char text[8], char key[8]);
treyfer_crypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha

	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key	
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_crypt
	xor eax, eax
	xor ebx, ebx
	xor edx, edx 				; contor pentru numarul de runde
	movzx eax, byte[esi]		; byte-ul 0 din text

runda_noua:
	xor ecx, ecx 				; i-ul (itereatorul prin cei 8 biti)

iteratie_biti:
	sub esp, 8
	xor ebx, ebx
	movzx ebx, byte[edi + ecx]	; am copiat byte-ul i din key
	add eax, ebx
	and eax, 0x000000FF 		; pentru overflow
	mov ebx, eax
	movzx eax, byte[sbox + eax] ; substitutia, t = sbox[t]
	mov [ebp - 4], ecx 			; pun i-ul pe stiva
	inc ecx  
	cmp ecx, 8 					; verific daca urmatorul bit este egal cu 8
	je primul_bit
	jmp continuare

primul_bit:
	xor ecx, ecx 				; in caz afirmativ, urmatorul byte va fi 0

continuare:
	movzx ebx, byte[esi + ecx]
	add eax, ebx 				; adaug urmatorul byte la t
	and eax, 0x000000FF 
	shl eax, 1 					; mut la stanga
	test eax, 0x100 			; testez sa vad daca bit-ul 8 este 1
	jz nu_overflow
	or eax, 1 					; setez ultimul bit pe 1
	and eax, 0x000000FF
	
nu_overflow:
	mov ecx, [ebp - 4]			; restabilesc i ul
	mov [ebp - 4], eax 			; salvez t ul pe stiva
	mov [ebp - 8], ecx 			; salvez i ul pe stiva
	inc ecx 			
	mov al, cl 					; mutam deimpartitul in eax(i + 1)
	mov ebx, 8
	div bl 						
	xor ecx, ecx 				; golim registrul pentru a pune restul
	mov cl, ah 					; restul se va afla in ah
	mov eax, [ebp - 4]
	mov byte[esi + ecx], al 	; mut t-ul pe al (i+1) % 8 bit
	xor ecx, ecx
	mov ecx, [ebp - 8] 			; restabilesc i-ul
	add esp, 8 					; restabilesc stiva
	inc ecx
	cmp ecx, 8		
	jne iteratie_biti
	inc edx
	cmp edx, [num_rounds]
	jne runda_noua			
    ;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

; void treyfer_dcrypt(char text[8], char key[8]);
treyfer_dcrypt:
	;; DO NOT MODIFY
	push ebp
	mov ebp, esp
	pusha
	mov esi, [ebp + 8] ; plaintext
	mov edi, [ebp + 12] ; key	
	;; DO NOT MODIFY
	;; FREESTYLE STARTS HERE
	;; TODO implement treyfer_dcrypt

	xor edx, edx 				; numar runde
runda_nouad:
	xor ecx, ecx
	mov ecx, 7					
iteratie_bitid:
	sub esp, 4
	xor ebx, ebx
	xor eax, eax 			
	movzx eax, byte[esi + ecx] 	; mut in top byte ul text[i]
	movzx ebx, byte[edi + ecx] 	; mut in ebx byte ul key[i]
	add eax, ebx
	and eax, 0x000000FF			; in caz de overflow
	mov ebx, eax
	movzx eax, byte[sbox + ebx] ; top
	mov [ebp - 4], ecx 			; pun i-ul pe stiva
	inc ecx
	cmp ecx, 8					; verific daca urmatorul bit este 8
	je primul_bitD
	jmp continuareD

primul_bitD:
	xor ecx, ecx

continuareD:
	xor ebx, ebx
	movzx ebx, byte[esi + ecx]
	test ebx, 0x00000001 		; iau ultimul bit
	jnz setare_bit_rotire		
	jmp nupunenimic

setare_bit_rotire:
	shr ebx, 1					; shiftez la dreapta
	or ebx, 0x00000080 			; pun pe bitul 7 valoarea 1
	jmp sarire

nupunenimic:
	shr ebx, 1

sarire:
	sub ebx, eax 				; bottom - top, rezultat in bl
	and ebx, 0x000000FF
	xor ecx, ecx
	mov ecx, [ebp - 4]			; restaurez i-ul
	xor eax, eax
	mov eax, ecx 				
	mov [ebp - 4], ecx 			; mut i-ul inapoi pe stiva
	inc eax
	cmp eax, 8					; (i + 1) % 8
	je resetare_iteratie
	jmp continuare_iteratie

resetare_iteratie:
	xor eax, eax				; daca urmatorul bit este 8, se reseteaza
continuare_iteratie:

	mov byte[esi + eax], bl		; in caz contrat, ramane (i+1)
	mov ecx, [ebp - 4]			; restabilesc i-ul
	add esp, 4					; restabilesc stiva
	sub ecx, 1
	cmp ecx, -1					; daca am ajuns la sfarsitul iteratiei pe cei 8 biti
	jne iteratie_bitid
	inc edx
	cmp edx, [num_rounds]
	jne runda_nouad
	;; FREESTYLE ENDS HERE
	;; DO NOT MODIFY
	popa
	leave
	ret

