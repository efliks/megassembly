include share.inc
include math3d.inc
include struct3d.inc
include grd3.inc
include engine.inc

.386p
locals


code32 segment para public use32
    assume cs:code32,  ds:code32

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


GouraudColors dd 63.0

LightVector vector3d <0.0, 0.0, -1.0>

DotMin dd 0.0
DotMax dd 1.0

MC_temp dd ?

code32 ends

end
