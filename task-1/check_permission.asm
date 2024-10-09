%include "../include/io.mac"

extern ant_permissions

extern printf
global check_permission

section .text

check_permission:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     eax, [ebp + 8]  ; id and permission
    mov     ebx, [ebp + 12] ; address to return the result
    ;; DO NOT MODIFY

    ;; Your code starts here

    mov edx, eax
    shr edx, 24             ; id-ul furnicii
    and eax, 0x00FFFFFF     ; cei 24 de biti reprezentand camerele dorite
    xor ecx, ecx            ; curatam registrul ecx
    mov ecx, dword[ant_permissions + 4 * edx] ; numarul ai carui biti 
    ;reprezinta permisiunea/nepermisiunea pentru camera j
    mov [ebx], dword 0      ; initial, presupun ca nu poate rezerva
    xor ebx, ebx
    xor edx, edx

parcurgere_biti:
    inc ebx                 ; contor pentru numarul de biti 
    cmp ebx, 24             ; numarul total de biti 
    je rezervare_reusita
    mov edx, 1
    test eax, edx           ; se testeaza doar ultimul bit
    jz nu_doreste 
    test edx, ecx 
    jz rezervare_nereusita  ; nu are permisiune

nu_doreste:
    shr eax, 1              ; shiftam la dreapta bitii,
    shr ecx, 1              ; in orice scenariu
    jmp parcurgere_biti

rezervare_reusita:
    mov ebx, [ebp + 12]
    mov [ebx], dword 1

rezervare_nereusita: 
    ;; Your code ends here
    
    ;; DO NOT MODIFY

    popa
    leave
    ret
    
    ;; DO NOT MODIFY
