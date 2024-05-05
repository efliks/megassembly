TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: sinescrl.exe

sinescrl.exe: stub.obj sys.obj sinescrl.obj
	$(TLINK) /3 /x stub.obj sys.obj sinescrl.obj,sinescrl.exe

.asm.obj:
	$(TASM) /m $<

clean:
	del *.obj *.map sinescrl.exe
