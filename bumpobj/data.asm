include data.inc

.386p

code32 segment para public use32
    assume cs:code32, ds:code32

points LABEL DWORD
   dd  80.0,  40.0,  0.0
   dd  103.0,  32.0,  0.0
   dd  118.0,  12.0,  0.0
   dd  118.0,  -12.0,  0.0
   dd  103.0,  -32.0,  0.0
   dd  80.0,  -40.0,  0.0
   dd  56.0,  -32.0,  0.0
   dd  41.0,  -12.0,  0.0
   dd  41.0,  12.0,  0.0
   dd  56.0,  32.0,  0.0
   dd  76.0,  40.0,  24.0
   dd  98.0,  32.0,  31.0
   dd  112.0,  12.0,  36.0
   dd  112.0,  -12.0,  36.0
   dd  98.0,  -32.0,  31.0
   dd  76.0,  -40.0,  24.0
   dd  53.0,  -32.0,  17.0
   dd  39.0,  -12.0,  12.0
   dd  39.0,  12.0,  12.0
   dd  53.0,  32.0,  17.0
   dd  64.0,  40.0,  47.0
   dd  83.0,  32.0,  60.0
   dd  95.0,  12.0,  69.0
   dd  95.0,  -12.0,  69.0
   dd  83.0,  -32.0,  60.0
   dd  64.0,  -40.0,  47.0
   dd  45.0,  -32.0,  33.0
   dd  33.0,  -12.0,  24.0
   dd  33.0,  12.0,  24.0
   dd  45.0,  32.0,  33.0
   dd  47.0,  40.0,  64.0
   dd  60.0,  32.0,  83.0
   dd  69.0,  12.0,  95.0
   dd  69.0,  -12.0,  95.0
   dd  60.0,  -32.0,  83.0
   dd  47.0,  -40.0,  64.0
   dd  33.0,  -32.0,  45.0
   dd  24.0,  -12.0,  33.0
   dd  24.0,  12.0,  33.0
   dd  33.0,  32.0,  45.0
   dd  24.0,  40.0,  76.0
   dd  31.0,  32.0,  98.0
   dd  36.0,  12.0,  112.0
   dd  36.0,  -12.0,  112.0
   dd  31.0,  -32.0,  98.0
   dd  24.0,  -40.0,  76.0
   dd  17.0,  -32.0,  53.0
   dd  12.0,  -12.0,  39.0
   dd  12.0,  12.0,  39.0
   dd  17.0,  32.0,  53.0
   dd  0.0,  40.0,  80.0
   dd  0.0,  32.0,  103.0
   dd  0.0,  12.0,  118.0
   dd  0.0,  -12.0,  118.0
   dd  0.0,  -32.0,  103.0
   dd  0.0,  -40.0,  80.0
   dd  0.0,  -32.0,  56.0
   dd  0.0,  -12.0,  41.0
   dd  0.0,  12.0,  41.0
   dd  0.0,  32.0,  56.0
   dd  -24.0,  40.0,  76.0
   dd  -31.0,  32.0,  98.0
   dd  -36.0,  12.0,  112.0
   dd  -36.0,  -12.0,  112.0
   dd  -31.0,  -32.0,  98.0
   dd  -24.0,  -40.0,  76.0
   dd  -17.0,  -32.0,  53.0
   dd  -12.0,  -12.0,  39.0
   dd  -12.0,  12.0,  39.0
   dd  -17.0,  32.0,  53.0
   dd  -47.0,  40.0,  64.0
   dd  -60.0,  32.0,  83.0
   dd  -69.0,  12.0,  95.0
   dd  -69.0,  -12.0,  95.0
   dd  -60.0,  -32.0,  83.0
   dd  -47.0,  -40.0,  64.0
   dd  -33.0,  -32.0,  45.0
   dd  -24.0,  -12.0,  33.0
   dd  -24.0,  12.0,  33.0
   dd  -33.0,  32.0,  45.0
   dd  -64.0,  40.0,  47.0
   dd  -83.0,  32.0,  60.0
   dd  -95.0,  12.0,  69.0
   dd  -95.0,  -12.0,  69.0
   dd  -83.0,  -32.0,  60.0
   dd  -64.0,  -40.0,  47.0
   dd  -45.0,  -32.0,  33.0
   dd  -33.0,  -12.0,  24.0
   dd  -33.0,  12.0,  24.0
   dd  -45.0,  32.0,  33.0
   dd  -76.0,  40.0,  24.0
   dd  -98.0,  32.0,  31.0
   dd  -112.0,  12.0,  36.0
   dd  -112.0,  -12.0,  36.0
   dd  -98.0,  -32.0,  31.0
   dd  -76.0,  -40.0,  24.0
   dd  -53.0,  -32.0,  17.0
   dd  -39.0,  -12.0,  12.0
   dd  -39.0,  12.0,  12.0
   dd  -53.0,  32.0,  17.0
   dd  -80.0,  40.0,  0.0
   dd  -103.0,  32.0,  0.0
   dd  -118.0,  12.0,  0.0
   dd  -118.0,  -12.0,  0.0
   dd  -103.0,  -32.0,  0.0
   dd  -80.0,  -40.0,  0.0
   dd  -56.0,  -32.0,  0.0
   dd  -41.0,  -12.0,  0.0
   dd  -41.0,  12.0,  0.0
   dd  -56.0,  32.0,  0.0
   dd  -76.0,  40.0,  -24.0
   dd  -98.0,  32.0,  -31.0
   dd  -112.0,  12.0,  -36.0
   dd  -112.0,  -12.0,  -36.0
   dd  -98.0,  -32.0,  -31.0
   dd  -76.0,  -40.0,  -24.0
   dd  -53.0,  -32.0,  -17.0
   dd  -39.0,  -12.0,  -12.0
   dd  -39.0,  12.0,  -12.0
   dd  -53.0,  32.0,  -17.0
   dd  -64.0,  40.0,  -47.0
   dd  -83.0,  32.0,  -60.0
   dd  -95.0,  12.0,  -69.0
   dd  -95.0,  -12.0,  -69.0
   dd  -83.0,  -32.0,  -60.0
   dd  -64.0,  -40.0,  -47.0
   dd  -45.0,  -32.0,  -33.0
   dd  -33.0,  -12.0,  -24.0
   dd  -33.0,  12.0,  -24.0
   dd  -45.0,  32.0,  -33.0
   dd  -47.0,  40.0,  -64.0
   dd  -60.0,  32.0,  -83.0
   dd  -69.0,  12.0,  -95.0
   dd  -69.0,  -12.0,  -95.0
   dd  -60.0,  -32.0,  -83.0
   dd  -47.0,  -40.0,  -64.0
   dd  -33.0,  -32.0,  -45.0
   dd  -24.0,  -12.0,  -33.0
   dd  -24.0,  12.0,  -33.0
   dd  -33.0,  32.0,  -45.0
   dd  -24.0,  40.0,  -76.0
   dd  -31.0,  32.0,  -98.0
   dd  -36.0,  12.0,  -112.0
   dd  -36.0,  -12.0,  -112.0
   dd  -31.0,  -32.0,  -98.0
   dd  -24.0,  -40.0,  -76.0
   dd  -17.0,  -32.0,  -53.0
   dd  -12.0,  -12.0,  -39.0
   dd  -12.0,  12.0,  -39.0
   dd  -17.0,  32.0,  -53.0
   dd  0.0,  40.0,  -80.0
   dd  0.0,  32.0,  -103.0
   dd  0.0,  12.0,  -118.0
   dd  0.0,  -12.0,  -118.0
   dd  0.0,  -32.0,  -103.0
   dd  0.0,  -40.0,  -80.0
   dd  0.0,  -32.0,  -56.0
   dd  0.0,  -12.0,  -41.0
   dd  0.0,  12.0,  -41.0
   dd  0.0,  32.0,  -56.0
   dd  24.0,  40.0,  -76.0
   dd  31.0,  32.0,  -98.0
   dd  36.0,  12.0,  -112.0
   dd  36.0,  -12.0,  -112.0
   dd  31.0,  -32.0,  -98.0
   dd  24.0,  -40.0,  -76.0
   dd  17.0,  -32.0,  -53.0
   dd  12.0,  -12.0,  -39.0
   dd  12.0,  12.0,  -39.0
   dd  17.0,  32.0,  -53.0
   dd  47.0,  40.0,  -64.0
   dd  60.0,  32.0,  -83.0
   dd  69.0,  12.0,  -95.0
   dd  69.0,  -12.0,  -95.0
   dd  60.0,  -32.0,  -83.0
   dd  47.0,  -40.0,  -64.0
   dd  33.0,  -32.0,  -45.0
   dd  24.0,  -12.0,  -33.0
   dd  24.0,  12.0,  -33.0
   dd  33.0,  32.0,  -45.0
   dd  64.0,  40.0,  -47.0
   dd  83.0,  32.0,  -60.0
   dd  95.0,  12.0,  -69.0
   dd  95.0,  -12.0,  -69.0
   dd  83.0,  -32.0,  -60.0
   dd  64.0,  -40.0,  -47.0
   dd  45.0,  -32.0,  -33.0
   dd  33.0,  -12.0,  -24.0
   dd  33.0,  12.0,  -24.0
   dd  45.0,  32.0,  -33.0
   dd  76.0,  40.0,  -24.0
   dd  98.0,  32.0,  -31.0
   dd  112.0,  12.0,  -36.0
   dd  112.0,  -12.0,  -36.0
   dd  98.0,  -32.0,  -31.0
   dd  76.0,  -40.0,  -24.0
   dd  53.0,  -32.0,  -17.0
   dd  39.0,  -12.0,  -12.0
   dd  39.0,  12.0,  -12.0
   dd  53.0,  32.0,  -17.0

faces LABEL WORD
   dw  9,  8,  18
   dw  9,  18,  19
   dw  8,  7,  17
   dw  8,  17,  18
   dw  7,  6,  16
   dw  7,  16,  17
   dw  6,  5,  15
   dw  6,  15,  16
   dw  5,  4,  14
   dw  5,  14,  15
   dw  4,  3,  13
   dw  4,  13,  14
   dw  3,  2,  12
   dw  3,  12,  13
   dw  2,  1,  11
   dw  2,  11,  12
   dw  1,  0,  10
   dw  1,  10,  11
   dw  0,  9,  19
   dw  0,  19,  10
   dw  19,  18,  28
   dw  19,  28,  29
   dw  18,  17,  27
   dw  18,  27,  28
   dw  17,  16,  26
   dw  17,  26,  27
   dw  16,  15,  25
   dw  16,  25,  26
   dw  15,  14,  24
   dw  15,  24,  25
   dw  14,  13,  23
   dw  14,  23,  24
   dw  13,  12,  22
   dw  13,  22,  23
   dw  12,  11,  21
   dw  12,  21,  22
   dw  11,  10,  20
   dw  11,  20,  21
   dw  10,  19,  29
   dw  10,  29,  20
   dw  29,  28,  38
   dw  29,  38,  39
   dw  28,  27,  37
   dw  28,  37,  38
   dw  27,  26,  36
   dw  27,  36,  37
   dw  26,  25,  35
   dw  26,  35,  36
   dw  25,  24,  34
   dw  25,  34,  35
   dw  24,  23,  33
   dw  24,  33,  34
   dw  23,  22,  32
   dw  23,  32,  33
   dw  22,  21,  31
   dw  22,  31,  32
   dw  21,  20,  30
   dw  21,  30,  31
   dw  20,  29,  39
   dw  20,  39,  30
   dw  39,  38,  48
   dw  39,  48,  49
   dw  38,  37,  47
   dw  38,  47,  48
   dw  37,  36,  46
   dw  37,  46,  47
   dw  36,  35,  45
   dw  36,  45,  46
   dw  35,  34,  44
   dw  35,  44,  45
   dw  34,  33,  43
   dw  34,  43,  44
   dw  33,  32,  42
   dw  33,  42,  43
   dw  32,  31,  41
   dw  32,  41,  42
   dw  31,  30,  40
   dw  31,  40,  41
   dw  30,  39,  49
   dw  30,  49,  40
   dw  49,  48,  58
   dw  49,  58,  59
   dw  48,  47,  57
   dw  48,  57,  58
   dw  47,  46,  56
   dw  47,  56,  57
   dw  46,  45,  55
   dw  46,  55,  56
   dw  45,  44,  54
   dw  45,  54,  55
   dw  44,  43,  53
   dw  44,  53,  54
   dw  43,  42,  52
   dw  43,  52,  53
   dw  42,  41,  51
   dw  42,  51,  52
   dw  41,  40,  50
   dw  41,  50,  51
   dw  40,  49,  59
   dw  40,  59,  50
   dw  59,  58,  68
   dw  59,  68,  69
   dw  58,  57,  67
   dw  58,  67,  68
   dw  57,  56,  66
   dw  57,  66,  67
   dw  56,  55,  65
   dw  56,  65,  66
   dw  55,  54,  64
   dw  55,  64,  65
   dw  54,  53,  63
   dw  54,  63,  64
   dw  53,  52,  62
   dw  53,  62,  63
   dw  52,  51,  61
   dw  52,  61,  62
   dw  51,  50,  60
   dw  51,  60,  61
   dw  50,  59,  69
   dw  50,  69,  60
   dw  69,  68,  78
   dw  69,  78,  79
   dw  68,  67,  77
   dw  68,  77,  78
   dw  67,  66,  76
   dw  67,  76,  77
   dw  66,  65,  75
   dw  66,  75,  76
   dw  65,  64,  74
   dw  65,  74,  75
   dw  64,  63,  73
   dw  64,  73,  74
   dw  63,  62,  72
   dw  63,  72,  73
   dw  62,  61,  71
   dw  62,  71,  72
   dw  61,  60,  70
   dw  61,  70,  71
   dw  60,  69,  79
   dw  60,  79,  70
   dw  79,  78,  88
   dw  79,  88,  89
   dw  78,  77,  87
   dw  78,  87,  88
   dw  77,  76,  86
   dw  77,  86,  87
   dw  76,  75,  85
   dw  76,  85,  86
   dw  75,  74,  84
   dw  75,  84,  85
   dw  74,  73,  83
   dw  74,  83,  84
   dw  73,  72,  82
   dw  73,  82,  83
   dw  72,  71,  81
   dw  72,  81,  82
   dw  71,  70,  80
   dw  71,  80,  81
   dw  70,  79,  89
   dw  70,  89,  80
   dw  89,  88,  98
   dw  89,  98,  99
   dw  88,  87,  97
   dw  88,  97,  98
   dw  87,  86,  96
   dw  87,  96,  97
   dw  86,  85,  95
   dw  86,  95,  96
   dw  85,  84,  94
   dw  85,  94,  95
   dw  84,  83,  93
   dw  84,  93,  94
   dw  83,  82,  92
   dw  83,  92,  93
   dw  82,  81,  91
   dw  82,  91,  92
   dw  81,  80,  90
   dw  81,  90,  91
   dw  80,  89,  99
   dw  80,  99,  90
   dw  99,  98,  108
   dw  99,  108,  109
   dw  98,  97,  107
   dw  98,  107,  108
   dw  97,  96,  106
   dw  97,  106,  107
   dw  96,  95,  105
   dw  96,  105,  106
   dw  95,  94,  104
   dw  95,  104,  105
   dw  94,  93,  103
   dw  94,  103,  104
   dw  93,  92,  102
   dw  93,  102,  103
   dw  92,  91,  101
   dw  92,  101,  102
   dw  91,  90,  100
   dw  91,  100,  101
   dw  90,  99,  109
   dw  90,  109,  100
   dw  109,  108,  118
   dw  109,  118,  119
   dw  108,  107,  117
   dw  108,  117,  118
   dw  107,  106,  116
   dw  107,  116,  117
   dw  106,  105,  115
   dw  106,  115,  116
   dw  105,  104,  114
   dw  105,  114,  115
   dw  104,  103,  113
   dw  104,  113,  114
   dw  103,  102,  112
   dw  103,  112,  113
   dw  102,  101,  111
   dw  102,  111,  112
   dw  101,  100,  110
   dw  101,  110,  111
   dw  100,  109,  119
   dw  100,  119,  110
   dw  119,  118,  128
   dw  119,  128,  129
   dw  118,  117,  127
   dw  118,  127,  128
   dw  117,  116,  126
   dw  117,  126,  127
   dw  116,  115,  125
   dw  116,  125,  126
   dw  115,  114,  124
   dw  115,  124,  125
   dw  114,  113,  123
   dw  114,  123,  124
   dw  113,  112,  122
   dw  113,  122,  123
   dw  112,  111,  121
   dw  112,  121,  122
   dw  111,  110,  120
   dw  111,  120,  121
   dw  110,  119,  129
   dw  110,  129,  120
   dw  129,  128,  138
   dw  129,  138,  139
   dw  128,  127,  137
   dw  128,  137,  138
   dw  127,  126,  136
   dw  127,  136,  137
   dw  126,  125,  135
   dw  126,  135,  136
   dw  125,  124,  134
   dw  125,  134,  135
   dw  124,  123,  133
   dw  124,  133,  134
   dw  123,  122,  132
   dw  123,  132,  133
   dw  122,  121,  131
   dw  122,  131,  132
   dw  121,  120,  130
   dw  121,  130,  131
   dw  120,  129,  139
   dw  120,  139,  130
   dw  139,  138,  148
   dw  139,  148,  149
   dw  138,  137,  147
   dw  138,  147,  148
   dw  137,  136,  146
   dw  137,  146,  147
   dw  136,  135,  145
   dw  136,  145,  146
   dw  135,  134,  144
   dw  135,  144,  145
   dw  134,  133,  143
   dw  134,  143,  144
   dw  133,  132,  142
   dw  133,  142,  143
   dw  132,  131,  141
   dw  132,  141,  142
   dw  131,  130,  140
   dw  131,  140,  141
   dw  130,  139,  149
   dw  130,  149,  140
   dw  149,  148,  158
   dw  149,  158,  159
   dw  148,  147,  157
   dw  148,  157,  158
   dw  147,  146,  156
   dw  147,  156,  157
   dw  146,  145,  155
   dw  146,  155,  156
   dw  145,  144,  154
   dw  145,  154,  155
   dw  144,  143,  153
   dw  144,  153,  154
   dw  143,  142,  152
   dw  143,  152,  153
   dw  142,  141,  151
   dw  142,  151,  152
   dw  141,  140,  150
   dw  141,  150,  151
   dw  140,  149,  159
   dw  140,  159,  150
   dw  159,  158,  168
   dw  159,  168,  169
   dw  158,  157,  167
   dw  158,  167,  168
   dw  157,  156,  166
   dw  157,  166,  167
   dw  156,  155,  165
   dw  156,  165,  166
   dw  155,  154,  164
   dw  155,  164,  165
   dw  154,  153,  163
   dw  154,  163,  164
   dw  153,  152,  162
   dw  153,  162,  163
   dw  152,  151,  161
   dw  152,  161,  162
   dw  151,  150,  160
   dw  151,  160,  161
   dw  150,  159,  169
   dw  150,  169,  160
   dw  169,  168,  178
   dw  169,  178,  179
   dw  168,  167,  177
   dw  168,  177,  178
   dw  167,  166,  176
   dw  167,  176,  177
   dw  166,  165,  175
   dw  166,  175,  176
   dw  165,  164,  174
   dw  165,  174,  175
   dw  164,  163,  173
   dw  164,  173,  174
   dw  163,  162,  172
   dw  163,  172,  173
   dw  162,  161,  171
   dw  162,  171,  172
   dw  161,  160,  170
   dw  161,  170,  171
   dw  160,  169,  179
   dw  160,  179,  170
   dw  179,  178,  188
   dw  179,  188,  189
   dw  178,  177,  187
   dw  178,  187,  188
   dw  177,  176,  186
   dw  177,  186,  187
   dw  176,  175,  185
   dw  176,  185,  186
   dw  175,  174,  184
   dw  175,  184,  185
   dw  174,  173,  183
   dw  174,  183,  184
   dw  173,  172,  182
   dw  173,  182,  183
   dw  172,  171,  181
   dw  172,  181,  182
   dw  171,  170,  180
   dw  171,  180,  181
   dw  170,  179,  189
   dw  170,  189,  180
   dw  189,  188,  198
   dw  189,  198,  199
   dw  188,  187,  197
   dw  188,  197,  198
   dw  187,  186,  196
   dw  187,  196,  197
   dw  186,  185,  195
   dw  186,  195,  196
   dw  185,  184,  194
   dw  185,  194,  195
   dw  184,  183,  193
   dw  184,  193,  194
   dw  183,  182,  192
   dw  183,  192,  193
   dw  182,  181,  191
   dw  182,  191,  192
   dw  181,  180,  190
   dw  181,  190,  191
   dw  180,  189,  199
   dw  180,  199,  190
   dw  199,  198,  8
   dw  199,  8,  9
   dw  198,  197,  7
   dw  198,  7,  8
   dw  197,  196,  6
   dw  197,  6,  7
   dw  196,  195,  5
   dw  196,  5,  6
   dw  195,  194,  4
   dw  195,  4,  5
   dw  194,  193,  3
   dw  194,  3,  4
   dw  193,  192,  2
   dw  193,  2,  3
   dw  192,  191,  1
   dw  192,  1,  2
   dw  191,  190,  0
   dw  191,  0,  1
   dw  190,  199,  9
   dw  190,  9,  0

tex_coords LABEL BYTE
   db  0,  0,  45,  0,  45,  45
   db  0,  0,  45,  45,  0,  45
   db  45,  45,  90,  45,  90,  90
   db  45,  45,  90,  90,  45,  90
   db  7,  7,  52,  7,  52,  52
   db  7,  7,  52,  52,  7,  52
   db  97,  97,  142,  97,  142,  142
   db  97,  97,  142,  142,  97,  142
   db  59,  59,  104,  59,  104,  104
   db  59,  59,  104,  104,  59,  104
   db  21,  21,  66,  21,  66,  66
   db  21,  21,  66,  66,  21,  66
   db  111,  111,  156,  111,  156,  156
   db  111,  111,  156,  156,  111,  156
   db  73,  73,  118,  73,  118,  118
   db  73,  73,  118,  118,  73,  118
   db  35,  35,  80,  35,  80,  80
   db  35,  35,  80,  80,  35,  80
   db  125,  125,  170,  125,  170,  170
   db  125,  125,  170,  170,  125,  170
   db  87,  87,  132,  87,  132,  132
   db  87,  87,  132,  132,  87,  132
   db  49,  49,  94,  49,  94,  94
   db  49,  49,  94,  94,  49,  94
   db  11,  11,  56,  11,  56,  56
   db  11,  11,  56,  56,  11,  56
   db  101,  101,  146,  101,  146,  146
   db  101,  101,  146,  146,  101,  146
   db  63,  63,  108,  63,  108,  108
   db  63,  63,  108,  108,  63,  108
   db  25,  25,  70,  25,  70,  70
   db  25,  25,  70,  70,  25,  70
   db  115,  115,  160,  115,  160,  160
   db  115,  115,  160,  160,  115,  160
   db  77,  77,  122,  77,  122,  122
   db  77,  77,  122,  122,  77,  122
   db  39,  39,  84,  39,  84,  84
   db  39,  39,  84,  84,  39,  84
   db  1,  1,  46,  1,  46,  46
   db  1,  1,  46,  46,  1,  46
   db  91,  91,  136,  91,  136,  136
   db  91,  91,  136,  136,  91,  136
   db  53,  53,  98,  53,  98,  98
   db  53,  53,  98,  98,  53,  98
   db  15,  15,  60,  15,  60,  60
   db  15,  15,  60,  60,  15,  60
   db  105,  105,  150,  105,  150,  150
   db  105,  105,  150,  150,  105,  150
   db  67,  67,  112,  67,  112,  112
   db  67,  67,  112,  112,  67,  112
   db  29,  29,  74,  29,  74,  74
   db  29,  29,  74,  74,  29,  74
   db  119,  119,  164,  119,  164,  164
   db  119,  119,  164,  164,  119,  164
   db  81,  81,  126,  81,  126,  126
   db  81,  81,  126,  126,  81,  126
   db  43,  43,  88,  43,  88,  88
   db  43,  43,  88,  88,  43,  88
   db  5,  5,  50,  5,  50,  50
   db  5,  5,  50,  50,  5,  50
   db  95,  95,  140,  95,  140,  140
   db  95,  95,  140,  140,  95,  140
   db  57,  57,  102,  57,  102,  102
   db  57,  57,  102,  102,  57,  102
   db  19,  19,  64,  19,  64,  64
   db  19,  19,  64,  64,  19,  64
   db  109,  109,  154,  109,  154,  154
   db  109,  109,  154,  154,  109,  154
   db  71,  71,  116,  71,  116,  116
   db  71,  71,  116,  116,  71,  116
   db  33,  33,  78,  33,  78,  78
   db  33,  33,  78,  78,  33,  78
   db  123,  123,  168,  123,  168,  168
   db  123,  123,  168,  168,  123,  168
   db  85,  85,  130,  85,  130,  130
   db  85,  85,  130,  130,  85,  130
   db  47,  47,  92,  47,  92,  92
   db  47,  47,  92,  92,  47,  92
   db  9,  9,  54,  9,  54,  54
   db  9,  9,  54,  54,  9,  54
   db  99,  99,  144,  99,  144,  144
   db  99,  99,  144,  144,  99,  144
   db  61,  61,  106,  61,  106,  106
   db  61,  61,  106,  106,  61,  106
   db  23,  23,  68,  23,  68,  68
   db  23,  23,  68,  68,  23,  68
   db  113,  113,  158,  113,  158,  158
   db  113,  113,  158,  158,  113,  158
   db  75,  75,  120,  75,  120,  120
   db  75,  75,  120,  120,  75,  120
   db  37,  37,  82,  37,  82,  82
   db  37,  37,  82,  82,  37,  82
   db  127,  127,  172,  127,  172,  172
   db  127,  127,  172,  172,  127,  172
   db  89,  89,  134,  89,  134,  134
   db  89,  89,  134,  134,  89,  134
   db  51,  51,  96,  51,  96,  96
   db  51,  51,  96,  96,  51,  96
   db  13,  13,  58,  13,  58,  58
   db  13,  13,  58,  58,  13,  58
   db  103,  103,  148,  103,  148,  148
   db  103,  103,  148,  148,  103,  148
   db  65,  65,  110,  65,  110,  110
   db  65,  65,  110,  110,  65,  110
   db  27,  27,  72,  27,  72,  72
   db  27,  27,  72,  72,  27,  72
   db  117,  117,  162,  117,  162,  162
   db  117,  117,  162,  162,  117,  162
   db  79,  79,  124,  79,  124,  124
   db  79,  79,  124,  124,  79,  124
   db  41,  41,  86,  41,  86,  86
   db  41,  41,  86,  86,  41,  86
   db  3,  3,  48,  3,  48,  48
   db  3,  3,  48,  48,  3,  48
   db  93,  93,  138,  93,  138,  138
   db  93,  93,  138,  138,  93,  138
   db  55,  55,  100,  55,  100,  100
   db  55,  55,  100,  100,  55,  100
   db  17,  17,  62,  17,  62,  62
   db  17,  17,  62,  62,  17,  62
   db  107,  107,  152,  107,  152,  152
   db  107,  107,  152,  152,  107,  152
   db  69,  69,  114,  69,  114,  114
   db  69,  69,  114,  114,  69,  114
   db  31,  31,  76,  31,  76,  76
   db  31,  31,  76,  76,  31,  76
   db  121,  121,  166,  121,  166,  166
   db  121,  121,  166,  166,  121,  166
   db  83,  83,  128,  83,  128,  128
   db  83,  83,  128,  128,  83,  128
   db  45,  45,  90,  45,  90,  90
   db  45,  45,  90,  90,  45,  90
   db  7,  7,  52,  7,  52,  52
   db  7,  7,  52,  52,  7,  52
   db  97,  97,  142,  97,  142,  142
   db  97,  97,  142,  142,  97,  142
   db  59,  59,  104,  59,  104,  104
   db  59,  59,  104,  104,  59,  104
   db  21,  21,  66,  21,  66,  66
   db  21,  21,  66,  66,  21,  66
   db  111,  111,  156,  111,  156,  156
   db  111,  111,  156,  156,  111,  156
   db  73,  73,  118,  73,  118,  118
   db  73,  73,  118,  118,  73,  118
   db  35,  35,  80,  35,  80,  80
   db  35,  35,  80,  80,  35,  80
   db  125,  125,  170,  125,  170,  170
   db  125,  125,  170,  170,  125,  170
   db  87,  87,  132,  87,  132,  132
   db  87,  87,  132,  132,  87,  132
   db  49,  49,  94,  49,  94,  94
   db  49,  49,  94,  94,  49,  94
   db  11,  11,  56,  11,  56,  56
   db  11,  11,  56,  56,  11,  56
   db  101,  101,  146,  101,  146,  146
   db  101,  101,  146,  146,  101,  146
   db  63,  63,  108,  63,  108,  108
   db  63,  63,  108,  108,  63,  108
   db  25,  25,  70,  25,  70,  70
   db  25,  25,  70,  70,  25,  70
   db  115,  115,  160,  115,  160,  160
   db  115,  115,  160,  160,  115,  160
   db  77,  77,  122,  77,  122,  122
   db  77,  77,  122,  122,  77,  122
   db  39,  39,  84,  39,  84,  84
   db  39,  39,  84,  84,  39,  84
   db  1,  1,  46,  1,  46,  46
   db  1,  1,  46,  46,  1,  46
   db  91,  91,  136,  91,  136,  136
   db  91,  91,  136,  136,  91,  136
   db  53,  53,  98,  53,  98,  98
   db  53,  53,  98,  98,  53,  98
   db  15,  15,  60,  15,  60,  60
   db  15,  15,  60,  60,  15,  60
   db  105,  105,  150,  105,  150,  150
   db  105,  105,  150,  150,  105,  150
   db  67,  67,  112,  67,  112,  112
   db  67,  67,  112,  112,  67,  112
   db  29,  29,  74,  29,  74,  74
   db  29,  29,  74,  74,  29,  74
   db  119,  119,  164,  119,  164,  164
   db  119,  119,  164,  164,  119,  164
   db  81,  81,  126,  81,  126,  126
   db  81,  81,  126,  126,  81,  126
   db  43,  43,  88,  43,  88,  88
   db  43,  43,  88,  88,  43,  88
   db  5,  5,  50,  5,  50,  50
   db  5,  5,  50,  50,  5,  50
   db  95,  95,  140,  95,  140,  140
   db  95,  95,  140,  140,  95,  140
   db  57,  57,  102,  57,  102,  102
   db  57,  57,  102,  102,  57,  102
   db  19,  19,  64,  19,  64,  64
   db  19,  19,  64,  64,  19,  64
   db  109,  109,  154,  109,  154,  154
   db  109,  109,  154,  154,  109,  154
   db  71,  71,  116,  71,  116,  116
   db  71,  71,  116,  116,  71,  116
   db  33,  33,  78,  33,  78,  78
   db  33,  33,  78,  78,  33,  78
   db  123,  123,  168,  123,  168,  168
   db  123,  123,  168,  168,  123,  168
   db  85,  85,  130,  85,  130,  130
   db  85,  85,  130,  130,  85,  130
   db  47,  47,  92,  47,  92,  92
   db  47,  47,  92,  92,  47,  92
   db  9,  9,  54,  9,  54,  54
   db  9,  9,  54,  54,  9,  54
   db  99,  99,  144,  99,  144,  144
   db  99,  99,  144,  144,  99,  144
   db  61,  61,  106,  61,  106,  106
   db  61,  61,  106,  106,  61,  106
   db  23,  23,  68,  23,  68,  68
   db  23,  23,  68,  68,  23,  68
   db  113,  113,  158,  113,  158,  158
   db  113,  113,  158,  158,  113,  158
   db  75,  75,  120,  75,  120,  120
   db  75,  75,  120,  120,  75,  120
   db  37,  37,  82,  37,  82,  82
   db  37,  37,  82,  82,  37,  82
   db  127,  127,  172,  127,  172,  172
   db  127,  127,  172,  172,  127,  172
   db  89,  89,  134,  89,  134,  134
   db  89,  89,  134,  134,  89,  134
   db  51,  51,  96,  51,  96,  96
   db  51,  51,  96,  96,  51,  96
   db  13,  13,  58,  13,  58,  58
   db  13,  13,  58,  58,  13,  58
   db  103,  103,  148,  103,  148,  148
   db  103,  103,  148,  148,  103,  148
   db  65,  65,  110,  65,  110,  110
   db  65,  65,  110,  110,  65,  110
   db  27,  27,  72,  27,  72,  72
   db  27,  27,  72,  72,  27,  72
   db  117,  117,  162,  117,  162,  162
   db  117,  117,  162,  162,  117,  162
   db  79,  79,  124,  79,  124,  124
   db  79,  79,  124,  124,  79,  124
   db  41,  41,  86,  41,  86,  86
   db  41,  41,  86,  86,  41,  86
   db  3,  3,  48,  3,  48,  48
   db  3,  3,  48,  48,  3,  48
   db  93,  93,  138,  93,  138,  138
   db  93,  93,  138,  138,  93,  138
   db  55,  55,  100,  55,  100,  100
   db  55,  55,  100,  100,  55,  100
   db  17,  17,  62,  17,  62,  62
   db  17,  17,  62,  62,  17,  62
   db  107,  107,  152,  107,  152,  152
   db  107,  107,  152,  152,  107,  152
   db  69,  69,  114,  69,  114,  114
   db  69,  69,  114,  114,  69,  114
   db  31,  31,  76,  31,  76,  76
   db  31,  31,  76,  76,  31,  76
   db  121,  121,  166,  121,  166,  166
   db  121,  121,  166,  166,  121,  166
   db  83,  83,  128,  83,  128,  128
   db  83,  83,  128,  128,  83,  128
   db  45,  45,  90,  45,  90,  90
   db  45,  45,  90,  90,  45,  90
   db  7,  7,  52,  7,  52,  52
   db  7,  7,  52,  52,  7,  52
   db  97,  97,  142,  97,  142,  142
   db  97,  97,  142,  142,  97,  142
   db  59,  59,  104,  59,  104,  104
   db  59,  59,  104,  104,  59,  104
   db  21,  21,  66,  21,  66,  66
   db  21,  21,  66,  66,  21,  66
   db  111,  111,  156,  111,  156,  156
   db  111,  111,  156,  156,  111,  156
   db  73,  73,  118,  73,  118,  118
   db  73,  73,  118,  118,  73,  118
   db  35,  35,  80,  35,  80,  80
   db  35,  35,  80,  80,  35,  80
   db  125,  125,  170,  125,  170,  170
   db  125,  125,  170,  170,  125,  170
   db  87,  87,  132,  87,  132,  132
   db  87,  87,  132,  132,  87,  132
   db  49,  49,  94,  49,  94,  94
   db  49,  49,  94,  94,  49,  94
   db  11,  11,  56,  11,  56,  56
   db  11,  11,  56,  56,  11,  56
   db  101,  101,  146,  101,  146,  146
   db  101,  101,  146,  146,  101,  146
   db  63,  63,  108,  63,  108,  108
   db  63,  63,  108,  108,  63,  108
   db  25,  25,  70,  25,  70,  70
   db  25,  25,  70,  70,  25,  70
   db  115,  115,  160,  115,  160,  160
   db  115,  115,  160,  160,  115,  160
   db  77,  77,  122,  77,  122,  122
   db  77,  77,  122,  122,  77,  122
   db  39,  39,  84,  39,  84,  84
   db  39,  39,  84,  84,  39,  84
   db  1,  1,  46,  1,  46,  46
   db  1,  1,  46,  46,  1,  46
   db  91,  91,  136,  91,  136,  136
   db  91,  91,  136,  136,  91,  136
   db  53,  53,  98,  53,  98,  98
   db  53,  53,  98,  98,  53,  98
   db  15,  15,  60,  15,  60,  60
   db  15,  15,  60,  60,  15,  60
   db  105,  105,  150,  105,  150,  150
   db  105,  105,  150,  150,  105,  150
   db  67,  67,  112,  67,  112,  112
   db  67,  67,  112,  112,  67,  112
   db  29,  29,  74,  29,  74,  74
   db  29,  29,  74,  74,  29,  74
   db  119,  119,  164,  119,  164,  164
   db  119,  119,  164,  164,  119,  164
   db  81,  81,  126,  81,  126,  126
   db  81,  81,  126,  126,  81,  126
   db  43,  43,  88,  43,  88,  88
   db  43,  43,  88,  88,  43,  88
   db  5,  5,  50,  5,  50,  50
   db  5,  5,  50,  50,  5,  50
   db  95,  95,  140,  95,  140,  140
   db  95,  95,  140,  140,  95,  140
   db  57,  57,  102,  57,  102,  102
   db  57,  57,  102,  102,  57,  102
   db  19,  19,  64,  19,  64,  64
   db  19,  19,  64,  64,  19,  64
   db  109,  109,  154,  109,  154,  154
   db  109,  109,  154,  154,  109,  154
   db  71,  71,  116,  71,  116,  116
   db  71,  71,  116,  116,  71,  116
   db  33,  33,  78,  33,  78,  78
   db  33,  33,  78,  78,  33,  78
   db  123,  123,  168,  123,  168,  168
   db  123,  123,  168,  168,  123,  168
   db  85,  85,  130,  85,  130,  130
   db  85,  85,  130,  130,  85,  130
   db  47,  47,  92,  47,  92,  92
   db  47,  47,  92,  92,  47,  92
   db  9,  9,  54,  9,  54,  54
   db  9,  9,  54,  54,  9,  54
   db  99,  99,  144,  99,  144,  144
   db  99,  99,  144,  144,  99,  144
   db  61,  61,  106,  61,  106,  106
   db  61,  61,  106,  106,  61,  106
   db  23,  23,  68,  23,  68,  68
   db  23,  23,  68,  68,  23,  68
   db  113,  113,  158,  113,  158,  158
   db  113,  113,  158,  158,  113,  158
   db  75,  75,  120,  75,  120,  120
   db  75,  75,  120,  120,  75,  120
   db  37,  37,  82,  37,  82,  82
   db  37,  37,  82,  82,  37,  82
   db  127,  127,  172,  127,  172,  172
   db  127,  127,  172,  172,  127,  172
   db  89,  89,  134,  89,  134,  134
   db  89,  89,  134,  134,  89,  134
   db  51,  51,  96,  51,  96,  96
   db  51,  51,  96,  96,  51,  96
   db  13,  13,  58,  13,  58,  58
   db  13,  13,  58,  58,  13,  58
   db  103,  103,  148,  103,  148,  148
   db  103,  103,  148,  148,  103,  148
   db  65,  65,  110,  65,  110,  110
   db  65,  65,  110,  110,  65,  110
   db  27,  27,  72,  27,  72,  72
   db  27,  27,  72,  72,  27,  72
   db  117,  117,  162,  117,  162,  162
   db  117,  117,  162,  162,  117,  162
   db  79,  79,  124,  79,  124,  124
   db  79,  79,  124,  124,  79,  124
   db  41,  41,  86,  41,  86,  86
   db  41,  41,  86,  86,  41,  86
   db  3,  3,  48,  3,  48,  48
   db  3,  3,  48,  48,  3,  48
   db  93,  93,  138,  93,  138,  138
   db  93,  93,  138,  138,  93,  138
   db  55,  55,  100,  55,  100,  100
   db  55,  55,  100,  100,  55,  100
   db  17,  17,  62,  17,  62,  62
   db  17,  17,  62,  62,  17,  62
   db  107,  107,  152,  107,  152,  152
   db  107,  107,  152,  152,  107,  152
   db  69,  69,  114,  69,  114,  114
   db  69,  69,  114,  114,  69,  114
   db  31,  31,  76,  31,  76,  76
   db  31,  31,  76,  76,  31,  76
   db  121,  121,  166,  121,  166,  166
   db  121,  121,  166,  166,  121,  166
   db  83,  83,  128,  83,  128,  128
   db  83,  83,  128,  128,  83,  128
   db  45,  45,  90,  45,  90,  90
   db  45,  45,  90,  90,  45,  90
   db  7,  7,  52,  7,  52,  52
   db  7,  7,  52,  52,  7,  52
   db  97,  97,  142,  97,  142,  142
   db  97,  97,  142,  142,  97,  142
   db  59,  59,  104,  59,  104,  104
   db  59,  59,  104,  104,  59,  104
   db  21,  21,  66,  21,  66,  66
   db  21,  21,  66,  66,  21,  66
   db  111,  111,  156,  111,  156,  156
   db  111,  111,  156,  156,  111,  156
   db  73,  73,  118,  73,  118,  118
   db  73,  73,  118,  118,  73,  118

palette LABEL BYTE
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    1
 db     2,    0,    1,    2,    0,    1,    2,    0,    2,    4,    0
 db     2,    4,    0,    2,    6,    0,    3,    6,    0,    3,    6
 db     0,    4,    8,    0,    4,    8,    0,    4,   10,    0,    5
 db    10,    0,    5,   10,    0,    5,   12,    0,    6,   12,    0
 db     6,   12,    0,    6,   14,    0,    7,   14,    2,    7,   16
 db     2,    7,   16,    2,    8,   16,    2,    8,   18,    2,    8
 db    18,    2,    9,   18,    2,    9,   20,    2,    9,   20,    2
 db    10,   20,    2,   10,   22,    2,   11,   22,    2,   11,   22
 db     4,   12,   24,    4,   12,   24,    4,   13,   26,    4,   13
 db    26,    6,   14,   28,    6,   15,   28,    8,   16,   30,    8
 db    17,   32,   10,   19,   34,   12,   20,   34,   12,   22,   36
 db    14,   23,   38,   16,   25,   40,   18,   27,   44,   20,   29
 db    46,   24,   32,   48,   26,   34,   50,   28,   36,   54,   30
 db    39,   56,   34,   41,   58,   36,   44,   62,   38,   46,   62
 db    40,   48,   62,   42,   50,   62,   44,   52,   62,   46,   54
 db    62,   48,   55,   62,   50,   56,   62,   50,   57,   62,   50
 db    57,   62,   52,   58,   62,  159,  159,  159,  162,  162,  162
 db   165,  165,  165,  168,  168,  168,  171,  171,  171,  174,  174
 db   174,  177,  177,  177,  180,  180,  180,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0
 db     0,    0,    0,    0,    0,    0,    0,    0,    0

code32 ends

end
