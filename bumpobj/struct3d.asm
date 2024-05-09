include common.inc
include math3d.inc
include struct3d.inc

.386p
locals


code32 segment para public use32
    assume cs:code32, ds:code32

;------------------------------------------------------------
;    in:    esi - offset to angles
;        edi - offset to struct3d
;    out:    none
;------------------------------------------------------------

rotate_translate_struct3d proc
    mov     ebp, edi

      ; make rotation matrix
    mov     edi, o rot_mx
    call    mx_rotation_matrix

      ; rotate vertices
    mov     ebx, edi
    mov     esi, d [ebp.s3d_points]
    mov     edi, d [ebp.s3d_r_points]
    mov     ecx, d [ebp.s3d_n_points]
    call    mx_rotate_points

      ; rotate normals
    mov     esi, d [ebp.s3d_point_nrm]
    mov     edi, d [ebp.s3d_r_point_nrm]
    mov     ecx, d [ebp.s3d_n_points]
    call    mx_rotate_points

      ; translate vertices to 2d
    mov     esi, d [ebp.s3d_r_points]
    mov     edi, d [ebp.s3d_t_points]
    mov     ecx, d [ebp.s3d_n_points]
    call    translate_points

    ret
endp

;------------------------------------------------------------
;    in:    esi - offset to struct3d
;    out:    none
;------------------------------------------------------------

sort_faces proc
    mov     edi, d [esi.s3d_faces]
    xor     ecx, ecx
    mov     d [esi.s3d_vis_faces], 0
@@add_face:

    movzx   ebx, w [edi.face_v1]
    shl     ebx, 2
    add     ebx, d [esi.s3d_t_points]
    mov     ax, w [ebx.x2d]
    mov     f_x1, ax
    mov     ax, w [ebx.y2d]
    mov     f_y1, ax

    movzx   ebx, w [edi.face_v2]
    shl     ebx, 2
    add     ebx, d [esi.s3d_t_points]
    mov     ax, w [ebx.x2d]
    mov     f_x2, ax
    mov     ax, w [ebx.y2d]
    mov     f_y2, ax

    movzx   ebx, w [edi.face_v3]
    shl     ebx, 2
    add     ebx, d [esi.s3d_t_points]
    mov     ax, w [ebx.x2d]
    mov     f_x3, ax
    mov     ax, w [ebx.y2d]
    mov     f_y3, ax

    mov     ax, f_y1
    sub     ax, f_y3
    mov     bx, f_x2
    sub     bx, f_x1
    imul    bx
    shl     edx, 16
    mov     dx, ax
    push    edx
    mov     ax, f_x1
    sub     ax, f_x3
    mov     bx, f_y2
    sub     bx, f_y1
    imul    bx
    shl     edx, 16
    mov     dx, ax
    pop     ebx
    sub     ebx, edx
    jl      @@next_face

    movzx   eax, w [edi.face_v1]
    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     eax, ebx
    add     eax, d [esi.s3d_r_points]
    fld     d [eax.z3d]

    movzx   eax, w [edi.face_v2]
    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     eax, ebx
    add     eax, d [esi.s3d_r_points]
    fadd    d [eax.z3d]

    movzx   eax, w [edi.face_v3]
    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     eax, ebx
    add     eax, d [esi.s3d_r_points]
    fadd    d [eax.z3d]


    mov     eax, d [esi.s3d_vis_faces]
    shl     eax, 1
    mov     ebx, eax

    add     eax, d [esi.s3d_order]
    mov     w [eax], cx

    add     ebx, d [esi.s3d_depths]
    fistp   w [ebx]

    inc     d [esi.s3d_vis_faces]
@@next_face:
    add     edi, type face
    inc     ecx
    cmp     ecx, d [esi.s3d_n_faces]
    jne     @@add_face

    mov     eax, d [esi.s3d_vis_faces]
    dec     eax
    push    eax
    push    large 0
    call    quick_sort

    ret
endp

;------------------------------------------------------------
;    in:    esi = offset to struct3d
;        stack: left, right
;    out:    none
;------------------------------------------------------------

quick_sort proc

@@left equ d [ebp + 08]
@@right equ d [ebp + 12]

    push    ebp
    mov     ebp, esp

    mov     eax, @@left
    mov     ebx, @@right

      ; element=face_depth[(left+right)>>1];
    mov     edi, eax
    add     edi, ebx
    sar     edi, 1
    shl     edi, 1
    add     edi, d [esi.s3d_depths]
    mov     dx, w [edi]

      ; while(i<j)
    cmp     eax, ebx
    jge     @@break_main
@@main:

      ; while(face_depth[i]>element) i++;
    mov     edi, eax
    shl     edi, 1
    add     edi, d [esi.s3d_depths]
@@small1:
    cmp     w [edi], dx
    jle     @@break_small1
    inc     eax
    add     edi, 2
    jmp     @@small1
@@break_small1:

      ; while(face_depth[j]<element) j--;
    mov     edi, ebx
    shl     edi, 1
    add     edi, d [esi.s3d_depths]
@@small2:
    cmp     w [edi], dx
    jge     @@break_small2
    dec     ebx
    sub     edi, 2
    jmp     @@small2
@@break_small2:

      ; if(i<=j)
    cmp     eax, ebx
    jg      @@skip_xchg

    mov     edi, d [esi.s3d_depths]
    mov     cx, w [edi + eax*2]
    xchg    cx, w [edi + ebx*2]
    mov     w [edi + eax*2], cx

    mov     edi, d [esi.s3d_order]
    mov     cx, w [edi + eax*2]
    xchg    cx, w [edi + ebx*2]
    mov     w [edi + eax*2], cx

    inc     eax
    dec     ebx

@@skip_xchg:
    cmp     eax, ebx
    jl      @@main

@@break_main:

      ; if(j>left) depth_sorting(left, j);
    cmp     ebx, @@left
    jle     @@skip_call1

    push    eax

    push    ebx
    push    @@left
    call    quick_sort

    pop     eax

@@skip_call1:

      ; if(i<right) depth_sorting(i, right);
    cmp     eax, @@right
    jge     @@skip_call2

    push    @@right
    push    eax
    call    quick_sort

@@skip_call2:

    pop     ebp
    ret     8
endp

;************************************************************
;    NormalizeStruct3d()
;
;    in: esi = ptr to struct3d
;************************************************************
NormalizeStruct3d proc

    call    GetStruct3dRadius

    mov     edi, d [esi + S3D_PTR_B_VERTS]
    mov     ecx, d [esi + S3D_N_VERTS]
NS3d_do:
    fld     d [edi + 0]
    fdiv    st(0), st(1)
    fstp    d [edi + 0]
    fld     d [edi + 4]
    fdiv    st(0), st(1)
    fstp    d [edi + 4]
    fld     d [edi + 8]
    fdiv    st(0), st(1)
    fstp    d [edi + 8]
    add     edi, 12
    dec     ecx
    jnz     NS3d_do

    ffree   st(0)
    ret
endp

;************************************************************
;    GetStruct3dRadius()
;
;    in: esi = ptr to struct3d
;    out: st(0) = radius
;************************************************************
GetStruct3dRadius proc
    mov     edi, d [esi + S3D_PTR_B_VERTS]
    mov     ecx, d [esi + S3D_N_VERTS]

    xor     eax, eax
    mov     ebx, esp
    push    eax
GSR_get:
    fld     d [edi + 0]
    fmul    st(0), st(0)
    fld     d [edi + 4]
    fmul    st(0), st(0)
    faddp   st(1), st(0)
    fld     d [edi + 8]
    fmul    st(0), st(0)
    faddp   st(1), st(0)
    fcom    d [ebx - 4]
    fstsw   ax
    sahf
    jb      GSR_next
    fst     d [ebx - 4]
GSR_next:
    ffree   st(0)
    add     edi, 12
    dec     ecx
    jnz     GSR_get

    fld     d [ebx - 4]
    fsqrt
    pop     eax
    ret
endp

;************************************************************
;    ScaleStruct3d()
;
;    in: edi = ptr to struct3d,
;    st(0) = scalez, st(1) = scaley, st(2) = scalex
;************************************************************
ScaleStruct3d proc
    mov     ecx, d [edi + S3D_N_VERTS]
    mov     edi, d [edi + S3D_PTR_B_VERTS]

SS3d_loop:
    fld     d [edi + 0]
    fmul    st(0), st(3)
    fstp    d [edi + 0]

    fld     d [edi + 4]
    fmul    st(0), st(2)
    fstp    d [edi + 4]

    fld     d [edi + 8]
    fmul    st(0), st(1)
    fstp    d [edi + 8]

    add     edi, 12
    dec     ecx
    jnz     SS3d_loop

    ffree   st(0)
    ffree   st(0)
    ffree   st(0)
    ret
endp

;************************************************************
;    CenterStruct3d()
;
;    in: edi = ptr to struct3d
;************************************************************
CenterStruct3d_Fog proc
    push    edi
    mov     edi, o min_x
    xor     eax, eax
    mov     ecx, 6
    rep     stosd
    pop     edi

    mov     esi, d [edi + S3D_PTR_B_VERTS]
    mov     ecx, d [edi + S3D_N_VERTS]
CS3dA_1:
    push    ecx


    mov     ecx, 3
    mov     ebp, o min_x
CS3dA_2:
    fld     d [esi]
    fcom    d [ebp + 0]    ; min
    fstsw   ax
    sahf
    ja      CS3dA_skip1
    fstp    d [ebp + 0]
    jmp     CS3dA_ok1
CS3dA_skip1:
    ffree   st(0)
CS3dA_ok1:
    fld     d [esi]
    fcom    d [ebp + 4]    ; max
    fstsw   ax
    sahf
    jb      CS3dA_skip2
    fstp    d [ebp + 4]
    jmp     CS3dA_ok2
CS3dA_skip2:
    ffree   st(0)
CS3dA_ok2:
    add     esi, 4
    add     ebp, 8
    loop    CS3dA_2

    pop     ecx
    loop    CS3dA_1


    mov     ecx, 3
    mov     ebp, o min_x
CS3dA_make:
    fld     d [ebp + 4]    ; max
    fsub    d [ebp + 0]    ; min
    fmul    d [CS3dA_mulval]
    fstp    d [ebp + 0]    ; min
    add     ebp, 8
    loop    CS3dA_make

    mov     esi, d [edi + S3D_PTR_B_VERTS]
    mov     ecx, d [edi + S3D_N_VERTS]
CS3dA_final:
    fld     d [esi + 0]
    fsub    d [min_x]
    fstp    d [esi + 0]

    fld     d [esi + 4]
    fsub    d [min_y]
    fstp    d [esi + 4]

    fld     d [esi + 8]
    fsub    d [min_z]
    fstp    d [esi + 8]

    add     esi, 12
    loop    CS3dA_final
    ret
endp

;------------------------------------------------------------

; in: edi = ptr to struct3d
CenterStruct3d proc
    fldz
    fst     q [str3d_ox]
    fst     q [str3d_oy]
    fstp    q [str3d_oz]


    mov     ebp, d [edi.s3d_points]
    mov     ecx, d [edi.s3d_n_points]
CS3d_add:
    fld     q [str3d_ox]
    fadd    d [ebp.x3d]
    fstp    q [str3d_ox]

    fld     q [str3d_oy]
    fadd    d [ebp.y3d]
    fstp    q [str3d_oy]

    fld     q [str3d_oz]
    fadd    d [ebp.z3d]
    fstp    q [str3d_oz]
    add     ebp, size point3d
    loop    CS3d_add


    fld     q [str3d_ox]
    fidiv   d [edi.s3d_n_points]
    fstp    q [str3d_ox]

    fld     q [str3d_oy]
    fidiv   d [edi.s3d_n_points]
    fstp    q [str3d_oy]

    fld     q [str3d_oz]
    fidiv   d [edi.s3d_n_points]
    fstp    q [str3d_oz]


    mov     ebp, d [edi.s3d_points]
    mov     ecx, d [edi.s3d_n_points]
CS3d_move:
    fld     d [ebp.x3d]
    fsub    q [str3d_ox]
    fstp    d [ebp.x3d]

    fld     d [ebp.y3d]
    fsub    q [str3d_oy]
    fstp    d [ebp.y3d]

    fld     d [ebp.z3d]
    fsub    q [str3d_oz]
    fstp    d [ebp.z3d]

    add     ebp, size point3d
    loop    CS3d_move
    ret
endp

;------------------------------------------------------------
;    in:    esi - offset to struct3d
;    out:    none
;------------------------------------------------------------

init_point_normals proc
    xor     ecx, ecx
@@make_n:

    mov     sum_x, 0
    mov     sum_y, 0
    mov     sum_z, 0

    mov     n_hit, 0

    mov     ebp, d [esi.s3d_faces]
    mov     edx, d [esi.s3d_n_faces]
@@f:

    movzx   eax, w [ebp.face_v1]
    cmp     eax, ecx
    je      @@face_hit
    movzx   eax, w [ebp.face_v2]
    cmp     eax, ecx
    je      @@face_hit
    movzx   eax, w [ebp.face_v3]
    cmp     eax, ecx
    je      @@face_hit

    jmp     @@next_f
@@face_hit:
    inc     n_hit

      ; make face-normal
    push    edx
    mov     edx, esi


    movzx   esi, w [ebp.face_v1]
    mov     eax, esi
    shl     esi, 2
    shl     eax, 3
    add     esi, eax
    add     esi, d [edx.s3d_points]

    movzx   edi, w [ebp.face_v2]
    mov     eax, edi
    shl     edi, 2
    shl     eax, 3
    add     edi, eax
    add     edi, d [edx.s3d_points]

    mov     ebx, o vec1
    call    make_vector

    mov     esi, edi

    movzx   edi, w [ebp.face_v3]
    mov     eax, edi
    shl     edi, 2
    shl     eax, 3
    add     edi, eax
    add     edi, d [edx.s3d_points]

    mov     ebx, o vec2
    call    make_vector

    mov     esi, o vec1
    mov     edi, o vec2
    mov     ebx, o vec3
    call    cross_product


    fld     sum_x
    fadd    vec3.vec_x
    fstp    sum_x

    fld     sum_y
    fadd    vec3.vec_y
    fstp    sum_y

    fld     sum_z
    fadd    vec3.vec_z
    fstp    sum_z


    mov     esi, edx
    pop     edx
@@next_f:
    add     ebp, size face
    dec     edx
    jnz     @@f


    mov     eax, ecx
    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     eax, ebx
    add     eax, d [esi.s3d_point_nrm]

    fld     sum_x
    fidiv   n_hit
    fstp    d [eax.vec_x]

    fld     sum_y
    fidiv   n_hit
    fstp    d [eax.vec_y]

    fld     sum_z
    fidiv   n_hit
    fstp    d [eax.vec_z]

    mov     edi, eax
    call    normalize_vector

    inc     ecx
    cmp     ecx, d [esi.s3d_n_points]
    jne     @@make_n
    ret
endp


CS3dA_mulval dd 0.5

vec1 vector3d ?
vec2 vector3d ?
vec3 vector3d ?

f_x1 dw ?
f_y1 dw ?
f_x2 dw ?
f_y2 dw ?
f_x3 dw ?
f_y3 dw ?

min_x dd ?
max_x dd ?
min_y dd ?
max_y dd ?
min_z dd ?
max_z dd ?

sum_x dd ?
sum_y dd ?
sum_z dd ?

n_hit dd ?

str3d_ox dq ?
str3d_oy dq ?
str3d_oz dq ?

rot_mx matrix ?

code32 ends

end
