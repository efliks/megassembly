include math3d.inc
include struct3d.inc
include engine.inc
include s3dgen.inc
include letgen.inc
include share.inc

include world1.inc
include world3.inc

.386p


code32 segment para public use32
    assume cs:code32,  ds:code32

World3_GetMem proc
    mov     eax, W3_LETTER
    call    GetLetterParams
    mov     d [Cube3_Strc + S3D_N_VERTS], eax
    mov     d [Cube3_Strc + S3D_NUM_FACES], ebx

    add     d [World3_Strc + S3D_N_VERTS], eax
    add     d [World3_Strc + S3D_NUM_FACES], ebx

    mov     esi, o World3_Strc
    call    S3d_ComputeMem
    ret
endp

;************************************************************

World3_Init proc
    mov     esi, o World3_Strc
    call    S3d_AdjustMem
    push    eax

    mov     esi, o World3_Strc
    mov     edi, o Floor3_Strc
    xor     eax, eax
    xor     ebx, ebx
    call    S3d_SetPointers

    mov     esi, o World3_Strc
    mov     edi, o Cube3_Strc
    call    S3d_SetPointers

    mov     esi, o World3_Strc
    mov     edi, o Cube31_Strc
    call    S3d_SetPointers

    mov     esi, o World3_Strc
    mov     edi, o Cube32_Strc
    call    S3d_SetPointers

    mov     esi, o World3_Strc
    mov     edi, o Cube33_Strc
    call    S3d_SetPointers

    mov     esi, o Floor3_Strc
    mov     eax, FLOOR3_SIDE
    mov     ebx, FLOOR3_CELL
    call    S3d_GenerateFloor

    mov     esi, o Cube3_Strc
    mov     eax, W3_LETTER
    mov     ebx, 250
    call    MakeLetter3d

    mov     esi, o Cube31_Strc
    mov     eax, 25
    call    S3d_GenerateCube

    mov     esi, o Cube32_Strc
    mov     eax, 35
    call    S3d_GenerateCube

    mov     esi, o Cube33_Strc
    mov     eax, 45
    call    S3d_GenerateCube

    mov     esi, o Cube3_Strc
    mov     eax, FLOOR3_N_VERTS
    call    S3d_CorrectFaces

    mov     eax, FLOOR3_N_VERTS
    add     eax, d [Cube3_Strc + S3D_N_VERTS]

    mov     esi, o Cube31_Strc
    push    eax
    call    S3d_CorrectFaces

    mov     esi, o Cube32_Strc
    pop     eax
    add     eax, 8
    push    eax
    call    S3d_CorrectFaces

    mov     esi, o Cube33_Strc
    pop     eax
    add     eax, 8
    call    S3d_CorrectFaces


    mov     edi, d [Floor3_Strc + S3D_PTR_B_VERTS]
    xor     esi, esi
w3i_1:
    xor     ecx, ecx
w3i_2:
    mov     eax, ecx
    sub     eax, FLOOR3_SIDE / 2
    mov     ebx, FLOOR3_CELL
    imul    ebx
    mov     d [_w3temp], eax
    fild    d [_w3temp]
    fmul    st(0), st(0)

    mov     eax, esi
    sub     eax, FLOOR3_SIDE / 2
    imul    ebx
    mov     d [_w3temp], eax
    fild    d [_w3temp]
    fmul    st(0), st(0)

    faddp   st(1), st(0)
    fsqrt
    fmul    [_w3correct]
    fadd    [_w3height]
    fstp    d [edi + 4]

    add     edi, 12
    inc     ecx
    cmp     ecx, FLOOR3_SIDE
    jne     w3i_2
    inc     esi
    cmp     esi, FLOOR3_SIDE
    jne     w3i_1

    pop     eax
    ret
endp

;************************************************************

World3_Proc proc
    mov     esi, o World3_World
    call    RenderWorld

    fld     d [Cube3_ang]
    fadd    d [Cube3_ang_d]
    fst     d [Cube3_ang]
    fsin
    fmul    d [Cube3_A]
    fadd    d [Cube3_MinH]
    fstp    d [Cube3_Obj + O_POS + 4]

      ; move 1st cube
    fld     d [SCube_ang]
    fadd    d [SCube_ang_d]
    fst     d [SCube_ang]
    fld     st(0)
    fsin
    fmul    d [SCube_r]
    fstp    d [Cube31_Obj + O_POS + 8]
    fcos
    fmul    d [SCube_r]
    fstp    d [Cube31_Obj + O_POS + 0]

      ; move 2nd cube
    fld     d [SCube_ang]
    fsub    d [SCube_ang_sub]
    fld     st(0)
    fsin
    fmul    d [SCube_r]
    fstp    d [Cube32_Obj + O_POS + 8]
    fcos
    fmul    d [SCube_r]
    fstp    d [Cube32_Obj + O_POS + 0]

      ; move 3rd cube
    fld     d [SCube_ang]
    fsub    d [SCube_ang_sub]
    fsub    d [SCube_ang_sub]
    fld     st(0)
    fsin
    fmul    d [SCube_r]
    fstp    d [Cube33_Obj + O_POS + 8]
    fcos
    fmul    d [SCube_r]
    fstp    d [Cube33_Obj + O_POS + 0]

    ret
endp

;************************************************************

Cube3_ang    dd 0
Cube3_ang_d    dd 0.008
Cube3_A        dd 200.0
Cube3_MinH    dd 210.0

SCube_ang    dd 0
SCube_ang_d    dd 0.008
SCube_r        dd 350.0
SCube_ang_sub    dd 0.800

_w3temp        dd 0
_w3correct    dd 0.25
_w3height    dd -130.0

World3_:

World3_World    dd o World3_Strc
        dd o World1_Camera
        dd 5
        dd o World3_Object_Table
        dd WF_DRAW_GOURAUD

World3_Object_Table:
Floor3_Obj    dd o Floor3_Strc
        dd 9 dup(0)
        dd 0, 0, 0
        dd 0, 0, 0
        dd 0, 0, 0
        dd OF_STATIC

Cube3_Obj    dd o Cube3_Strc
        dd 9 dup(0)
        dd 3.14, 0, 0
        dd 0, 0.034, 0
        dd 0, 0, 0
        dd OF_MOVEABLE

Cube31_Obj    dd o Cube31_Strc
        dd 9 dup(0)
        dd 0, 0, 0
        dd 0.119, 0.119, 0.119
        dd 0, 60.0, 0
        dd OF_MOVEABLE

Cube32_Obj    dd o Cube32_Strc
        dd 9 dup(0)
        dd 0, 0, 0
        dd 0.085, 0.085, 0.085
        dd 0, 60.0, 0
        dd OF_MOVEABLE

Cube33_Obj    dd o Cube33_Strc
        dd 9 dup(0)
        dd 0, 0, 0
        dd 0.051, 0.051, 0.051
        dd 0, 60.0, 0
        dd OF_MOVEABLE

World3_Struct_Table:
World3_Strc    dd FLOOR3_N_VERTS + 8 * 3   ; <-- add letter vertices !
        dd FLOOR3_N_FACES + 12 * 3   ; <-- add letter faces !
        dd 0
        dd 0, 0, 0, 0, 0, 0, 0, 0

Floor3_Strc    dd FLOOR3_N_VERTS
        dd FLOOR3_N_FACES
        dd 0
        dd 0, 0, 0, 0, 0, 0, 0, 0

; this is not a cube, but a letter :P
Cube3_Strc    dd 0
        dd 0
        dd 0
        dd 0, 0, 0, 0, 0, 0, 0, 0

Cube31_Strc    dd 8
        dd 12
        dd 0
        dd 0, 0, 0, 0, 0, 0, 0, 0

Cube32_Strc    dd 8
        dd 12
        dd 0
        dd 0, 0, 0, 0, 0, 0, 0, 0

Cube33_Strc    dd 8
        dd 12
        dd 0
        dd 0, 0, 0, 0, 0, 0, 0, 0

WORLD3_SMEM    equ $ - World3_
W3_LETTER    equ 1

;************************************************************

code32 ends

end
