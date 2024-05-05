TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: plasma32.exe

plasma32.exe: stub.obj sys.obj plasma32.obj
	$(TLINK) /3 /x stub.obj sys.obj plasma32.obj,plasma32.exe

.asm.obj:
	$(TASM) /m $<

clean:
	del *.obj *.map plasma32.exe
