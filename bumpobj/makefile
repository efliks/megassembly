TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: bumptor.exe

bumptor.exe: ..\common\stub.obj ..\common\sys.obj ..\common\math3d.obj ..\common\struc3d.obj bump3.obj bumpdata.obj bumptor.obj
	$(TLINK) /3 /x /j..\common stub.obj sys.obj math3d.obj struc3d.obj bump3.obj bumpdata.obj bumptor.obj,bumptor.exe

.asm.obj:
	$(TASM) /m /i..\common $<

clean:
	del *.obj
	del *.exe
