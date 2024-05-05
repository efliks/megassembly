; engine

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
ends

face struc
    face_v1 dw ?
    face_v2 dw ?
    face_v3 dw ?
ends

; struct3d
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

STRUCT3D_SIZE equ 44

; camera
CAM_POS equ 0
CAM_TARGET equ 12
CAM_ROLL equ 24
CAM_MATRIX equ 28
CAM_PTR_TRACK equ 28 + 9 * 4
CAM_TRACK_LEN equ CAM_PTR_TRACK + 4
CAM_TRACK_POS equ CAM_TRACK_LEN + 4
CAM_FLAGS equ CAM_TRACK_POS + 4

CAMERA_SIZE equ CAM_FLAGS + 4

CF_NO_TARGET equ 1
CF_WITH_TARGET equ 2

; object3d
O_PTR_STRUCT3D equ 0
O_MATRIX equ O_PTR_STRUCT3D + 4
O_ANGLE_X equ O_MATRIX + 9 * 4
O_ANGLE_Y equ O_ANGLE_X + 4
O_ANGLE_Z equ O_ANGLE_Y + 4
O_ADD_ANGLE_X equ O_ANGLE_Z + 4
O_ADD_ANGLE_Y equ O_ADD_ANGLE_X + 4
O_ADD_ANGLE_Z equ O_ADD_ANGLE_Y + 4
O_POS equ O_ADD_ANGLE_Z + 4
O_FLAGS equ O_POS + 12

OBJECT3D_SIZE equ O_FLAGS + 4

OF_STATIC equ 1
OF_MOVEABLE equ 2

; world
W_PTR_STRUCT3D equ 0
W_PTR_CAMERA equ 4
W_NUM_OF_OBJECTS equ 8
W_PTR_OBJECTS equ 12
W_FLAGS equ 16

WORLD_SIZE equ 20

WF_DRAW_FLAT equ 1
WF_DRAW_GOURAUD equ 2

; track (used in older engine, currently without any sense ;)
T_NUM_OF_VERTS equ 0
T_PTR_VERTS equ 4
T_CURR_POSITION equ 8

TRACK_SIZE equ 12

T_STD_NUM_OF_VERTS equ MAX_DEGS

; face params
FP_PTR_TEXTURE equ 0
FP_X1 equ 4
FP_Y1 equ 5
FP_X2 equ 6
FP_Y2 equ 7
FP_X3 equ 8
FP_Y3 equ 9

FACE_PARAMS_SIZE equ 10

MOVE_PAL_COLOR equ 12
MIN_COLOR equ 1

MAX_DEGS equ 512


global MakeVector:PROC
global GetVectorLenght:PROC
global NormalizeVector:PROC
global CrossProduct:PROC
global DotProduct:PROC

global MakeRotationMatrix:PROC
global MakeCameraMatrix:PROC

global TransformVector:PROC
global TranslateVertices:PROC

global ObjectProc:PROC

global RenderWorld:PROC

global NormalizeStruct3d:PROC
global ScaleStruct3d:PROC
global CenterStruct3d:PROC

global GetStruct3dRadius:PROC
global GetStruct3dSize:PROC

global GetVertexColorDist:PROC
global GetVertexColorZ:PROC

global UpdateCamera:PROC

global SetTrack:PROC
global MakeLinearTrack:PROC

global CurrColorProc:DWORD

; copied from oldeng

global render_struct3d:PROC
global sort_faces:PROC
global init_point_normals:PROC