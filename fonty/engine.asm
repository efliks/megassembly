include share.inc
include math3d.inc
include struct3d.inc
include grd3.inc
include engine.inc

.386p
locals


code32 segment para public use32
    assume cs:code32,  ds:code32

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

LightVector vector3d <0.0, 0.0, -1.0>

code32 ends

end
