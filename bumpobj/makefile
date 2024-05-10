TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: bumptor.exe

bumptor.exe: stub.obj sys.obj bumptor.obj bump3.obj bumpdata.obj math3d.obj struc3d.obj
	$(TLINK) /3 /x stub.obj sys.obj bumptor.obj bump3.obj bumpdata.obj math3d.obj struc3d.obj,bumptor.exe

.asm.obj:
	$(TASM) /m $<

clean:
	del *.obj *.map bumptor.exe
