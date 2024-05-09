include engine.inc
include struct3d.inc
include share.inc

include world1.inc
include world2.inc

.386p


code32 segment para public use32
    assume cs:code32,  ds:code32

; returns requied memory in EAX
World2_GetMem proc
      ; World1 and World2 uses the same Floor1 structure
    xor     eax, eax
    ret
endp

;************************************************************

; gets EAX and returns it unchanged :P
World2_Init proc
    ret
endp

;************************************************************

World2_Proc proc
    mov     esi, o World2_World
    call    RenderWorld

    mov     esi, o Floor1_Strc  ;World2_Strc
    mov     eax, FLOOR1_SIDE
    call    PlasmaFloor
    ret
endp

;************************************************************
;    PlasmaFloor() (unoptimized !)
;
;    in: esi = ptr to struct3d, eax = floor side
;************************************************************
PlasmaFloor proc
    mov     ebp, eax

    sub     esp, 256 * 4
    mov     ebx, esp

    xor     eax, eax
    mov     ecx, 256
    fldz
PF_GenSin:
    fld     st(0)
    fsin
    fmul    d [PF_A]
    fstp    d [ebx + eax]
    add     eax, 4
    fadd    d [PF_angle]
    dec     ecx
    jnz     PF_GenSin
    ffree   st(0)

    mov     edi, d [esi + S3D_PTR_B_VERTS]
    xor     edx, edx
    mov     ax, w [PF_1]
    mov     w [PF_t1], ax
PF_y:
    xor     ecx, ecx
    mov     ax, w [PF_3]
    mov     w [PF_t3], ax
PF_x:
    movzx   eax, b [PF_t1]
    shl     eax, 2
    fld     d [ebx + eax]
    movzx   eax, b [PF_t2]
    shl     eax, 2
    fadd    d [ebx + eax]
    movzx   eax, b [PF_t3]
    shl     eax, 2
    fadd    d [ebx + eax]
    movzx   eax, b [PF_t4]
    shl     eax, 2
    fadd    d [ebx + eax]

    fstp    d [edi + 4]

    add     b [PF_t3], 6 * 6
    add     b [PF_t4], -7 * 6

    add     edi, 12
    inc     ecx
    cmp     ecx, ebp
    jne     PF_x

    add     b [PF_t1], 3 * 6
    add     b [PF_t2], 4 * 6

    inc     edx
    cmp     edx, ebp
    jne     PF_y

    add     b [PF_1], 1
    add     b [PF_2], 4
    add     b [PF_3], -2
    add     b [PF_4], 5

    add     esp, 256 * 4
    ret
endp


PF_A dd 20.0
PF_angle dd 0.0245     ; pi/128

PF_1 db 0
PF_2 db 0
PF_3 db 0
PF_4 db 0

PF_t1 db 0
PF_t2 db 0
PF_t3 db 0
PF_t4 db 0

World2_:

World2_World    dd o Floor1_Strc   ;World2_Strc
        dd o World1_Camera   ;World2_Camera
        dd 1
        dd o Floor1_Obj   ;World2_Obj
        dd WF_DRAW_GOURAUD

;World2_Camera    dd 0, 0, 0
;        dd 0, 0, 0
;        dd 0
;        dd 9 dup(0)
;        dd 0, 0, 0
;        dd CF_NO_TARGET

;World2_Obj    dd o World2_Strc
;        dd 9 dup(0)
;        dd 0, 0, 0
;        dd 0, 0, 0
;        dd 0, 0, 0
;        dd OF_STATIC

;World2_Strc    dd FLOOR2_N_VERTS
;        dd FLOOR2_N_FACES
;        dd 0
;        dd 0, 0, 0, 0, 0, 0, 0, 0

WORLD2_SMEM    equ $ - World2_

;************************************************************

code32 ends

end
