include share.inc
include math3d.inc

.386p
locals


code32 segment para public use32
    assume cs:code32, ds:code32

;************************************************************
;    MakeVector()
;
;    in: esi = ptr to 1st vertex, edi = ptr to 2nd vertex,
;    ebx = ptr to result vector
;************************************************************
make_vector proc
    fld     d [edi + 0]
    fsub    d [esi + 0]

    fld     d [edi + 4]
    fsub    d [esi + 4]

    fld     d [edi + 8]
    fsub    d [esi + 8]

    fstp    d [ebx + 8]
    fstp    d [ebx + 4]
    fstp    d [ebx + 0]
    ret
endp

;************************************************************
;    GetVectorLenght()
;
;    in: esi = ptr to 1st vertex, edi = ptr to 2nd vertex
;    out: st(0) = lenght
;************************************************************
get_vector_lenght proc
    fld     d [edi + 0]
    fsub    d [esi + 0]
    fmul    st(0), st(0)

    fld     d [edi + 4]
    fsub    d [esi + 4]
    fmul    st(0), st(0)

    fld     d [edi + 8]
    fsub    d [esi + 8]
    fmul    st(0), st(0)

    faddp   st(1), st(0)
    faddp   st(1), st(0)
    fsqrt
    ret
endp

;************************************************************
;    NormalizeVector()
;
;    in: edi = ptr to vector
;************************************************************
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

;************************************************************
;    CrossProduct()
;
;    in: esi = ptr to 1st vector, edi = ptr to 2nd vector,
;    ebx = ptr to result vector
;************************************************************
cross_product proc
    fld     d [esi + 4]
    fmul    d [edi + 8]
    fld     d [esi + 8]
    fmul    d [edi + 4]
    fsubp   st(1), st(0)
    fstp    d [ebx + 0]

    fld     d [esi + 8]
    fmul    d [edi + 0]
    fld     d [esi + 0]
    fmul    d [edi + 8]
    fsubp   st(1), st(0)
    fstp    d [ebx + 4]

    fld     d [esi + 0]
    fmul    d [edi + 4]
    fld     d [esi + 4]
    fmul    d [edi + 0]
    fsubp   st(1), st(0)
    fstp    d [ebx + 8]
    ret
endp

;************************************************************
;    DotProduct()
;
;    in: esi = ptr to 1st vector, edi = ptr to 2nd vector
;    out: st(0) = dot-product
;************************************************************
dot_product proc
    fld     d [esi + 0]
    fmul    d [edi + 0]

    fld     d [esi + 4]
    fmul    d [edi + 4]

    fld     d [esi + 8]
    fmul    d [edi + 8]

    faddp   st(1), st(0)
    faddp   st(1), st(0)
    ret
endp

code32 ends

end
