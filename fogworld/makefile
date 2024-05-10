TASM = c:\tasm\bin\tasm.exe
TLINK = c:\tasm\bin\tlink.exe

all: fogworld.exe

fogworld.exe: stub.obj sys.obj allocfnt.obj engine.obj flat3.obj fogworld.obj grd3.obj letgen.obj math3d.obj fogpal.obj s3dgen.obj struc3d.obj world1.obj world2.obj world3.obj 
	$(TLINK) @tlink.txt

.asm.obj:
	$(TASM) /m $<

clean:
	del *.obj *.map *.exe
