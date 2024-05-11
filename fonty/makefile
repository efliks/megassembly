TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: fonty.exe

fonty.exe: ..\common\stub.obj ..\common\sys.obj ..\common\math3d.obj ..\common\grd3.obj ..\common\struc3d.obj ..\common\letgen.obj fonty.obj
	$(TLINK) /3 /x /j..\common stub.obj sys.obj fonty.obj math3d.obj grd3.obj struc3d.obj letgen.obj,fonty.exe

.asm.obj:
	$(TASM) /m /i..\common $<

clean:
	del *.obj
	del *.exe
