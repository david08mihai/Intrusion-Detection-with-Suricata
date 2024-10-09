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
    global sort_requests
    extern printf

sort_requests:
    ;; DO NOT MODIFY
    enter 0,0
    pusha
    mov ebx, [ebp + 8]      ; requests
    mov ecx, [ebp + 12]     ; length
    ;; DO NOT MODIFY

    ;; Your code starts here
    ;; Your code ends here
    sub esp, 12
    xor eax, eax                ; offset ul pentru i-ul
    xor edx, edx                ; offset ul pentru j-ul
    xor esi, esi                ; i ul efectiv
    xor edi, edi                ; j ul efectiv
    mov esi, -1

fori:
    inc esi
    mov ecx, [ebp + 12]         ; pun numarul de request-uri
    dec ecx                     ; decrementez, i ul merge pana la n - 1(i < n)
    cmp esi, ecx                ; vad daca am ajuns la n - 1
    je final                    ; daca da, merg la final
    xor ebx, ebx
    mov ebx, request_size
    mov eax, esi
    imul eax, ebx               ; eax = offset-ul pentru i
    mov edi, esi                ; la fiecare iteratie prin forul i, adaug in j
    jmp forj                    ; i-ul, urmand a-l incrementa(j = i + 1)
    mov edi, esi
forj:
    inc edi ; i + 1
    cmp edi, [ebp + 12]         ; verific daca ies din numarul de request-uri(j <= n)
    je fori           
    xor ebx, ebx
    mov ebx, request_size
    mov edx, edi
    imul edx, ebx               ; edx = offset-ul pentru j
    mov ebx, [ebp + 8]          ; salvez j-ul pe stiva
    xor ecx, ecx
    mov cl, byte[ebx + eax]     ; in sta cl .admin de la pozitia i
    cmp cl, 0                  
    je i_este0
    jmp i_nu_este0

i_este0:
    cmp cl, byte[ebx + edx]     ; compar 0 cu elementul de la pozitia j
    je comparare_prioritate     ; daca elementul de la pozitia j este 0
    jmp interschimbare         

i_nu_este0:
    cmp cl, byte[ebx + edx]     ; compar 1 cu elementul de pe pozitia j
    je comparare_prioritate     ; daca j este 1 trebuie intrat in comparatie de prioritati
    jmp forj                    ; daca e 0, nu se modifica nimic

comparare_prioritate:
    xor ecx, ecx
    mov cl, byte[ebx + eax + 1] ; in cl am adaugat prioritatea pentru i
    cmp cl, byte[ebx + edx + 1] ; compar prioritatea lui i cu a lui j
    je comparare_username
    cmp cl, byte[ebx + edx + 1]
    ja interschimbare           ; daca e mai putin, o las la fel
    jmp forj                    ; altfel, daca e mai mare, interschimb

comparare_username:
    mov cl, byte[ebx + eax + 4] ; mut in i primul byte din username(primam litera)
    cmp cl, byte[ebx + edx + 4] ; compar cu litera de la pozitia j
    je comparare_suplimentara   ; daca sunt egale, mergem pe pozitia urmatoare
    cmp cl, byte[ebx + edx + 4]
    jl forj                     
    ja interschimbare                    


comparare_suplimentara:
    mov [ebp - 8], esi          ; pastrez pe stiva i ul si j ul
    mov [ebp -12], edi
    xor esi, esi
    xor edi, edi
    add esi, eax              
    add edi, edx
    add esi, 4
    add edi, 4
reluare:
    inc esi                     ; creez offset pentru i
    inc edi                     ; creez offset pentru j
    mov cl, byte[ebx + esi]
    cmp cl, byte[ebx + edi]
    je reluare                  ; daca tot sunt egale, mergem la urmatorul caracter
    cmp cl, byte[ebx + edi]
    mov esi, [ebp - 8]          ; restauram i ul si j ul
    mov edi, [ebp - 12]
    jg interschimbare
    jmp forj


interschimbare:
    xor ecx, ecx
    mov ecx, [ebx + eax]
    mov [ebp - 4], ecx          ; temp = a
    mov ecx, [ebx + edx]        ; salvez si b ul pe stiva
    mov [ebx + eax], ecx
    mov ecx, [ebp - 4]
    mov [ebx + edx], ecx        ;  am schimbat primii 4 octeti(admin, prio si passkey)
    mov [ebp - 8], esi          ; salvez i-ul
    xor ecx, ecx
    xor esi, esi                ; contor pentru cele 51/4 iteratii

schimbare_username:
    add eax, 4                  ; ma mut la primul octet din username
    add edx, 4
    mov ecx, [ebx + eax]
    mov [ebp - 4], ecx          ; temp = a
    mov ecx, [ebx + edx] 
    mov [ebx + eax], ecx        ; a = b
    mov ecx, [ebp - 4]
    mov [ebx + edx], ecx        ; b = a
    inc esi
    cmp esi, 12
    je ultimii_doi_octeti
    jmp schimbare_username

ultimii_doi_octeti:
    add eax, 4                  ; mai avem doar 2 caractere de copiat
    add edx, 4                  ; pe care le pun in
    xor ecx, ecx
    mov [ebp - 4], ecx          ; ma asigur ca in ebp - 4 am 0
    mov cx, [ebx + eax]
    mov [ebp - 4], cx
    mov cx, [ebx + edx]
    mov [ebx + eax], cx
    mov cx, [ebp - 4]
    mov [ebx + edx], cx
    sub eax, 52
    sub edx, 52
    mov esi, [ebp - 8]          ; restaurez i-ul
    jmp forj

final:
    add esp, 12                 ; refac stiva
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY