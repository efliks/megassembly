TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: mgssmbly.exe

mgssmbly.exe: stub.obj sys.obj allocfnt.obj engine.obj flattri.obj fogtro.obj grdtri.obj letgen.obj math3d.obj palette.obj s3dgen.obj struct3d.obj world1.obj world2.obj world3.obj 
	$(TLINK) @tlink.txt

.asm.obj:
	$(TASM) /m $<

clean:
	del *.obj *.map *.exe
