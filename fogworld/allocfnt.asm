include allocfnt.inc
include math3d.inc
include letgen.inc
include engine.inc
include share.inc

.386p


code32 segment para public use32
    assume cs:code32,  ds:code32

; in: eax = ASCII code
; out: eax = requested bytes
; esi = number of vertices, edi = number of faces
GetLetterMem proc
    mov     ebp, eax

    movzx   eax, w [FontTable + ebp*4 + 0]
    mov     esi, eax
    push    eax

    shl     eax, 2
    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     eax, ebx

    pop     ebx
    shl     ebx, 2
    add     eax, ebx
    push    eax

    movzx   eax, w [FontTable + ebp*4 + 2]
    mov     edi, eax
    push    eax

    mov     ebx, eax
    shl     eax, 1
    shl     ebx, 2
    add     eax, ebx

    pop     ebx
    shl     ebx, 2
    add     eax, ebx

    pop     ebx
    add     eax, ebx
    ret
endp

;------------------------------------------------------------

; in: esi = ptr to ASCIIZ string, ecx = string's lenght
; out: eax = requested bytes
; esi = number of vertices, edi = number of faces
GetStringMem proc
    cld
    xor     edx, edx  ; bytes
    xor     ebx, ebx  ; vertices
    xor     ebp, ebp  ; faces
BS_loop:
    lodsb
    movzx   eax, al
    push    esi

    push    ebx
    push    edx
    push    ebp

    call    GetLetterMem

    pop     ebp
    pop     edx
    pop     ebx

    add     edx, eax
    add     ebx, esi
    add     ebp, edi

    pop     esi
    loop    BS_loop

    mov     eax, edx
    mov     d [MemSize], edx
    mov     esi, ebx
    mov     d [max_verts], ebx
    mov     edi, ebp
    mov     d [max_faces], ebp
    ret
endp

;------------------------------------------------------------

; in: eax = ptr to allocated memory block, edi = ptr to struct3d
SetAddress2Struct3d proc
    mov     ecx, d [max_verts]
    mov     ebx, ecx
    shl     ecx, 2
    shl     ebx, 3
    add     ecx, ebx
    push    ecx

    mov     d [edi.s3d_points], eax
    add     eax, ecx
    mov     d [edi.s3d_r_points], eax
    add     eax, ecx

    mov     ecx, d [max_verts]
    shl     ecx, 2

    mov     d [edi.s3d_t_points], eax
    add     eax, ecx

    mov     ecx, d [max_faces]
    mov     ebx, ecx
    shl     ecx, 1
    shl     ebx, 2
    add     ecx, ebx

    mov     d [edi.s3d_faces], eax
    add     eax, ecx

    mov     ecx, d [max_faces]
    shl     ecx, 1

    mov     d [edi.s3d_depths], eax
    add     eax, ecx
    mov     d [edi.s3d_order], eax
    add     eax, ecx

    pop     ecx
    mov     d [edi.s3d_point_nrm], eax
    add     eax, ecx
    mov     d [edi.s3d_r_point_nrm], eax
    ret
endp

;------------------------------------------------------------

Add2Struct3d proc
    mov     ebp, d [BigStructPtr]

    mov     eax, d [Buffer3d.ts3d_n_points]
    add     d [ebp.s3d_n_points], eax
    mov     eax, d [Buffer3d.ts3d_n_faces]
    add     d [ebp.s3d_n_faces], eax

      ; copy vertices
    mov     ecx, d [Buffer3d.ts3d_n_points]
    mov     eax, ecx
    shl     ecx, 1
    add     ecx, eax
    mov     esi, d [Buffer3d.ts3d_points]
    mov     edi, d [ebp.s3d_points]
    add     edi, d [VertsOfs]
    cld
    rep     movsd

      ; copy faces
    mov     ecx, d [Buffer3d.ts3d_n_faces]
    mov     eax, ecx
    shl     ecx, 1
    add     ecx, eax
    mov     esi, d [Buffer3d.ts3d_faces]
    mov     edi, d [ebp.s3d_faces]
    add     edi, d [FacesOfs]
A2S3d_copy_face:
    lodsw
    add     ax, w [Verts2Add]
    stosw
    dec     ecx
    jnz     A2S3d_copy_face

      ; copy to small struct
    mov     edx, d [SmallStructPtr]

    mov     eax, d [Buffer3d.s3d_n_points]
    mov     d [edx.s3d_n_points], eax

    mov     eax, d [ebp.s3d_points]
    add     eax, d [VertsOfs]
    mov     d [edx.s3d_points], eax

    mov     eax, d [ebp.s3d_r_points]
    add     eax, d [VertsOfs]
    mov     d [edx.s3d_r_points], eax

    mov     eax, d [ebp.s3d_t_points]
    add     eax, d [Verts2dOfs]
    mov     d [edx.s3d_t_points], eax

    mov     eax, d [ebp.s3d_point_nrm]
    add     eax, d [VertsOfs]
    mov     d [edx.s3d_point_nrm], eax

    mov     eax, d [ebp.s3d_r_point_nrm]
    add     eax, d [VertsOfs]
    mov     d [edx.s3d_r_point_nrm], eax


    mov     eax, d [Buffer3d.ts3d_n_points]
    push    eax
    add     w [Verts2Add], ax

    mov     ebx, eax
    shl     eax, 2
    shl     ebx, 3
    add     eax, ebx
    add     d [VertsOfs], eax

    pop     eax
    shl     eax, 2
    add     d [Verts2dOfs], eax

    mov     eax, d [Buffer3d.ts3d_n_faces]
    mov     ebx, eax
    shl     eax, 1
    shl     ebx, 2
    add     eax, ebx
    add     d [FacesOfs], eax

    inc     d [CurrLetter]
    add     d [SmallStructPtr], size struct3d
    ret
endp

;------------------------------------------------------------

; in: esi = ptr to string, edi = ptr to structs, ebx = ptr to big struct
; eax = ptr to allocated memory, ecx = string's lenght
MassiveMakeString3d proc
    push    ebx
    push    ecx
    push    edx
    push    edi
    mov     edi, ebx
    call    SetAddress2Struct3d
    pop     edi
    pop     edx
    pop     ecx
    pop     ebx

    mov     d [BigStructPtr], ebx
    mov     d [SmallStructPtr], edi

    mov     d [ebx.s3d_n_points], 0
    mov     d [ebx.s3d_n_faces], 0

    xor     eax, eax
    mov     d [CurrLetter], eax
    mov     d [VertsOfs], eax
    mov     d [Verts2dOfs], eax
    mov     d [FacesOfs], eax
    mov     d [Verts2Add], eax

    cld
MMS3d_letter:
    lodsb
    movzx   eax, al
    push    esi
    push    ecx
    call    MakeLetter3d
    pop     ecx
    pop     esi
    loop    MMS3d_letter

    mov     esi, d [BigStructPtr]
    call    init_point_normals
    ret
endp

;------------------------------------------------------------

BigStructPtr dd ?
SmallStructPtr dd ?
CurrLetter dd ?

MemSize dd ?
max_verts dd ?
max_faces dd ?

VertsOfs dd ?
Verts2dOfs dd ?
FacesOfs dd ?
Verts2Add dd ?

FontTable:
 dw    8,   12   ; 0
 dw    146,   280   ; 1
 dw    152,   312   ; 2
 dw    100,   196   ; 3
 dw    80,   156   ; 4
 dw    112,   220   ; 5
 dw    88,   172   ; 6
 dw    42,   80   ; 7
 dw    152,   304   ; 8
 dw    80,   160   ; 9
 dw    162,   320   ; 10
 dw    112,   224   ; 11
 dw    106,   212   ; 12
 dw    98,   196   ; 13
 dw    126,   252   ; 14
 dw    136,   272   ; 15
 dw    80,   156   ; 16
 dw    80,   156   ; 17
 dw    94,   184   ; 18
 dw    96,   176   ; 19
 dw    122,   244   ; 20
 dw    118,   240   ; 21
 dw    56,   108   ; 22
 dw    118,   232   ; 23
 dw    68,   132   ; 24
 dw    68,   132   ; 25
 dw    60,   116   ; 26
 dw    60,   116   ; 27
 dw    50,   96   ; 28
 dw    76,   148   ; 29
 dw    84,   164   ; 30
 dw    84,   164   ; 31
 dw    8,   12   ; 32
 dw    60,   112   ; 33
 dw    48,   88   ; 34
 dw    112,   224   ; 35
 dw    88,   172   ; 36
 dw    88,   164   ; 37
 dw    106,   220   ; 38
 dw    26,   48   ; 39
 dw    56,   108   ; 40
 dw    56,   108   ; 41
 dw    88,   172   ; 42
 dw    52,   100   ; 43
 dw    26,   48   ; 44
 dw    28,   52   ; 45
 dw    18,   32   ; 46
 dw    56,   108   ; 47
 dw    112,   220   ; 48
 dw    68,   132   ; 49
 dw    98,   192   ; 50
 dw    92,   180   ; 51
 dw    96,   192   ; 52
 dw    96,   188   ; 53
 dw    88,   176   ; 54
 dw    74,   144   ; 55
 dw    100,   204   ; 56
 dw    88,   176   ; 57
 dw    36,   64   ; 58
 dw    44,   80   ; 59
 dw    60,   116   ; 60
 dw    56,   104   ; 61
 dw    60,   116   ; 62
 dw    70,   132   ; 63
 dw    114,   224   ; 64
 dw    94,   188   ; 65
 dw    112,   228   ; 66
 dw    88,   172   ; 67
 dw    104,   208   ; 68
 dw    112,   220   ; 69
 dw    96,   188   ; 70
 dw    100,   196   ; 71
 dw    100,   196   ; 72
 dw    64,   124   ; 73
 dw    80,   156   ; 74
 dw    108,   212   ; 75
 dw    86,   168   ; 76
 dw    116,   228   ; 77
 dw    112,   220   ; 78
 dw    96,   192   ; 79
 dw    94,   188   ; 80
 dw    96,   192   ; 81
 dw    110,   220   ; 82
 dw    92,   180   ; 83
 dw    80,   156   ; 84
 dw    100,   196   ; 85
 dw    90,   176   ; 86
 dw    112,   220   ; 87
 dw    100,   196   ; 88
 dw    86,   168   ; 89
 dw    116,   228   ; 90
 dw    64,   124   ; 91
 dw    56,   108   ; 92
 dw    64,   124   ; 93
 dw    52,   100   ; 94
 dw    36,   68   ; 95
 dw    26,   48   ; 96
 dw    78,   156   ; 97
 dw    90,   180   ; 98
 dw    72,   140   ; 99
 dw    90,   180   ; 100
 dw    74,   148   ; 101
 dw    78,   152   ; 102
 dw    94,   188   ; 103
 dw    96,   188   ; 104
 dw    60,   112   ; 105
 dw    78,   148   ; 106
 dw    96,   188   ; 107
 dw    60,   116   ; 108
 dw    88,   172   ; 109
 dw    74,   144   ; 110
 dw    72,   144   ; 111
 dw    88,   176   ; 112
 dw    88,   176   ; 113
 dw    76,   148   ; 114
 dw    76,   148   ; 115
 dw    66,   128   ; 116
 dw    78,   152   ; 117
 dw    66,   128   ; 118
 dw    88,   172   ; 119
 dw    80,   156   ; 120
 dw    88,   172   ; 121
 dw    80,   156   ; 122
 dw    68,   132   ; 123
 dw    48,   92   ; 124
 dw    68,   132   ; 125
 dw    44,   84   ; 126
 dw    84,   168   ; 127
 dw    100,   196   ; 128
 dw    102,   192   ; 129
 dw    88,   176   ; 130
 dw    106,   216   ; 131
 dw    102,   196   ; 132
 dw    102,   208   ; 133
 dw    86,   168   ; 134
 dw    78,   152   ; 135
 dw    84,   164   ; 136
 dw    98,   188   ; 137
 dw    110,   220   ; 138
 dw    92,   184   ; 139
 dw    72,   144   ; 140
 dw    96,   188   ; 141
 dw    112,   224   ; 142
 dw    94,   184   ; 143
 dw    90,   176   ; 144
 dw    88,   168   ; 145
 dw    78,   148   ; 146
 dw    96,   188   ; 147
 dw    96,   184   ; 148
 dw    90,   172   ; 149
 dw    80,   152   ; 150
 dw    102,   200   ; 151
 dw    90,   176   ; 152
 dw    108,   216   ; 153
 dw    100,   188   ; 154
 dw    78,   152   ; 155
 dw    84,   160   ; 156
 dw    86,   168   ; 157
 dw    80,   156   ; 158
 dw    98,   192   ; 159
 dw    92,   184   ; 160
 dw    62,   120   ; 161
 dw    74,   148   ; 162
 dw    82,   164   ; 163
 dw    118,   236   ; 164
 dw    90,   184   ; 165
 dw    108,   212   ; 166
 dw    102,   196   ; 167
 dw    108,   212   ; 168
 dw    84,   168   ; 169
 dw    8,   12   ; 170
 dw    86,   164   ; 171
 dw    106,   208   ; 172
 dw    84,   164   ; 173
 dw    88,   168   ; 174
 dw    88,   168   ; 175
 dw    128,   192   ; 176
 dw    158,   384   ; 177
 dw    160,   352   ; 178
 dw    54,   104   ; 179
 dw    66,   128   ; 180
 dw    98,   196   ; 181
 dw    116,   236   ; 182
 dw    114,   224   ; 183
 dw    98,   192   ; 184
 dw    124,   236   ; 185
 dw    108,   208   ; 186
 dw    100,   192   ; 187
 dw    88,   168   ; 188
 dw    110,   216   ; 189
 dw    68,   128   ; 190
 dw    42,   80   ; 191
 dw    48,   92   ; 192
 dw    60,   116   ; 193
 dw    54,   104   ; 194
 dw    66,   128   ; 195
 dw    36,   68   ; 196
 dw    78,   152   ; 197
 dw    112,   224   ; 198
 dw    104,   208   ; 199
 dw    80,   152   ; 200
 dw    92,   176   ; 201
 dw    96,   180   ; 202
 dw    108,   204   ; 203
 dw    116,   220   ; 204
 dw    72,   136   ; 205
 dw    132,   248   ; 206
 dw    84,   168   ; 207
 dw    98,   196   ; 208
 dw    108,   216   ; 209
 dw    110,   220   ; 210
 dw    100,   188   ; 211
 dw    102,   200   ; 212
 dw    108,   216   ; 213
 dw    66,   128   ; 214
 dw    80,   160   ; 215
 dw    100,   200   ; 216
 dw    48,   92   ; 217
 dw    42,   80   ; 218
 dw    162,   320   ; 219
 dw    90,   176   ; 220
 dw    76,   148   ; 221
 dw    96,   196   ; 222
 dw    90,   176   ; 223
 dw    94,   188   ; 224
 dw    90,   184   ; 225
 dw    112,   228   ; 226
 dw    104,   208   ; 227
 dw    94,   184   ; 228
 dw    106,   212   ; 229
 dw    108,   212   ; 230
 dw    92,   180   ; 231
 dw    100,   200   ; 232
 dw    94,   184   ; 233
 dw    76,   152   ; 234
 dw    106,   208   ; 235
 dw    104,   204   ; 236
 dw    90,   176   ; 237
 dw    74,   144   ; 238
 dw    20,   36   ; 239
 dw    20,   36   ; 240
 dw    40,   72   ; 241
 dw    20,   36   ; 242
 dw    32,   60   ; 243
 dw    40,   76   ; 244
 dw    112,   232   ; 245
 dw    64,   116   ; 246
 dw    20,   36   ; 247
 dw    52,   104   ; 248
 dw    24,   40   ; 249
 dw    12,   20   ; 250
 dw    106,   200   ; 251
 dw    110,   220   ; 252
 dw    88,   176   ; 253
 dw    50,   96   ; 254
 dw    8,   12   ; 255

code32 ends

end
