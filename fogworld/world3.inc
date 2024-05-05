; world3

FLOOR3_CELL equ  184
FLOOR3_SIDE equ  10
FLOOR3_N_VERTS equ  FLOOR3_SIDE * FLOOR3_SIDE
FLOOR3_N_FACES equ  (FLOOR3_SIDE - 1) * (FLOOR3_SIDE - 1) * 2

global World3_Init:PROC
global World3_GetMem:PROC

global World3_Proc:PROC
