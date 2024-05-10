TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: naagtro.exe

naagtro.exe: stub.obj sys.obj naagdata.obj scroll.obj naagtro.obj
	$(TLINK) /3 /x stub.obj sys.obj naagdata.obj scroll.obj naagtro.obj,naagtro.exe

.asm.obj:
	$(TASM) /m $<

clean:
	del *.obj *.map naagtro.exe
