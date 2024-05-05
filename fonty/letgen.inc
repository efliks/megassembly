; letgen

N_POINTS equ 8 * 64
N_FACES equ 12 * 64
BUFFER3D_SIZE equ N_POINTS * (size point3d) + N_FACES * (size face)

global MakeLetter3d:PROC
