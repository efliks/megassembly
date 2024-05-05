TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: fonty.exe

fonty.exe: stub.obj sys.obj fonty.obj math3d.obj engine.obj grd3.obj letgen.obj
	$(TLINK) /3 /x stub.obj sys.obj fonty.obj math3d.obj engine.obj grd3.obj letgen.obj,fonty.exe

.asm.obj:
	$(TASM) /m $<

clean:
	del *.obj *.map fonty.exe
