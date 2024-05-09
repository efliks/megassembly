TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: bump3d.exe

bump3d.exe: stub.obj sys.obj bump3d.obj bumptri.obj data.obj engine.obj math3d.obj struct3d.obj
	$(TLINK) /3 /x stub.obj sys.obj bump3d.obj bumptri.obj data.obj engine.obj math3d.obj struct3d.obj,bump3d.exe

.asm.obj:
	$(TASM) /m $<

clean:
	del *.obj *.map bump3d.exe
