%include "../include/io.mac"

; declare your structs here

struc creds
    .passkey: resw 1
    .username: resb 51
endstruc

struc request
    .admin: resb 1
    .prio: resb 1
    .login_creds: resb creds_size
endstruc

section .text
    global check_passkeys
    extern printf

check_passkeys:
    ;; DO NOT MODIFY
    enter 0, 0
    pusha

    mov ebx, [ebp + 8]      ; requests
    mov ecx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ;
    ;; DO NOT MODIFY

    ;; Your code starts here

    xor esi, esi                    ; i-ul
    xor edi, edi                    ; offset-ul
    mov esi, -1
    sub esp, 4

iteratie_parola:
    inc esi
    mov [ebp - 4], esi
    mov edi, request_size
    imul edi, esi
    mov esi, [ebp - 4]
    xor edx, edx
    mov ebx, [ebp + 8]
    mov dx, word[ebx + edi + 2]     ; mut in dx passkey 
    xor eax, eax
    xor ecx, ecx
    mov al, dl                      ; in al vor fi bitii nesemnificativi
    test al, 1
    jz nu_e_hacker
    and eax, 0xFE                   ; scap de ultimul bit pentru a nu incurca
    mov dx, word[ebx + edi + 2]     
    shr edx, 8
    mov cl, dl                      ; in cl vor fi cei mai semnificativi biti
    test ecx, 0x80
    jz nu_e_hacker
    and ecx, 0x0000007F             ; scap de 1 de pe pozitia 7
    mov [ebp - 4], esi              ; contor pentru cei mai putini semnificativi biti
    xor esi, esi
    xor ebx, ebx

ceimaiputinisemnificativi:
    test eax, 1                     ; vreau sa aflu ce e pe ultima pozitie
    jnz adaugare_par                ; daca e 1
    jmp continuare

adaugare_par:
    inc ebx

continuare:
    shr eax, 1
    inc esi
    cmp esi, 8
    jne ceimaiputinisemnificativi
    xor esi, esi
    test ebx, 1                     ; testez sa vad daca e par
    jnz nu_e_hacker                 ; daca nu e par, nu e hacker
    xor ebx, ebx                   
    xor esi, esi                    ; contor si pentru cei mai semnificativi

ceimaisemnificativi:
    test ecx, 1
    jnz adaugare_impar
    jmp continuare2

adaugare_impar:
    inc ebx

continuare2:
    shr ecx, 1
    inc esi
    cmp esi, 8
    jne ceimaisemnificativi
    test ebx, 1                     ; daca contorul este par
    jz nu_e_hacker                  ; nu e hacker

    mov esi, [ebp - 4]              ; restabilesc i ul din for
    xor edi, edi
    mov edi, [ebp + 16]
    mov [edi + esi], byte 1

verificare:
    xor edi, edi                    ; verific daca sunt la final
    mov edi, [ebp + 12]
    sub edi, 1                      ; de la 0 la n - 1
    cmp esi, edi
    jne iteratie_parola
    jmp final

nu_e_hacker:
    xor esi, esi
    mov esi, [ebp - 4]              ; mutam de pe stiva i ul pentru a sti unde pune
    mov edi, [ebp + 16]
    mov [edi + esi], byte 0         ; la pozitia i punem 0
    jmp verificare                  ; trecem la o noua parola

final:
    add esp, 4
    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY