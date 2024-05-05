; world1

FLOOR1_CELL equ  184  ; 125
FLOOR1_SIDE equ  10  ; 16
FLOOR1_N_VERTS equ  FLOOR1_SIDE * FLOOR1_SIDE
FLOOR1_N_FACES equ  (FLOOR1_SIDE - 1) * (FLOOR1_SIDE - 1) * 2

global World1_Init:PROC
global World1_GetMem:PROC
global World1_FixFloor:PROC

global World1_Proc:PROC

; used by world2 and fogtro

global Floor1_Strc:DWORD
global Floor1_Obj:DWORD

global World1_Camera:DWORD
global World1_Strc:DWORD
