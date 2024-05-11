TASM = c:\tasm\bin\tasm.exe

all: grd3.obj letgen.obj math3d.obj struc3d.obj stub.obj sys.obj

.asm.obj:
	$(TASM) /m $<

clean:
	del *.obj
