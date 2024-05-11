TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: sinescrl.exe

sinescrl.exe: ..\common\stub.obj ..\common\sys.obj sinescrl.obj
	$(TLINK) /3 /x /j..\common stub.obj sys.obj sinescrl.obj,sinescrl.exe

.asm.obj:
	$(TASM) /m /i..\common $<

clean:
	del *.obj
	del *.exe
