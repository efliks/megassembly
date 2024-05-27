TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: fogworld.exe

fogworld.exe: ..\common\stub.obj ..\common\sys.obj ..\common\grd3.obj ..\common\letgen.obj ..\common\math3d.obj ..\common\struc3d.obj engine.obj flat3.obj fogpal.obj fogworld.obj s3dgen.obj world1.obj world2.obj world3.obj 
	$(TLINK) @tlink.txt

.asm.obj:
	$(TASM) /m /i..\common $<

clean:
	del *.obj
	del *.exe
