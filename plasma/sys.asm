include sys.inc
include stub.inc

.386p
locals

code32 segment para public use32
    assume cs:code32,  ds:code32

;------------------------------------------------------------
;    in:    eax - size of block in bytes
;    out:    eax - handle (0 if error occured)
;        ebx - base address
;------------------------------------------------------------

alloc_mem proc
    mov     cx, ax
    shr     eax, 16
    mov     bx, ax
    mov     ax, 0501h
    int     31h
    jnc     @@ok

    xor     eax, eax
    ret
@@ok:
    shl     ebx, 16
    mov     bx, cx
    sub     ebx, code32_base
    mov     ax, si
    shl     eax, 16
    mov     ax, di
    ret
endp

;------------------------------------------------------------
;    in:    eax - handle
;    out:    none
;------------------------------------------------------------

free_mem proc
    mov     di, ax
    shr     eax, 16
    mov     si, ax
    mov     ax, 0502h
    int     31h
    ret
endp

;------------------------------------------------------------
;    in:    esi - offset to null-terminated string
;        al - color
;        ecx - x
;        edx - y
;    out:    none
;------------------------------------------------------------

put_string proc
    mov     _sx, ecx
    mov     _sy, edx
    mov     _sc, al

@@new_line:
    mov     edi, edx
    shl     edi, 6
    shl     edx, 8
    add     edi, edx
    add     edi, ecx
    add     edi, frame_buffer

    mov     ah, al
@@char:
    lodsb
    or      al, al
    jz      @@quit
    cmp     al, 10
    jne     @@line_ok

      ; next line
    mov     ecx, _sx
    add     _sy, 12
    mov     edx, _sy
    mov     al, _sc
    jmp     @@new_line

@@line_ok:
      ; draw letter
    push    edi
    mov     dl, ah
    movzx   ebx, al
    shl     ebx, 3
    add     ebx, font_addr

    mov     ch, 8
@@hor:
    mov     cl, 8
    mov     al, byte ptr [ebx]
@@ver:
    rcl     al, 1
    jnc     @@next
    mov     byte ptr [edi], dl
@@next:
    inc     edi
    dec     cl
    jnz     @@ver
    inc     ebx
    add     edi, 312
    inc     dl
    dec     ch
    jnz     @@hor
    pop     edi

      ; next letter
    add     edi, 8
    jmp     @@char
@@quit:
    ret
endp

init_font proc
    push    ebp
    mov     ebp, esp
    sub     esp, size dpmi_regs

    mov     edi, esp
    mov     dword ptr [edi._eax], 00001130h
    mov     dword ptr [edi._ebx], 00000300h
    mov     eax, 0300h
    mov     ebx, 10h
    int     31h

    movzx   eax, word ptr [edi._es]
    shl     eax, 4
    movzx   ebx, word ptr [edi._ebp]
    add     eax, ebx
    sub     eax, code32_base
    mov     font_addr, eax

    mov     esp, ebp
    pop     ebp
    ret
endp

clear_buffer proc
    mov     edi, frame_buffer
    xor     eax, eax
    mov     ecx, 64000/4
    cld
    rep     stosd
    ret
endp

copy_buffer proc
    mov     esi, frame_buffer
    mov     edi, _a0000h
    mov     ecx, 64000/4
    cld
    rep     movsd
    ret
endp

wait_for_vsync proc
    mov     edx, 03dah
@@r1:
    in      al, dx
    test    al, 8
    jz      @@r1
@@r2:
    in      al, dx
    test    al, 8
    jnz     @@r2
    ret
endp

;------------------------------------------------------------
;    in:    esi - offset to palette
;    out:    none
;------------------------------------------------------------

set_palette proc
    mov     edx, 03c8h
    xor     eax, eax
    out     dx, al
    inc     edx
    mov     ecx, 768
    cld
    rep     outsb
    ret
endp

;------------------------------------------------------------
;    in:    edi - offset to palette
;    out:    none
;------------------------------------------------------------

get_palette proc
    mov     edx, 03c7h
    xor     eax, eax
    out     dx, al
    add     edx, 2
    mov     ecx, 768
    cld
    rep     insb
    ret
endp

unset_mode13h proc
    mov     edi, offset dpmi_regs
    mov     [edi._eax], 000003h
    mov     eax, 0300h
    mov     ebx, 10h
    int     31h
    ret
endp

set_mode13h proc
    mov     ebp, esp
    sub     esp, size dpmi_regs

    mov     edi, esp
    xor     eax, eax
    mov     ecx, (size dpmi_regs) / 4
    cld
    rep     stosd

    mov     eax, 0a0000h
    sub     eax, code32_base
    mov     _a0000h, eax

    mov     edi, offset dpmi_regs
    mov     [edi._eax], 000013h
    mov     eax, 0300h
    mov     ebx, 10h
    int     31h

    mov     esp, ebp
    ret
endp

_sx dd ?
_sy dd ?
_sc db ?

font_addr dd ?

_a0000h dd ?
frame_buffer dd ?

code32 ends

end
