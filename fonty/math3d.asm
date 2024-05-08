include math3d.inc
include share.inc

.386p
locals


code32 segment para public use32
    assume cs:code32, ds:code32

init_sincos proc
    mov     ebp, d [SinCosLookups]
    xor     eax, eax

    fldz
isc_make:
    fld     st
    fld     st

    fsin
    fstp    d [ebp + eax + SINLOOKUP]
    fcos
    fstp    d [ebp + eax + COSLOOKUP]

    fadd    d [delta_angle]
    add     eax, 4
    cmp     eax, MAX_DEGS * 4
    jne     isc_make

    ffree   st
    ret
endp

;------------------------------------------------------------
;    in:   esi - offset to angles (float)
;          edi - offset to 3x3 matrix
;    out:  none
;------------------------------------------------------------

mx_rotation_matrix proc

    mov     ebx, o sin_x
    mov     ecx, 3
@@load:
    fld     d [esi]
    fld     st
    fsin
    fstp    d [ebx]
    fcos
    fstp    d [ebx + 4]

    add     esi, 4
    add     ebx, 8
    dec     ecx
    jnz     @@load

    call    mx_compute_rotation_matrix
    ret
endp

;------------------------------------------------------------
;    in:   esi - offset to angles (double word integer)
;          edi - offset to 3x3 matrix
;    out:  none
;------------------------------------------------------------

mx_rotation_matrix_lookup proc
    mov     ebp, d [SinCosLookups]
    mov     ebx, o sin_x
    mov     ecx, 3
    cld
@@load:
    lodsd
    and     eax, MAX_DEGS - 1
    shl     eax, 2
    mov     edx, d [ebp + eax + SINLOOKUP]
    mov     d [ebx], edx
    add     ebx, 4
    mov     edx, d [ebp + eax + COSLOOKUP]
    mov     d [ebx], edx
    add     ebx, 4
    dec     ecx
    jnz     @@load

    call    mx_compute_rotation_matrix
    ret
endp

mx_compute_rotation_matrix proc

    fld     cos_y
    fmul    cos_z
    fstp    d [edi.m_00]

    fld     sin_x
    fmul    sin_y
    fmul    cos_z
    fld     cos_x
    fchs
    fmul    sin_z
    faddp   st(1), st
    fstp    d [edi.m_10]

    fld     cos_x
    fmul    sin_y
    fmul    cos_z
    fld     sin_x
    fmul    sin_z
    faddp   st(1), st
    fstp    d [edi.m_20]

    fld     cos_y
    fmul    sin_z
    fstp    d [edi.m_01]

    fld     sin_x
    fmul    sin_y
    fmul    sin_z
    fld     cos_x
    fmul    cos_z
    faddp   st(1), st
    fstp    d [edi.m_11]

    fld     cos_x
    fmul    sin_y
    fmul    sin_z
    fld     sin_x
    fchs
    fmul    cos_z
    faddp   st(1), st
    fstp    d [edi.m_21]

    fld     sin_y
    fchs
    fstp    d [edi.m_02]

    fld     cos_y
    fmul    sin_x
    fstp    d [edi.m_12]

    fld     cos_x
    fmul    cos_y
    fstp    d [edi.m_22]

    ret
endp

;------------------------------------------------------------
;    in:    esi - offset to points
;        edi - offset to rotated_points
;        ebx - offset to 3x3 rotation matrix
;        ecx - number of points
;    out:    none
;------------------------------------------------------------

mx_rotate_points proc

comment #
    fld     d [esi.x3d]
    fmul    d [ebx.m_00]
    fld     d [esi.y3d]
    fmul    d [ebx.m_10]
    fld     d [esi.z3d]
    fmul    d [ebx.m_20]
    faddp   st(1), st
    faddp   st(1), st
    fstp    d [edi.x3d]

    fld     d [esi.x3d]
    fmul    d [ebx.m_01]
    fld     d [esi.y3d]
    fmul    d [ebx.m_11]
    fld     d [esi.z3d]
    fmul    d [ebx.m_21]
    faddp   st(1), st
    faddp   st(1), st
    fstp    d [edi.y3d]

    fld     d [esi.x3d]
    fmul    d [ebx.m_02]
    fld     d [esi.y3d]
    fmul    d [ebx.m_12]
    fld     d [esi.z3d]
    fmul    d [ebx.m_22]
    faddp   st(1), st
    faddp   st(1), st
    fstp    d [edi.z3d] #

    fld     d [esi + 0]
    fmul    d [ebx + 0 * 4 + 0 * 12]
    fld     d [esi + 4]
    fmul    d [ebx + 0 * 4 + 1 * 12]
    fld     d [esi + 8]
    fmul    d [ebx + 0 * 4 + 2 * 12]
    faddp   st(1), st(0)
    faddp   st(1), st(0)
    fstp    d [edi + 0]

    fld     d [esi + 0]
    fmul    d [ebx + 1 * 4 + 0 * 12]
    fld     d [esi + 4]
    fmul    d [ebx + 1 * 4 + 1 * 12]
    fld     d [esi + 8]
    fmul    d [ebx + 1 * 4 + 2 * 12]
    faddp   st(1), st(0)
    faddp   st(1), st(0)
    fstp    d [edi + 4]

    fld     d [esi + 0]
    fmul    d [ebx + 2 * 4 + 0 * 12]
    fld     d [esi + 4]
    fmul    d [ebx + 2 * 4 + 1 * 12]
    fld     d [esi + 8]
    fmul    d [ebx + 2 * 4 + 2 * 12]
    faddp   st(1), st(0)
    faddp   st(1), st(0)
    fstp    d [edi + 8]

    add     esi, size point3d
    add     edi, size point3d
    dec     ecx
    jnz     mx_rotate_points

    ret
endp

;------------------------------------------------------------
;    in:    esi - offset to 3d points
;        edi - offset to 2d points
;        ecx - number of points
;    out:    none
;------------------------------------------------------------

translate_points proc

    fld     d [esi.z3d]
    fadd    perspective

comment #
    ftst
    fstsw   ax
    sahf
    ja      @@point_ok

    ffree   st
    mov     w [edi.x2d], -100
    mov     w [edi.y2d], -100
    jmp     @@next_point #

@@point_ok:

    fld     d [esi.x3d]
    fmul    perspective
    fdiv    st, st(1)
    fadd    correct_x
    fistp   w [edi.x2d]

    fld     d [esi.y3d]
    fmul    perspective
    fdivrp  st(1), st
    fadd    correct_y
    fistp   w [edi.y2d]

@@next_point:
    add     esi, size point3d
    add     edi, size point2d
    dec     ecx
    jnz     translate_points

    ret
endp

;------------------------------------------------------------
;    in:    edi - offset to vector
;    out:    none
;------------------------------------------------------------

normalize_vector proc

    push    eax
    fld     d [edi + 0]
    fmul    st(0), st(0)
    fld     d [edi + 4]
    fmul    st(0), st(0)
    fld     d [edi + 8]
    fmul    st(0), st(0)
    faddp   st(1), st(0)
    faddp   st(1), st(0)
    fsqrt
    ftst
    fstsw   ax
    sahf
    jz      NV_zero

    fld     d [edi + 0]
    fdiv    st(0), st(1)
    fstp    d [edi + 0]
    fld     d [edi + 4]
    fdiv    st(0), st(1)
    fstp    d [edi + 4]
    fld     d [edi + 8]
    fdivrp  st(1), st(0)
    fstp    d [edi + 8]
    pop     eax
    ret

NV_zero:
    ffree   st
    xor     eax, eax
    stosd
    stosd
    stosd
    pop     eax
    ret
endp

comment #
    push    eax

    fld     d [edi.vec_x]
    fmul    st, st
    fld     d [edi.vec_y]
    fmul    st, st
    fld     d [edi.vec_z]
    fmul    st, st
    faddp   st(1), st
    faddp   st(1), st
    fsqrt

    ftst
    fstsw   ax
    sahf
    jnz     @@not_zero

    fst     d [edi.vec_x]
    fst     d [edi.vec_y]
    fstp    d [edi.vec_z]
    jmp     @@quit

@@not_zero:
    fld     st
    fld     st
    fdivr   d [edi.vec_x]
    fstp    d [edi.vec_x]
    fdivr   d [edi.vec_y]
    fstp    d [edi.vec_y]
    fdivr   d [edi.vec_z]
    fstp    d [edi.vec_z]

@@quit:
    pop     eax
    ret
endp #

;------------------------------------------------------------
;    in:    esi - offset to 1st vector
;        edi - offset to 2nd vector
;    out:    st(0) - dot-product
;------------------------------------------------------------

dot_product proc

    fld     d [esi.vec_x]
    fmul    d [edi.vec_x]
    fld     d [esi.vec_y]
    fmul    d [edi.vec_y]
    fld     d [esi.vec_z]
    fmul    d [edi.vec_z]
    faddp   st(1), st
    faddp   st(1), st

    ret
endp

;------------------------------------------------------------
;    in:    esi - offset to 1st vector
;        edi - offset to 2nd vector
;        ebx - offset to result vector
;    out:    none
;------------------------------------------------------------

cross_product proc

    fld     d [esi.vec_y]
    fmul    d [edi.vec_z]
    fld     d [esi.vec_z]
    fmul    d [edi.vec_y]
    fsubp   st(1), st
    fstp    d [ebx.vec_x]

    fld     d [esi.vec_z]
    fmul    d [edi.vec_x]
    fld     d [esi.vec_x]
    fmul    d [edi.vec_z]
    fsubp   st(1), st
    fstp    d [ebx.vec_y]

    fld     d [esi.vec_x]
    fmul    d [edi.vec_y]
    fld     d [esi.vec_y]
    fmul    d [edi.vec_x]
    fsubp   st(1), st
    fstp    d [ebx.vec_z]

    ret
endp

;------------------------------------------------------------
;    in:    esi - offset to 1st 3d point
;        edi - offset to 2nd 3d point
;        ebx - offset to result vector
;    out:    none
;------------------------------------------------------------

make_vector proc

    fld     d [edi.x3d]
    fsub    d [esi.x3d]
    fstp    d [ebx.vec_x]

    fld     d [edi.y3d]
    fsub    d [esi.y3d]
    fstp    d [ebx.vec_y]

    fld     d [edi.z3d]
    fsub    d [esi.z3d]
    fstp    d [ebx.vec_z]

    ret
endp

;------------------------------------------------------------

; in: esi = 1st vertex, edi = 2nd vertex
; out: st0 = lenght
GetVectorLenght proc
    fld     d [edi.x3d]
    fsub    d [esi.x3d]
    fmul    st, st

    fld     d [edi.y3d]
    fsub    d [esi.y3d]
    fmul    st, st

    fld     d [edi.z3d]
    fsub    d [esi.z3d]
    fmul    st, st
    faddp   st(1), st
    faddp   st(1), st
    fsqrt

    ret
endp


perspective dd 256.0
correct_x dd 160.0
correct_y dd 100.0

; pi / (MAX_DEGS / 2)
delta_angle dd 0.0061359

SinCosLookups dd ?

rot_matrix matrix ?

sin_x dd ?
cos_x dd ?
sin_y dd ?
cos_y dd ?
sin_z dd ?
cos_z dd ?

code32 ends

end
