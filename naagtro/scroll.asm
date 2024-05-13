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

    call    init_font
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
    add     eax, dword ptr [font_addr]
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
curr_letter dd 0
curr_line dd 0

code32 ends

end
