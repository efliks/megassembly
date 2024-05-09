include share.inc
include math3d.inc
include grd3.inc
include engine.inc

.386p
locals


code32 segment para public use32
    assume cs:code32,  ds:code32

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

;------------------------------------------------------------
;    in:    esi - offset to struct3d
;    out:    none
;------------------------------------------------------------

comment #
render_struct3d proc
    mov     eax, d [esi.s3d_bmap]
    mov     t_bmap, eax
    mov     eax, d [esi.s3d_emap]
    mov     t_emap, eax

    mov     edi, d [esi.s3d_order]
    mov     ecx, d [esi.s3d_vis_faces]
@@draw:
    push    esi
    push    edi
    push    ecx

    movzx   edi, w [edi]
    mov     edx, edi
    mov     eax, edi
    shl     edi, 1
    shl     eax, 2
    add     edi, eax
    add     edi, d [esi.s3d_faces]


    push    edi
    mov     ebp, o t_x1
    mov     ecx, 3
@@load_tri:
    movzx   eax, w [edi]
    shl     eax, 2
    add     eax, d [esi.s3d_t_points]
    movsx   ebx, w [eax.x2d]
    mov     d [ebp], ebx
    movsx   ebx, w [eax.y2d]
    mov     d [ebp + 4], ebx
    add     edi, 2
    add     ebp, 8
    dec     ecx
    jnz     @@load_tri
    pop     edi


;    movzx   ebx, w [edi.face_v1]
;    shl     ebx, 2
;    add     ebx, d [esi.s3d_t_points]
;    movsx   eax, w [ebx.x2d]
;    mov     t_x1, eax
;    mov     ax, w [ebx.y2d]
;    movsx   eax, ax
;    mov     t_y1, eax
;
;    movzx   ebx, w [edi.face_v2]
;    shl     ebx, 2
;    add     ebx, d [esi.s3d_t_points]
;    mov     ax, w [ebx.x2d]
;    movsx   eax, ax
;    mov     t_x2, eax
;    mov     ax, w [ebx.y2d]
;    movsx   eax, ax
;    mov     t_y2, eax
;
;    movzx   ebx, w [edi.face_v3]
;    shl     ebx, 2
;    add     ebx, d [esi.s3d_t_points]
;    mov     ax, w [ebx.x2d]
;    movsx   eax, ax
;    mov     t_x3, eax
;    mov     ax, w [ebx.y2d]
;    movsx   eax, ax
;    mov     t_y3, eax

    mov     eax, edx
    shl     edx, 1
    shl     eax, 2
    add     edx, eax

    add     edx, d [esi.s3d_tex_coords]
    push    edi
    mov     edi, o b_x1
    mov     ecx, 6
@@load_tex:
    movzx   eax, b [edx]
    stosd
    inc     edx
    dec     ecx
    jnz     @@load_tex

    pop     edx
    mov     edi, o e_x1
    mov     ecx, 3
@@load_env:
    movzx   eax, w [edx]
    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     ebx, eax
    add     ebx, d [esi.s3d_r_point_nrm]

    fld     d [ebx.vec_x]
    fmul    _63
    fadd    _63
    fistp   d [edi]

    fld     d [ebx.vec_y]
    fmul    _63
    fadd    _63
    fistp   d [edi + 4]

    add     edx, 2
    add     edi, 8
    dec     ecx
    jnz     @@load_env

    call    bump_triangle

@@next_face:
    pop     ecx
    pop     edi
    pop     esi
    add     edi, 2
    dec     ecx
    jnz     @@draw

    ret
endp
#

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

;------------------------------------------------------------

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


_63    dd 63.0

f_x1 dw ?
f_y1 dw ?
f_x2 dw ?
f_y2 dw ?
f_x3 dw ?
f_y3 dw ?

sum_x dd ?
sum_y dd ?
sum_z dd ?

n_hit dd ?

vec1 vector3d ?
vec2 vector3d ?
vec3 vector3d ?

GouraudColors dd 63.0

DotMin dd 0.0
DotMax dd 1.0

MC_temp dd ?
rot_mx matrix ?

LightVector vector3d <0.0, 0.0, -1.0>

code32 ends

end
