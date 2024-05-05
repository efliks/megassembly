; (C) November 3, 2002  M. Feliks

include stub.inc
include sys.inc

.386p


code32 segment para public use32
    assume cs:code32, ds:code32

entrypoint:

    mov     eax, 64000 + 512 * 4 + 320 * 4
    call    alloc_mem
    or      eax, eax
    jnz     mem_ok
    ret

mem_ok:
    mov     dword ptr [MemHandle], eax
    mov     dword ptr [frame_buffer], ebx
    add     ebx, 64000
    mov     dword ptr [CosineTable], ebx

    finit
    fldz
    mov     ecx, 512
cos_make:
    fld     st
    fcos
    fmul    dword ptr [_63]
    fistp   dword ptr [ebx]
    fadd    dword ptr [DeltaAngle]
    add     ebx, 4
    loop    cos_make
    ffree   st

    mov     dword ptr [TempTable], ebx


    call    set_mode13h

    mov     edx, 03c8h
    xor     eax, eax
    out     dx, al
    inc     edx
    mov     ecx, 127
SetPalette1:
    out     dx, al
    out     dx, al
    xor     al, al
    out     dx, al
    inc     ah
    mov     al, ah
    shr     al, 1
    loop    SetPalette1
    mov     ecx, 128
SetPalette2:
    out     dx, al
    out     dx, al
    xor     al, al
    out     dx, al
    dec     ah
    mov     al, ah
    shr     al, 1
    loop    SetPalette2

MainLoop:

    mov     edi, dword ptr [TempTable]
    mov     ecx, 320
    mov     eax, dword ptr [p_x1]
    mov     dword ptr [tp_x1], eax
    mov     eax, dword ptr [p_x2]
    mov     dword ptr [tp_x2], eax
MakeTemp:
    mov     esi, dword ptr [tp_x1]
    and     esi, 511
    shl     esi, 2
    add     esi, dword ptr [CosineTable]
    lodsd
    mov     ebx, eax
    mov     esi, dword ptr [tp_x2]
    and     esi, 511
    shl     esi, 2
    add     esi, dword ptr [CosineTable]
    lodsd
    add     eax, ebx
    stosd
    add     dword ptr [tp_x1], 1
    add     dword ptr [tp_x2], 2
    dec     ecx
    jnz     MakeTemp

    mov     edi, dword ptr [frame_buffer]
    mov     edx, 200
    mov     eax, dword ptr [p_y1]
    mov     dword ptr [tp_y1], eax
    mov     eax, dword ptr [p_y2]
    mov     dword ptr [tp_y2], eax
PlasmaY:
    mov     ecx, 320
    mov     ebx, dword ptr [TempTable]
    mov     esi, dword ptr [tp_y1]
    and     esi, 511
    shl     esi, 2
    add     esi, dword ptr [CosineTable]
    lodsd
    mov     ebp, eax
    mov     esi, dword ptr [tp_y2]
    and     esi, 511
    shl     esi, 2
    add     esi, dword ptr [CosineTable]
    lodsd
    add     ebp, eax
PlasmaX:
    mov     eax, dword ptr [ebx]
    add     eax, ebp
    stosb
    add     ebx, 4
    dec     ecx
    jnz     PlasmaX
    add     dword ptr [tp_y1], 1
    add     dword ptr [tp_y2], 2
    dec     edx
    jnz     PlasmaY

    call    wait_for_vsync
    call    copy_buffer


    add     dword ptr [p_x1], 1
    add     dword ptr [p_x2], -2
    add     dword ptr [p_y1], 1
    add     dword ptr [p_y2], -3


    in      al, 60h
    dec     al
    jnz     MainLoop

    call    unset_mode13h

    mov     eax, dword ptr [MemHandle]
    call    free_mem
    ret

_63 dd 63.0
DeltaAngle dd 0.0122718   ; pi / 256

MemHandle dd ?
CosineTable dd ?
TempTable dd ?

p_x1 dd ?
p_x2 dd ?
p_y1 dd ?
p_y2 dd ?

tp_x1 dd ?
tp_x2 dd ?
tp_y1 dd ?
tp_y2 dd ?

code32 ends

end
