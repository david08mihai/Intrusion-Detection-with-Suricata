%include "../include/io.mac"

extern printf
extern position
global solve_labyrinth

; you can declare any helper variables in .data or .bss

section .text

; void solve_labyrinth(int *out_line, int *out_col, int m, int n, char **labyrinth);
solve_labyrinth:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; unsigned int *out_line, pointer to structure containing exit position
    mov     ebx, [ebp + 12] ; unsigned int *out_col, pointer to structure containing exit position
    mov     ecx, [ebp + 16] ; unsigned int m, number of lines in the labyrinth
    mov     edx, [ebp + 20] ; unsigned int n, number of colons in the labyrinth
    mov     esi, [ebp + 24] ; char **a, matrix represantation of the labyrinth
    ;; DO NOT MODIFY
   
    ;; Freestyle starts here
    xor eax, eax            ; i
    xor ebx, ebx            ; j
 

verificare_totala:

verificare_iesire:          ; verific daca am gasit iesirea
    inc eax
    cmp eax, [ebp + 16]
    je iesire_gasita_linie
    dec eax
    inc ebx
    cmp ebx, [ebp + 20]
    je iesire_gasita_coloana
    dec ebx

verificare_dreapta:
    inc ebx                             ; ma mut pe casuta din dreapta, de pe pozitia i
    cmp ebx, [ebp + 20]                 ; verific daca acea casuta nu e cumva in afara matricei
    jne verificare_suplimentara_dreapta ; daca nu e in afara, verific daca totusi in dreapta este 0

urmator_dreapta:                   ; label de a reveni din label-ul verificare_suplimentara_dreapta
    dec ebx                        ; daca e in afara, ma mut inapoi si verific alta mutare posibila

verificare_jos:
    inc eax
    cmp eax, [ebp + 16]
    jne verificare_suplimentara_jos

urmator_jos:
    dec eax

verificare_sus:
    dec eax
    cmp eax, -1
    jne verificare_suplimentara_sus

urmator_sus:
    inc eax
    
verificare_stanga:
    dec ebx
    cmp ebx, -1
    jne verificare_suplimentara_stanga

urmator_stanga:
    inc ebx
jmp verificare_totala

verificare_suplimentara_dreapta:
    mov ecx, [esi + eax * 4]                    ; mutam in ecx adresa de la linia i(eax)
    cmp byte[ecx + ebx], 0x31                   ; comparam daca blocul este 1
    je urmator_dreapta                          ; daca este 1, mergem sa incercam alte mutari
    jmp mutare_dreapta                          ; daca nu este 1, se face mutarea la dreapta

verificare_suplimentara_jos:
    mov ecx, [esi + eax * 4]
    cmp byte[ecx + ebx], 0x31
    je urmator_jos
    jmp mutare_jos 

verificare_suplimentara_sus:
    mov ecx, [esi + eax * 4]
    cmp byte[ecx + ebx], 0x31
    je urmator_sus
    jmp mutare_sus

verificare_suplimentara_stanga:
    mov ecx, [esi + eax *4]
    cmp byte[ecx + ebx], 0x31
    je urmator_stanga
    jmp mutare_stanga

mutare_dreapta:
    dec ebx                         
    mov byte[ecx + ebx], 0x31       ; punem 1 in blocul in care am fost
    inc ebx
    jmp verificare_totala           ; verific daca urmatorul bloc este valid(0 sau in matrice)

mutare_jos:
    dec eax
    mov ecx, [esi + eax * 4]
    mov byte[ecx + ebx], 0x31
    inc eax
    jmp verificare_totala

mutare_stanga:
    inc ebx
    mov byte [ecx + ebx], 0x31
    dec ebx
    jmp verificare_totala


mutare_sus:
    inc eax
    mov ecx, [esi + eax * 4]
    mov byte [ecx + ebx], 0x31
    dec eax
    jmp verificare_totala

iesire_gasita_linie:                ; daca am gasit linia pentru iesire
    dec eax
    xor ecx, ecx
    xor edx, edx
    mov ecx, eax                    ; mut in ecx linia
    mov edx, ebx                    ; mut in edx coloana
    mov eax, [ebp + 8]              ; restabilesc adresa de pe stiva
    mov ebx, [ebp + 12]
    mov [eax], ecx                  ; pun la adresa respectiva indexul liniei
    mov [ebx], edx                  ; si al coloanei
    jmp end

iesire_gasita_coloana:
    xor ecx, ecx
    xor edx, edx
    mov ecx, eax
    mov edx, ebx
    dec edx
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]
    mov [eax], ecx
    mov [ebx], edx
    
    ;; Freestyle ends here
end:
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
