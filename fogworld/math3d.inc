; math3d

point2d struc
   x2d dw ?
   y2d dw ?
ends

point3d struc
   x3d dd ?
   y3d dd ?
   z3d dd ?
ends

vector3d struc
   vec_x dd ?
   vec_y dd ?
   vec_z dd ?
ends

matrix struc
    m_00   dd  ?
    m_01   dd  ?
    m_02   dd  ?
    m_10   dd  ?
    m_11   dd  ?
    m_12   dd  ?
    m_20   dd  ?
    m_21   dd  ?
    m_22   dd  ?
ends

global make_vector:PROC
global normalize_vector:PROC
global get_vector_lenght:PROC

global cross_product:PROC
global dot_product:PROC
