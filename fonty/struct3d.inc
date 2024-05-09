; struct3d

struct3d struc
    s3d_n_points dd ?  ; number of points
    s3d_n_faces dd ?  ; number of faces
    s3d_vis_faces dd ?  ; number of visible faces

    s3d_points dd ?  ; base points
    s3d_r_points dd ?  ; rotated points
    s3d_t_points dd ?  ; 2d points

    s3d_faces dd ?  ; faces
    s3d_depths dd ?  ; depths of faces
    s3d_order dd ?  ; order table

    s3d_point_nrm dd ?  ; point normals
    s3d_r_point_nrm dd ?  ; rotated point normals
    
    s3d_AngleX dd ?
    s3d_AngleY dd ?
    s3d_AngleZ dd ?

    s3d_DeltaX dd ?
    s3d_DeltaY dd ?
    s3d_DeltaZ dd ?

    s3d_MovingTime dd ?
    s3d_CurrTime dd ?

    s3d_Movement dd ?

    s3d_tex_coords dd ?  ; texture coordinates

    s3d_bmap dd ?  ; bumpmap / texture
    s3d_emap dd ?  ; environment map
ends

face struc
    face_v1 dw ?
    face_v2 dw ?
    face_v3 dw ?
ends

S3D_N_VERTS equ 0
S3D_NUM_FACES equ 4
S3D_VISABLE_FACES equ 8

S3D_PTR_B_VERTS equ 12
S3D_PTR_R_VERTS equ 16
S3D_PTR_T_VERTS equ 20

S3D_PTR_FACES equ 24
S3D_PTR_DEPTH equ 28
S3D_PTR_ORDER equ 32

S3D_PTR_FACE_PARAMS equ 36

STRUCT3D_SIZE equ (size struct3d)


global init_point_normals:PROC

global GetStruct3dRadius:PROC

global NormalizeStruct3d:PROC
global ScaleStruct3d:PROC
global CenterStruct3d:PROC

global CenterStruct3d_Fog:PROC

global sort_faces:PROC
global quick_sort:PROC

global rotate_translate_struct3d:PROC
