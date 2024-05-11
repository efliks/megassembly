TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: plasma32.exe

plasma32.exe: ..\common\stub.obj ..\common\sys.obj plasma32.obj
	$(TLINK) /3 /x /j..\common stub.obj sys.obj plasma32.obj,plasma32.exe

.asm.obj:
	$(TASM) /m /i..\common $<

clean:
	del *.obj
	del *.exe
