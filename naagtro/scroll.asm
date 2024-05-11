include stub.inc
include sys.inc
include scroll.inc

.386p

code32 segment para public use32
    assume cs:code32,  ds:code32

init_scroll proc

    mov     edi, offset scroll_buffer
    xor     eax, eax
    mov     ecx, 320*8/4
    cld
    rep     stosd

      ; get font address
    mov     edi, offset _regs
    mov     dword ptr [edi._eax], 00001130h
    mov     dword ptr [edi._ebx], 00000300h
    mov     eax, 0300h
    mov     ebx, 10h
    int     31h
    
    movzx   eax, word ptr [edi._es]
    shl     eax, 4
    movzx   ebx, word ptr [edi._ebp]
    add     eax, ebx
    sub     eax, dword ptr [code32_base]
    mov     dword ptr [ptr_font], eax

    ret
endp

do_scroll proc
    cmp     curr_line, 8
    jne     @@next
    mov     curr_line, 0
    inc     curr_letter
@@next:

    mov     esi, curr_letter
    add     esi, offset scroll_text
    lodsb
    or      al, al
    jnz     @@string_ok

    mov     curr_letter, 0
@@string_ok:

    shl     eax, 3
    add     eax, ptr_font
    mov     esi, eax

    mov     edi, offset scroll_buffer
    add     edi, 319
      ; text color
    mov     dl, 64

    mov     ch, 8
@@put_dot:
    lodsb
    mov     cl, byte ptr curr_line
    rcl     al, cl
    jnc     @@next_dot

    mov     byte ptr [edi], dl
@@next_dot:
    add     edi, 320
    inc     dl
    dec     ch
    jnz     @@put_dot

    inc     curr_line

      ; move text
    mov     esi, offset scroll_buffer
    mov     edx, 8
@@ver:
    mov     ecx, 320 - 2
    push    esi
    xor     al, al
    mov     edi, esi
    stosb
    add     esi, 2
    rep     movsb
    stosb
    pop     esi
    add     esi, 320
    dec     edx
    jnz     @@ver

      ; draw scroller
    mov     edi, frame_buffer
    add     edi, 64000-8*320-320
    mov     esi, offset scroll_buffer
    mov     ecx, 8*320
@@put_pix:
    lodsb
    or      al, al
    jz      @@next_pix
    mov     byte ptr [edi], al
@@next_pix:
    inc     edi
    dec     ecx
    jnz     @@put_pix

    ret
endp


scroll_text db 'New Age Assembler Group proudly presents '
 db 'a short intro made by Majuma in pure 32-bit Assembler. * * * '
 db 'If you want to join our group or just have any reason for '
 db 'contacting us, visit our web page: www.naag.prv.pl * * * '
 db 'Greetings for all members of NAAG: HaRv3sTeR, Klemik, '
 db 'tOudi, SEM, pkmiecik, Overlord, Oolv, Miodzio, asmCode, '
 db '_TeStON_, Zedd and anybody I forgot . . .'

db 30 dup(32), 0

scroll_buffer db 320*8 dup(?)
curr_letter dd ?
curr_line dd ?

ptr_font dd ?
_regs dpmi_regs ?

code32 ends

end
