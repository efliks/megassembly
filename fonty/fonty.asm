; (C) February 8, 2002  M. Feliks

include sys.inc
include stub.inc
include aliasy.inc
include math3d.inc
include struc3d.inc
include grd3.inc
include letgen.inc

move3d_struct struc
   m3d_StartX dd ?
   m3d_StartY dd ?
   m3d_StartZ dd ?

   m3d_DestX dd ?
   m3d_DestY dd ?
   m3d_DestZ dd ?
ends

LETTER_TIME equ 900

TEXT_COLOR equ 50

.386p


code32 segment para public use32
    assume cs:code32, ds:code32

entrypoint proc

    finit

    mov     eax, 64000 + SINCOS_SIZE + 768 + 64000
    call    alloc_mem
    or      eax, eax
    jz      QuitProgy
    mov     d [MemHandle], eax

      ; set pointers
    mov     d [frame_buffer], ebx
    add     ebx, 64000
    mov     d [SinCosLookups], ebx
    add     ebx, SINCOS_SIZE
    mov     d [VGAPalette], ebx
    add     ebx, 768
    mov     d [BackTex], ebx
    add     ebx, 64000

    call    init_sincos
    call    init_font

    mov     edi, d [BackTex]
    call    MakeTex

    call    SetShadowLines

;------------------------------------------------------------
;    generate 3d letters

EB3d_allocated:
    mov     esi, o HandlersTable
    mov     edi, o Structs3dTable
    mov     ebx, o LettersTable
    mov     ecx, LETTERTAB_LEN
GenerateLetter_loop:
    movzx   eax, b [ebx]
    call    MakeLetter3d

    or      eax, eax
    jnz     GL_next

      ; error -> not enough memory
    jmp     FreeAll
GL_next:
    inc     d [LoadedStr3d]
    inc     ebx
    add     esi, 4
    add     edi, size struct3d
    loop    GenerateLetter_loop

;------------------------------------------------------------

    mov     edi, d [VGAPalette]
    mov     esi, o phong_palette
    mov     ecx, 64 * 3
    cld
    rep     movsb

    add     edi, (128 - 64) * 3
    mov     ecx, 128
    xor     eax, eax
InitPal:
    stosb
    stosb
    stosb
    mov     al, ah
    shr     al, 2
    inc     ah
    loop    InitPal

    call    set_mode13h

    mov     esi, d [VGAPalette]
    call    set_palette


    mov     esi, o Move1
    mov     edi, o StartX
    mov     ecx, (size move3d_struct) / 4
    cld
    rep     movsd

    mov     esi, d [CurrLetter]
    call    InitMovement

;------------------------------------------------------------

MainLoop:
    dec     d [TimeToChange]
    jnz     DoNotChangeLetter
    mov     d [TimeToChange], LETTER_TIME

    add     d [CurrLetter], size struct3d
    inc     d [CurrLetterCnt]
    cmp     d [CurrLetterCnt], LETTERTAB_LEN
    jne     StartLetter

    mov     d [CurrLetter], o Structs3dTable
    mov     d [CurrLetterCnt], 0
StartLetter:
    mov     esi, o Move1
    mov     edi, o StartX
    mov     ecx, (size move3d_struct) / 4
    cld
    rep     movsd

    mov     esi, d [CurrLetter]
    call    InitMovement

    jmp     DoNotChangeMovement
DoNotChangeLetter:

    cmp     d [TimeToChange], LETTER_TIME / 2
    jne     DoNotChangeMovement

    mov     esi, o Move2
    mov     edi, o StartX
    mov     ecx, (size move3d_struct) / 4
    cld
    rep     movsd

    mov     esi, d [CurrLetter]
    call    InitMovement
DoNotChangeMovement:


    mov     esi, d [BackTex]
    mov     edi, d [frame_buffer]
    mov     ecx, 16000
    cld
    rep     movsd

    mov     esi, d [CurrLetter]
    call    MoveStruct3d

    mov     esi, d [CurrLetter]
    call    DrawGouraudFaces


    mov     esi, d [CurrLetter]
    lea     esi, d [esi.s3d_AngleX]
    add     d [esi + 0], 1
    add     d [esi + 4], 3
    add     d [esi + 8], 1

    call    PrintFPS

    mov     esi, o txt_app
    mov     ecx, 160 - (TXTAPP_LEN * 4)
    mov     edx, 199 - 8
    mov     eax, TEXT_COLOR
    call    put_string

comment #
    mov     eax, d [TotalAllocMem]
    mov     edi, o test_txt
    call    itoa
    mov     esi, o test_txt
    xor     ecx, ecx
    mov     edx, 12
    mov     eax, TEXT_COLOR
    call    put_string  #

    call    wait_for_vsync
    call    copy_buffer

    in      al, 60h
    dec     al
    jnz     MainLoop

;------------------------------------------------------------

    call    unset_mode13h

FreeAll:
    mov     eax, d [MemHandle]
    call    free_mem

FreeStructs3d:
    mov     esi, o HandlersTable
    mov     ecx, d [LoadedStr3d]
    or      ecx, ecx
    jz      QuitProgy
    cld
FS3d_loop:
    lodsd
    push    esi
    push    ecx
    call    free_mem
    pop     ecx
    pop     esi
    loop    FS3d_loop

QuitProgy:
    ret
endp

;------------------------------------------------------------

; in: edi = ptr to 320x200 texture
MakeTex proc
    xor     edx, edx
mt_v:
    xor     ecx, ecx
mt_h:
    push    edx
    push    ecx

    mov     eax, ecx
    xor     eax, edx
    and     eax, 15
    mov     ebx, eax

    mov     eax, edx
    sub     eax, 100
    imul    eax
    push    eax

    mov     eax, ecx
    sub     eax, 160
    imul    eax
    shr     eax, 1

    pop     edx
    add     eax, edx
    mov     d [mt_temp32], eax
    fild    d [mt_temp32]
    fsqrt
    fistp   d [mt_temp32]

    mov     eax, 127
    sub     eax, d [mt_temp32]
    add     eax, ebx
    or      eax, eax
    jge     mt_ok1
    xor     eax, eax
    jmp     mt_ok2
mt_ok1:
    cmp     eax, 127
    jle     mt_ok2
    mov     eax, 127
mt_ok2:
    add     eax, 128
    stosb

    pop     ecx
    pop     edx
    inc     ecx
    cmp     ecx, 320
    jne     mt_h

    inc     edx
    cmp     edx, 200
    jne     mt_v
    ret
endp

; out: eax = 1 if new second, otherwise eax = 0
GetSec proc
    xor     eax, eax
    out     70h, al
    in      al, 71h
    cmp     al, b [LastSec]
    jne     GSec_changed
    xor     eax ,eax
    ret
GSec_changed:
    mov     b [LastSec], al
    mov     eax, 1
    ret
endp

PrintFPS proc
    mov     esi, o txt_framerate
    xor     ecx, ecx
    xor     edx, edx
    mov     eax, TEXT_COLOR
    call    put_string

    inc     d [FrameCounter]

    call    GetSec
    or      eax, eax
    jz      SkipCalcFrame

    mov     eax, d [FrameCounter]
    mov     edi, o txt_framerate + 5
    call    itoa
    mov     d [FrameCounter], 0

SkipCalcFrame:
    ret
endp

; in: eax - value to convert, edi - offset to text buffer
itoa proc
    mov     ebx, 10
    xor     ecx, ecx
@@con:
    xor     edx, edx
    div     ebx
    push    edx
    inc     ecx
    or      eax, eax
    jnz     @@con
@@make:
    pop     eax
    add     al, '0'
    stosb
    dec     ecx
    jnz     @@make
    xor     eax, eax
    stosb
    ret
endp

; in: esi = ptr to struct3d
InitMovement proc
    mov     ebp, esi

    mov     esi, o StartX
    mov     edi, o DestX
    call    GetVectorLenght
    fstp    d [ebp.s3d_MovingTime]
    mov     d [ebp.s3d_CurrTime], 0
    mov     d [ebp.s3d_Movement], 1

    fld     d [DestX]
    fsub    d [StartX]
    fdiv    d [ebp.s3d_MovingTime]
    fstp    d [ebp.s3d_DeltaX]

    fld     d [DestY]
    fsub    d [StartY]
    fdiv    d [ebp.s3d_MovingTime]
    fstp    d [ebp.s3d_DeltaY]

    fld     d [DestZ]
    fsub    d [StartZ]
    fdiv    d [ebp.s3d_MovingTime]
    fstp    d [ebp.s3d_DeltaZ]
    ret
endp

;------------------------------------------------------------

; in: esi = ptr to struct3d
MoveStruct3d proc
    push    esi
    lea    esi, d [esi.s3d_AngleX]
    mov     edi, o rot_matrix
    call    mx_rotation_matrix_lookup
    pop     ebp

    mov     esi, d [ebp.s3d_points]
    mov     edi, d [ebp.s3d_r_points]
    mov     ecx, d [ebp.s3d_n_points]
    mov     ebx, o rot_matrix
    call    mx_rotate_points

    mov     esi, d [ebp.s3d_point_nrm]
    mov     edi, d [ebp.s3d_r_point_nrm]
    mov     ecx, d [ebp.s3d_n_points]
    call    mx_rotate_points


    cmp     d [ebp.s3d_Movement], 1
    jne     MS3d_MV

    fld     d [ebp.s3d_CurrTime]
    fadd    d [MovingSpeed]
    fst     d [ebp.s3d_CurrTime]
    fcomp    d [ebp.s3d_MovingTime]
    fstsw   ax
    sahf
    ja      MS3d_DisableMovement

    fld     d [ebp.s3d_DeltaX]
    fmul    d [ebp.s3d_CurrTime]
    fadd    d [StartX]
    fstp    d [AddX]

    fld     d [ebp.s3d_DeltaY]
    fmul    d [ebp.s3d_CurrTime]
    fadd    d [StartY]
    fstp    d [AddY]

    fld     d [ebp.s3d_DeltaZ]
    fmul    d [ebp.s3d_CurrTime]
    fadd    d [StartZ]
    fstp    d [AddZ]

    jmp     MS3d_MV
MS3d_DisableMovement:
    mov     d [ebp.s3d_Movement], 0

MS3d_MV:
    mov     edi, d [ebp.s3d_r_points]
    mov     ecx, d [ebp.s3d_n_points]
MS3d_MoveVertices:
    fld     d [edi.x3d]
    fadd    d [AddX]
    fstp    d [edi.x3d]

    fld     d [edi.y3d]
    fadd    d [AddY]
    fstp    d [edi.y3d]

    fld     d [edi.z3d]
    fadd    d [AddZ]
    fstp    d [edi.z3d]

    add     edi, size point3d
    dec     ecx
    jnz     MS3d_MoveVertices


    mov     esi, d [ebp.s3d_r_points]
    mov     edi, d [ebp.s3d_t_points]
    mov     ecx, d [ebp.s3d_n_points]
    call    translate_points
    ret
endp

;------------------------------------------------------------

; in: st0 = dot-product
MakeColor proc
    fcom    d [DotMin]
    fstsw   ax
    sahf
    jb      MC_err
    fcom    d [DotMax]
    fstsw   ax
    sahf
    ja      MC_err

    fmul    d [GouraudColors]
    fistp   d [MC_temp]
    mov     eax, d [MC_temp]
    ret

MC_err:
    ffree   st
    xor     eax, eax
    ret
endp

; in: esi = ptr to struct3d
DrawGouraudFaces proc
    call    sort_faces

    mov     edi, d [esi.s3d_order]
    mov     ecx, d [esi.s3d_vis_faces]
DGF_face:
    push    edi
    push    ecx

    movzx   eax, w [edi]
    mov     ebx, eax
    shl     eax, 1
    shl     ebx, 2
    add     ebx, eax
    add     ebx, d [esi.s3d_faces]
    push    ebx

    mov     edi, o GrdX1
    mov     ecx, 3
DGF_load_vert:
    movzx   eax, w [ebx]
    shl     eax, 2
    add     eax, d [esi.s3d_t_points]
    movsx   edx, w [eax.x2d]
    mov     d [edi + 0], edx
    movsx   edx, w [eax.y2d]
    mov     d [edi + 4], edx
    add     edi, 8
    add     ebx, 2
    dec     ecx
    jnz     DGF_load_vert

    pop     ebx
    mov     edi, o GrdCol1
    mov     ecx, 3
DGF_load_col:
    movzx   eax, w [ebx]
    mov     edx, eax
    shl     eax, 2
    shl     edx, 3
    add     eax, edx
    add     eax, d [esi.s3d_r_point_nrm]

    push    esi
    push    edi
    mov     esi, o LightVector
    mov     edi, eax
    call    dot_product
    pop     edi
    pop     esi

    call    MakeColor
    stosd

    add     ebx, 2
    dec     ecx
    jnz     DGF_load_col

    call    GouraudTriangle

    pop     ecx
    pop     edi
    add     edi, 2
    dec     ecx
    jnz     DGF_face
    ret
endp


GouraudColors dd 63.0

LightVector vector3d <0.0, 0.0, -1.0>

DotMin dd 0.0
DotMax dd 1.0

MC_temp dd ?

phong_palette db  0,  0,  0,  0,  0,  0,  0,  0,  0,  2,  0
 db  0,  2,  1,  2,  2,  1,  2,  4,  1,  2
 db  4,  2,  4,  6,  2,  4,  6,  2,  4,  6
 db  2,  6,  8,  3,  6,  8,  3,  6,  10,  3
 db  8,  10,  4,  8,  10,  4,  8,  12,  4,  10
 db  12,  4,  10,  12,  5,  10,  14,  5,  10,  14
 db  5,  12,  16,  6,  12,  16,  6,  12,  16,  6
 db  14,  18,  6,  14,  18,  7,  14,  18,  7,  14
 db  20,  7,  16,  20,  7,  16,  20,  8,  16,  22
 db  8,  18,  22,  8,  18,  24,  9,  18,  24,  9
 db  20,  26,  10,  20,  26,  10,  22,  28,  11,  22
 db  30,  12,  24,  30,  12,  24,  32,  13,  26,  34
 db  14,  28,  38,  16,  28,  40,  17,  30,  42,  18
 db  32,  46,  20,  34,  48,  21,  38,  52,  23,  40
 db  56,  25,  42,  60,  27,  46,  62,  29,  48,  62
 db  31,  52,  62,  34,  54,  62,  36,  56,  62,  38
 db  60,  62,  40,  62,  62,  42,  62,  62,  44,  62
 db  62,  45,  62,  62,  47,  62,  62,  48,  62,  62
 db  49,  62,  62,  50,  62,  62,  50,  62,  62,  51
 db  62

LettersTable db 'NAAGRULEZ'
LETTERTAB_LEN equ $ - LettersTable

LoadedStr3d dd 0

CurrLetter dd o Structs3dTable
CurrLetterCnt dd 0
TimeToChange dd LETTER_TIME

txt_app db '3dFontz 0.7 test by Majuma/NAAG', 0
TXTAPP_LEN equ $ - txt_app - 1

Move1 move3d_struct <0.0, 0.0, -180.0, 0.0, 0.0, 0.0>
Move2 move3d_struct <0.0, 0.0, 0.0, 160.0, -100.0, -100.0>

HandlersTable dd LETTERTAB_LEN dup(?)

Structs3dTable struct3d LETTERTAB_LEN dup(?)

test_txt db 8 dup(?)

MemHandle dd ?
VGAPalette dd ?
BackTex dd ?

; texture generator
mt_temp32 dd ?

; compute frames per second
FrameCounter dd 0
LastSec db 0
txt_framerate db 'FPS: ', 4 dup(0)

; moving objects
MovingSpeed dd 0.5

AddX dd ?
AddY dd ?
AddZ dd ?

StartX dd ?
StartY dd ?
StartZ dd ?

DestX dd ?
DestY dd ?
DestZ dd ?

code32 ends

end
