; letgen

polygon struc
   poly_v1   dw  ?
   poly_v2   dw  ?
   poly_v3   dw  ?
   poly_v4   dw  ?
ends

tiny_struct3d struc
    ts3d_n_points dd ?  ; number of points
    ts3d_n_faces dd ?  ; number of faces
    ts3d_vis_faces dd ?  ; number of visible faces

    ts3d_points dd ?  ; base points
    ts3d_r_points dd ?  ; rotated points
    ts3d_t_points dd ?  ; 2d points

    ts3d_faces dd ?  ; faces
ends

N_POINTS equ 8 * 64
N_FACES equ 12 * 64
BUFFER3D_SIZE equ N_POINTS * (size point3d) + N_FACES * (size face)

global MakeLetter3d:PROC
global GetLetterParams:PROC

global Buffer3d:tiny_struct3d
