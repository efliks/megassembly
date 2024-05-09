include math3d.inc
include struct3d.inc
include bumptri.inc
include common.inc
include engine.inc

.386p
locals


code32 segment para public use32
    assume cs:code32,  ds:code32


;------------------------------------------------------------
;    in:    esi - offset to struct3d
;    out:    none
;------------------------------------------------------------

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

_63 dd 63.0

code32 ends

end
