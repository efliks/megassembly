include share.inc
include engine.inc
include math3d.inc
include struct3d.inc
include flattri.inc
include grdtri.inc

.386p
locals


code32 segment para public use32
    assume cs:code32,  ds:code32

;************************************************************
;    MakeRotationMatrix()
;
;    in: esi = ptr to angles (float), edi = ptr to matrix
;************************************************************
MakeRotationMatrix proc
    fld     d [esi + 0]
    fld     st(0)
    fsin
    fstp    d [sin_x]
    fcos
    fstp    d [cos_x]

    fld     d [esi + 4]
    fld     st(0)
    fsin
    fstp    d [sin_y]
    fcos
    fstp    d [cos_y]

    fld     d [esi + 8]
    fld     st(0)
    fsin
    fstp    d [sin_z]
    fcos
    fstp    d [cos_z]


    fld     d [cos_y]
    fmul    d [cos_z]
    fstp    d [edi + 0 * 4 + 0 * 12]

    fld     d [sin_x]
    fmul    d [sin_y]
    fmul    d [cos_z]
    fld     d [cos_x]
    fchs
    fmul    d [sin_z]
    faddp   st(1), st(0)
    fstp    d [edi + 0 * 4 + 1 * 12]

    fld     d [cos_x]
    fmul    d [sin_y]
    fmul    d [cos_z]
    fld     d [sin_x]
    fmul    d [sin_z]
    faddp   st(1), st(0)
    fstp    d [edi + 0 * 4 + 2 * 12]

    fld     d [cos_y]
    fmul    d [sin_z]
    fstp    d [edi + 1 * 4 + 0 * 12]

    fld     d [sin_x]
    fmul    d [sin_y]
    fmul    d [sin_z]
    fld     d [cos_x]
    fmul    d [cos_z]
    faddp   st(1), st(0)
    fstp    d [edi + 1 * 4 + 1 * 12]

    fld     d [cos_x]
    fmul    d [sin_y]
    fmul    d [sin_z]
    fld     d [sin_x]
    fchs
    fmul    d [cos_z]
    faddp   st(1), st(0)
    fstp    d [edi + 1 * 4 + 2 * 12]

    fld     d [sin_y]
    fchs
    fstp    d [edi + 2 * 4 + 0 * 12]

    fld     d [cos_y]
    fmul    d [sin_x]
    fstp    d [edi + 2 * 4 + 1 * 12]

    fld     d [cos_x]
    fmul    d [cos_y]
    fstp    d [edi + 2 * 4 + 2 * 12]
    ret
endp

;************************************************************
;    TransformVector()
;
;    in: edi = ptr to vector, ebx = ptr to matrix
;************************************************************
TransformVector proc
    mov     eax, esp
    push    d [edi + 0]
    push    d [edi + 4]
    push    d [edi + 8]

    fld     d [eax - 4]
    fmul    d [ebx + 0 * 4 + 0 * 12]
    fld     d [eax - 8]
    fmul    d [ebx + 0 * 4 + 1 * 12]
    faddp   st(1), st(0)
    fld     d [eax - 12]
    fmul    d [ebx + 0 * 4 + 2 * 12]
    faddp   st(1), st(0)
    fstp    d [edi + 0]

    fld     d [eax - 4]
    fmul    d [ebx + 1 * 4 + 0 * 12]
    fld     d [eax - 8]
    fmul    d [ebx + 1 * 4 + 1 * 12]
    faddp   st(1), st(0)
    fld     d [eax - 12]
    fmul    d [ebx + 1 * 4 + 2 * 12]
    faddp   st(1), st(0)
    fstp    d [edi + 4]

    fld     d [eax - 4]
    fmul    d [ebx + 2 * 4 + 0 * 12]
    fld     d [eax - 8]
    fmul    d [ebx + 2 * 4 + 1 * 12]
    faddp   st(1), st(0)
    fld     d [eax - 12]
    fmul    d [ebx + 2 * 4 + 2 * 12]
    faddp   st(1), st(0)
    fstp    d [edi + 8]

    add     esp, 12
    ret
endp

;************************************************************
;    TranslateVertices()
;
;    in: esi = ptr to 3d vertices, edi = ptr to 2d vertices,
;    ecx = number of vetices
;************************************************************
TranslateVertices proc
    mov     d [SkippedVerts], 0
TV_do:
    fld     d [esi + 8]
    ftst
    fstsw   ax
    sahf
    jae     TV_ok
    ffree   st(0)
    mov     w [esi + 0], -1
    inc     d [SkippedVerts]
    jmp     TV_next
TV_ok:
    fld     d [esi + 0]
    fmul    d [TV_persp]
    fdiv    st(0), st(1)
    fadd    d [TV_corrx]
    fistp   w [edi + 0]

    fld     d [esi + 4]
    fmul    d [TV_persp]
    fdivrp  st(1), st(0)
    fadd    d [TV_corry]
    fistp   w [edi + 2]
TV_next:
    add     esi, 12
    add     edi, 4
    dec     ecx
    jnz     TV_do
    ret
endp

;************************************************************
;    MakeCameraMatrix()
;
;    in: edi = ptr to camera
;************************************************************
MakeCameraMatrix proc
    mov     ebp, edi

    fld     d [ebp + CAM_ROLL]
    fld     st(0)
    fsin
    fstp    d [cam_vec_u + 0]
    fcos
    fchs
    fstp    d [cam_vec_u + 4]
    xor     eax, eax
    mov     d [cam_vec_u + 8], eax

    lea     esi, [ebp + CAM_POS]
    lea     edi, [ebp + CAM_TARGET]
    mov     ebx, o cam_vec_f
    call    make_vector
    mov     edi, ebx
    call    normalize_vector

    mov     esi, o cam_vec_u
    mov     edi, o cam_vec_f
    mov     ebx, o cam_vec_r
    call    cross_product
    mov     edi, ebx
    call    normalize_vector

    mov     esi, o cam_vec_f
    mov     edi, o cam_vec_r
    mov     ebx, o cam_vec_u
    call    cross_product

    mov     eax, d [cam_vec_r + 0]
    mov     d [ebp + CAM_MATRIX + 0 * 4 + 0 * 12], eax
    mov     eax, d [cam_vec_r + 4]
    mov     d [ebp + CAM_MATRIX + 0 * 4 + 1 * 12], eax
    mov     eax, d [cam_vec_r + 8]
    mov     d [ebp + CAM_MATRIX + 0 * 4 + 2 * 12], eax

    mov     eax, d [cam_vec_u + 0]
    mov     d [ebp + CAM_MATRIX + 1 * 4 + 0 * 12], eax
    mov     eax, d [cam_vec_u + 4]
    mov     d [ebp + CAM_MATRIX + 1 * 4 + 1 * 12], eax
    mov     eax, d [cam_vec_u + 8]
    mov     d [ebp + CAM_MATRIX + 1 * 4 + 2 * 12], eax

    mov     eax, d [cam_vec_f + 0]
    mov     d [ebp + CAM_MATRIX + 2 * 4 + 0 * 12], eax
    mov     eax, d [cam_vec_f + 4]
    mov     d [ebp + CAM_MATRIX + 2 * 4 + 1 * 12], eax
    mov     eax, d [cam_vec_f + 8]
    mov     d [ebp + CAM_MATRIX + 2 * 4 + 2 * 12], eax
    ret
endp

;************************************************************
;    ObjectProc()
;
;    in: esi = ptr to object3d
;************************************************************
ObjectProc proc
    cmp     d [esi + O_FLAGS], OF_STATIC
    jne     OP_ok
    ret
OP_ok:
    push    ebp
    push    ecx
    push    esi

    mov     ebp, esi
    mov     esi, d [ebp + O_PTR_STRUCT3D]

    lea     edi, [ebp + O_MATRIX]
    mov     ebx, edi
    push    esi
    lea     esi, [ebp + O_ANGLE_X]
    call    MakeRotationMatrix
    pop     esi

    mov     edi, d [esi + S3D_PTR_R_VERTS]
    mov     ecx, d [esi + S3D_N_VERTS]
OP_r:
    call    TransformVector
    fld     d [edi + 0]
    fadd    d [ebp + O_POS + 0]
    fstp    d [edi + 0]
    fld     d [edi + 4]
    fadd    d [ebp + O_POS + 4]
    fstp    d [edi + 4]
    fld     d [edi + 8]
    fadd    d [ebp + O_POS + 8]
    fstp    d [edi + 8]
    add     edi, 12
    dec     ecx
    jnz     OP_r

    fld     d [ebp + O_ANGLE_X]
    fadd    d [ebp + O_ADD_ANGLE_X]
    fstp    d [ebp + O_ANGLE_X]
    fld     d [ebp + O_ANGLE_Y]
    fadd    d [ebp + O_ADD_ANGLE_Y]
    fstp    d [ebp + O_ANGLE_Y]
    fld     d [ebp + O_ANGLE_Z]
    fadd    d [ebp + O_ADD_ANGLE_Z]
    fstp    d [ebp + O_ANGLE_Z]

    pop     esi
    pop     ecx
    pop     ebp
    ret
endp

;************************************************************
;    RenderWorld()
;
;    in: esi = ptr to world
;************************************************************
RenderWorld proc
    mov     ebp, esi

    mov     edx, d [ebp + W_PTR_STRUCT3D]
    mov     ecx, d [edx + S3D_N_VERTS]
    push    edx
    push    ecx

    mov     eax, ecx
    shl     ecx, 1
    add     ecx, eax
    mov     esi, d [edx + S3D_PTR_B_VERTS]
    mov     edi, d [edx + S3D_PTR_R_VERTS]
    push    edi
    cld
    rep     movsd

    mov     ecx, d [ebp + W_NUM_OF_OBJECTS]
    mov     esi, d [ebp + W_PTR_OBJECTS]
RW_ObjLoop:
    call    ObjectProc
    add     esi, OBJECT3D_SIZE
    dec     ecx
    jnz     RW_ObjLoop

    push    ebp
    mov     edi, d [ebp + W_PTR_CAMERA]
    mov     d [CurrCamPtr], edi    ; <- requied by GetVertexColorDist()
    push    edi
    push    edi
    call    UpdateCamera
    pop     edi
    call    MakeCameraMatrix
    pop     esi
    lea     ebx, [esi + CAM_MATRIX]
    pop     ebp

    pop     edi
    pop     ecx
    pop     edx
    push    ecx
    push    edi
RW_CamLoop:
    fld     d [edi + 0]
    fsub    d [esi + CAM_POS + 0]
    fstp    d [edi + 0]
    fld     d [edi + 4]
    fsub    d [esi + CAM_POS + 4]
    fstp    d [edi + 4]
    fld     d [edi + 8]
    fsub    d [esi + CAM_POS + 8]
    fstp    d [edi + 8]
    call    TransformVector
    add     edi, 12
    dec     ecx
    jnz     RW_CamLoop

    pop     esi
    pop     ecx
    mov     edi, d [edx + S3D_PTR_T_VERTS]
    call    TranslateVertices

    push    edx
    mov     esi, edx
    call    sort_faces
    pop     edx
    call    render_struct3d
    ret
endp

;************************************************************
;    MakeLinearTrack()
;
;    in: esi = source vertex, edi = destination vertex,
;    ebx = ptr to track, ecx = track lenght,
;    eax = ptr to allocated memory block
;************************************************************
MakeLinearTrack proc
    mov     ebp, ebx
    mov     d [ebp + T_NUM_OF_VERTS], ecx
    mov     d [ebp + T_PTR_VERTS], eax
    mov     ebp, eax

    sub     esp, 12 + 4
    mov     ebx, esp
    call    make_vector

    mov     d [ebx + 12], ecx
    fild    d [ebx + 12]

    fld     d [ebx + 0]
    fdiv    st(0), st(1)
    fstp    d [ebx + 0]

    fld     d [ebx + 4]
    fdiv    st(0), st(1)
    fstp    d [ebx + 4]

    fld     d [ebx + 8]
    fdivrp  st(1), st(0)
    fstp    d [ebx + 8]

    fld     d [esi + 0]
    fld     d [esi + 4]
    fld     d [esi + 8]

        ;    st0    st1    st2    st3    st4    st5    st6    st7
        ;    z    y    x

MLT_do:
    fxch    st(2)
    fst     d [ebp + 0]
    fadd    d [ebx + 0]
    fxch    st(2)

    fxch    st(1)
    fst     d [ebp + 4]
    fadd    d [ebx + 4]
    fxch    st(1)

    fst     d [ebp + 8]
    fadd    d [ebx + 8]

    add     ebp, 12
    dec     ecx
    jnz     MLT_do

    ;ffree    st(0)
    ;ffree    st(0)
    ;ffree    st(0)
    finit

    add     esp, 12 + 4
    ret
endp

;************************************************************
;    GetVertexColorDist()
;
;    in: esi = ptr to struct3d, eax = number of vertex (1, 2 or 3),
;    ebx = number of face,
;    out: eax = color
;
;    Funcion uses CurrCamPtr as a pointer to camera !!!
;************************************************************
GetVertexColorDist proc
    mov     ecx, ebx
    shl     ecx, 1
    shl     ebx, 2
    add     ebx, ecx
    add     ebx, d [esi + S3D_PTR_FACES]
    dec     eax
    shl     eax, 1
    add     ebx, eax

    movzx   eax, w [ebx]
    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     ebx, eax
    add     ebx, d [esi + S3D_PTR_R_VERTS]

    push    edi
    push    esi
    mov     esi, o DefaultCamPos
    mov     edi, ebx
    call    get_vector_lenght
    fmul    d [GVCD_z_const]
    pop     esi
    pop     edi

    mov     ebx, esp
    push    eax
    fistp   d [ebx - 4]
    mov     eax, d [ebx - 4]
    pop     ebx
    neg     eax
    add     eax, 63

    add     eax, MOVE_PAL_COLOR

    or      eax, eax
    jg      GVCD_ok1
    mov     eax, MIN_COLOR
    jmp     GVCD_ok2
GVCD_ok1:
    cmp     eax, 63
    jle     GVCD_ok2
    mov     eax, 63
GVCD_ok2:
    ret
endp

;************************************************************
;    GetVertexColorZ()
;
;    in: esi = ptr to struct3d, eax = number of vertex (1, 2 or 3),
;    ebx = number of face
;    out: eax = color
;************************************************************
GetVertexColorZ proc
    mov     ecx, ebx
    shl     ecx, 1
    shl     ebx, 2
    add     ebx, ecx
    add     ebx, d [esi + S3D_PTR_FACES]
    dec     eax
    shl     eax, 1
    add     ebx, eax

    movzx   eax, w [ebx]
    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     ebx, eax
    add     ebx, d [esi + S3D_PTR_R_VERTS]

    fld     d [ebx + 8]
    fmul    d [GVC_z_const]
    fsubr    d [GVC_n_colors]
    mov     ebx, esp
    push    eax
    fistp   d [ebx - 4]
    mov     eax, d [ebx - 4]
    pop     ebx

    add     eax, MOVE_PAL_COLOR

    or      eax, eax
    jg      GVC_col_ok1
    mov     eax, MIN_COLOR
    jmp     GVC_col_ok2
GVC_col_ok1:
    cmp     eax, 63
    jle     GVC_col_ok2
    mov     eax, 63

GVC_col_ok2:
    ret
endp

;************************************************************
;    UpdateCamera()
;
;    in: edi = ptr to camera
;************************************************************
UpdateCamera proc
    mov     ebp, edi

    mov     eax, d [ebp + CAM_TRACK_POS]
    mov     ebx, d [ebp + CAM_TRACK_LEN]
    dec     ebx
    cmp     eax, ebx
    je      UP_reset1
    inc     eax
    jmp     UP_update1
UP_reset1:
    xor     eax, eax
UP_update1:
    mov     d [ebp + CAM_TRACK_POS], eax

    mov     ebx, d [ebp + CAM_FLAGS]
    cmp     ebx, CF_NO_TARGET
    je      UP_no_tar

    ret
UP_no_tar:
    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     ebx, eax
    add     ebx, d [ebp + CAM_PTR_TRACK]
    mov     eax, d [ebx + 0]
    mov     d [ebp + CAM_POS + 0], eax
    mov     eax, d [ebx + 4]
    mov     d [ebp + CAM_POS + 4], eax
    mov     eax, d [ebx + 8]
    mov     d [ebp + CAM_POS + 8], eax
    xor     eax, eax
    mov     d [ebp + CAM_TARGET + 0], eax
    mov     d [ebp + CAM_TARGET + 4], eax
    mov     d [ebp + CAM_TARGET + 8], eax
    ret
endp

;************************************************************
;    SetTrack()
;
;    in: esi = ptr to track, ecx = track lenght, edi = ptr
;    to camera, eax = track type
;************************************************************
SetTrack proc
    mov     d [edi + CAM_PTR_TRACK], esi
    mov     d [edi + CAM_TRACK_LEN], ecx
    mov     d [edi + CAM_FLAGS], eax
    xor     eax, eax
    mov     d [edi + CAM_TRACK_POS], eax
    ret
endp

;************************************************************
;    GetStruct3dSize()
;
;    in: esi = ptr to struct3d, eax = 'x', 'y' or 'z'
;    out: st(0) = size
;************************************************************
GetStruct3dSize proc
    ret
endp

;------------------------------------------------------------
;    in:    esi - offset to struct3d
;    out:    none
;------------------------------------------------------------

sort_faces proc
    mov     edi, dword ptr [esi.s3d_faces]
    xor     ecx, ecx
    mov     dword ptr [esi.s3d_vis_faces], 0
@@add_face:
    movzx   ebx, word ptr [edi.face_v1]
    shl     ebx, 2
    add     ebx, dword ptr [esi.s3d_t_points]
    mov     ax, word ptr [ebx.x2d]
    mov     f_x1, ax
    mov     ax, word ptr [ebx.y2d]
    mov     f_y1, ax

    movzx   ebx, word ptr [edi.face_v2]
    shl     ebx, 2
    add     ebx, dword ptr [esi.s3d_t_points]
    mov     ax, word ptr [ebx.x2d]
    mov     f_x2, ax
    mov     ax, word ptr [ebx.y2d]
    mov     f_y2, ax

    movzx   ebx, word ptr [edi.face_v3]
    shl     ebx, 2
    add     ebx, dword ptr [esi.s3d_t_points]
    mov     ax, word ptr [ebx.x2d]
    mov     f_x3, ax
    mov     ax, word ptr [ebx.y2d]
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

    movzx   eax, word ptr [edi.face_v1]
    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     eax, ebx
    add     eax, dword ptr [esi.s3d_r_points]
    fld     dword ptr [eax.z3d]

    movzx   eax, word ptr [edi.face_v2]
    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     eax, ebx
    add     eax, dword ptr [esi.s3d_r_points]
    fadd    dword ptr [eax.z3d]

    movzx   eax, word ptr [edi.face_v3]
    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     eax, ebx
    add     eax, dword ptr [esi.s3d_r_points]
    fadd    dword ptr [eax.z3d]


    fcom    min_d
    fstsw   ax
    sahf
    ja      @@dist_ok

    ffree   st
    jmp     @@next_face

comment #
    fcom    d [min_d]
    fstsw   ax
    sahf
    ja      _sf_check1
    ffree   st(0)
    jmp     @@next_face

_sf_check1:
    fcom    d [max_d]
    fstsw   ax
    sahf
    jb      @@dist_ok
    ffree   st(0)
    jmp     @@next_face #

@@dist_ok:
    mov     eax, dword ptr [esi.s3d_vis_faces]
    shl     eax, 1
    mov     ebx, eax

    add     eax, dword ptr [esi.s3d_order]
    mov     word ptr [eax], cx

    add     ebx, dword ptr [esi.s3d_depths]
    fistp   word ptr [ebx]

    inc     dword ptr [esi.s3d_vis_faces]
@@next_face:
    add     edi, type face
    inc     ecx
    cmp     ecx, dword ptr [esi.s3d_n_faces]
    jne     @@add_face

    mov     eax, dword ptr [esi.s3d_vis_faces]
    or      eax, eax
    jnz     @@launch_qsort
    ret
@@launch_qsort:
    dec     eax
    push    eax
    push    large 0
    call    quick_sort
    ret
endp

;------------------------------------------------------------
;    in:    esi - offset to struct3d
;        stack: left,  right
;    out:    none
;------------------------------------------------------------

quick_sort proc

@@left equ dword ptr [ebp+8]
@@right equ dword ptr [ebp+12]

    push    ebp
    mov     ebp, esp

    mov     eax, @@left
    mov     ebx, @@right

        ; element=face_depth[(left+right)>>1];
    mov     edi, eax
    add     edi, ebx
    sar     edi, 1
    shl     edi, 1
    add     edi, dword ptr [esi.s3d_depths]
    mov     dx, word ptr [edi]

        ; while(i<j)
    cmp     eax, ebx
    jge     @@break_main
@@main:

        ; while(face_depth[i]>element) i++;
    mov     edi, eax
    shl     edi, 1
    add     edi, dword ptr [esi.s3d_depths]
@@small1:
    cmp     word ptr [edi], dx
    jle     @@break_small1
    inc     eax
    add     edi, 2
    jmp     @@small1
@@break_small1:

        ; while(face_depth[j]<element) j--;
    mov     edi, ebx
    shl     edi, 1
    add     edi, dword ptr [esi.s3d_depths]
@@small2:
    cmp     word ptr [edi], dx
    jge     @@break_small2
    dec     ebx
    sub     edi, 2
    jmp     @@small2
@@break_small2:

        ; if(i<=j)
    cmp     eax, ebx
    jg      @@skip_xchg

    mov     edi, dword ptr [esi.s3d_depths]
    mov     cx, word ptr [edi + eax*2]
    xchg    cx, word ptr [edi + ebx*2]
    mov     word ptr [edi + eax*2], cx

    mov     edi, dword ptr [esi.s3d_order]
    mov     cx, word ptr [edi + eax*2]
    xchg    cx, word ptr [edi + ebx*2]
    mov     word ptr [edi + eax*2], cx

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

render_struct3d proc
    mov     edi, dword ptr [esi.s3d_order]
    mov     ecx, dword ptr [esi.s3d_vis_faces]
    or      ecx, ecx
    jnz     @@draw
    ret
@@draw:
    push    edi
    push    ecx

    movzx   edi, word ptr [edi]
    mov     edx, edi
    mov     eax, edi
    shl     edi, 1
    shl     eax, 2
    add     edi, eax
    add     edi, dword ptr [esi.s3d_faces]

    movzx   ebx, word ptr [edi.face_v1]
    shl     ebx, 2
    add     ebx, dword ptr [esi.s3d_t_points]
    mov     ax, word ptr [ebx.x2d]
    movsx   eax, ax
    mov     t_x1, eax
    mov     ax, word ptr [ebx.y2d]
    movsx   eax, ax
    mov     t_y1, eax

    movzx   ebx, word ptr [edi.face_v2]
    shl     ebx, 2
    add     ebx, dword ptr [esi.s3d_t_points]
    mov     ax, word ptr [ebx.x2d]
    movsx   eax, ax
    mov     t_x2, eax
    mov     ax, word ptr [ebx.y2d]
    movsx   eax, ax
    mov     t_y2, eax

    movzx   ebx, word ptr [edi.face_v3]
    shl     ebx, 2
    add     ebx, dword ptr [esi.s3d_t_points]
    mov     ax, word ptr [ebx.x2d]
    movsx   eax, ax
    mov     t_x3, eax
    mov     ax, word ptr [ebx.y2d]
    movsx   eax, ax
    mov     t_y3, eax

;    mov     al, b [FlatFlag]
;    cmp     al, 1
;    je      rs3d_flt

    mov     eax, 1
    mov     ebx, edx
    call    d [CurrColorProc]
    mov     ebx, edx
    and     ebx, 2    ;3
    shl     ebx, 6
    add     ebx, eax
    mov     d [GrdCol1], ebx

    mov     eax, 2
    mov     ebx, edx
    call    d [CurrColorProc]
    mov     ebx, edx
    and     ebx, 2    ;3
    shl     ebx, 6
    add     ebx, eax
    mov     d [GrdCol2], ebx

    mov     eax, 3
    mov     ebx, edx
    call    d [CurrColorProc]
    mov     ebx, edx
    and     ebx, 2    ;3
    shl     ebx, 6
    add     ebx, eax
    mov     d [GrdCol3], ebx

    mov     eax, d [t_x1]
    mov     d [GrdX1], eax
    mov     eax, d [t_y1]
    mov     d [GrdY1], eax
    mov     eax, d [t_x2]
    mov     d [GrdX2], eax
    mov     eax, d [t_y2]
    mov     d [GrdY2], eax
    mov     eax, d [t_x3]
    mov     d [GrdX3], eax
    mov     eax, d [t_y3]
    mov     d [GrdY3], eax

    call    GouraudTriangle

    jmp     @@next_face

rs3d_flt:
    mov     eax, 1
    mov     ebx, edx
    call    d [CurrColorProc]

    and     edx, 2    ;3
    shl     edx, 6
    add     edx, eax
    mov     d [t_col], edx

    call    flat_triangle

@@next_face:
    pop     ecx
    pop     edi
    add     edi, 2
    dec     ecx
    jnz     @@draw

    ret
endp

comment #
;------------------------------------------------------------
;    in:    esi - offset to struct3d
;    out:    none
;------------------------------------------------------------

init_face_normals proc
    mov     ebp, esi

    mov     eax, dword ptr [ebp.s3d_faces]
    mov     edx, dword ptr [ebp.s3d_face_nrm]
    mov     ecx, dword ptr [ebp.s3d_n_faces_]
@@get_n:
    movzx   esi, word ptr [eax.face_v1]
    mov     ebx, esi
    shl     esi, 2
    shl     ebx, 3
    add     esi, ebx
    add     esi, dword ptr [ebp.s3d_points]

    movzx   edi, word ptr [eax.face_v2]
    mov     ebx, edi
    shl     edi, 2
    shl     ebx, 3
    add     edi, ebx
    add     edi, dword ptr [ebp.s3d_points]

    mov     ebx, offset uv
    call    make_vector

    mov     esi, edi

    movzx   edi, word ptr [eax.face_v3]
    mov     ebx, edi
    shl     edi, 2
    shl     ebx, 3
    add     edi, ebx
    add     edi, dword ptr [ebp.s3d_points]

    mov     ebx, offset fv
    call    make_vector

    mov     esi, offset uv
    mov     edi, offset fv
    mov     ebx, edx
    call    CrossProduct

    mov     edi, edx
    call    normalize_vector

    add     eax, size face
    add     edx, size vector3d
    dec     ecx
    jnz     @@get_n
    ret
endp #


TV_persp    dd 256.0
TV_stdcx    dd 160.0
TV_stdcy    dd 100.0
TV_corrx    dd 160.0
TV_corry    dd 100.0

sin_x        dd 0
cos_x        dd 0
sin_y        dd 0
cos_y        dd 0
sin_z        dd 0
cos_z        dd 0

cam_vec_f    db 12 dup(0)
cam_vec_u    db 12 dup(0)
cam_vec_r    db 12 dup(0)

SkippedVerts    dd 0
;CurrLightModel    dd 0

GVC_n_colors    dd 63.0
GVC_z_const    dd 0.04

GVCD_z_const    dd 0.04
CurrCamPtr    dd 0
DefaultCamPos    dd 0, 0, 0

CurrColorProc    dd o GetVertexColorDist

uv    vector3d ?
fv    vector3d ?
rv    vector3d ?

f_x1    dw ?
f_y1    dw ?
f_x2    dw ?
f_y2    dw ?
f_x3    dw ?
f_y3    dw ?

min_d dd 500.0
max_d dd 4200.0

code32 ends

end
