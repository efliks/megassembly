TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: naagtro.exe

naagtro.exe: ..\common\stub.obj ..\common\sys.obj naagdata.obj naagtro.obj scroll.obj
	$(TLINK) /3 /x /j..\common stub.obj sys.obj naagdata.obj naagtro.obj scroll.obj,naagtro.exe

.asm.obj:
	$(TASM) /m /i..\common $<

clean:
	del *.obj
	del *.exe
