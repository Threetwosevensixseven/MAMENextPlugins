# Makefile for L2TimingTest.
# Only tested with GNU MAKE 3.81 for Windows.
# If you fix this up for linux or mac, please contribute your changes

# Change these variables to suit your own environment
BINDIR = ..\..\bin
SJASMPLUS = ..\..\tools\sjasmplus
HDFMONKEY = ..\..\tools\hdfmonkey
EMUDIR = C:\spec\CSpect3_0_15_2
MAMEDIR = C:\spec\mame
ZESDIR = C:\spec\ZEsarUX_windows-12.1
EMUSD = C:\spec\sd209\cspect-next-2gb.img
ZESSD = C:\spec\ZEsarUX_windows-12.1\tbblue.mmc
SYNCDIR = C:\spec\sync\ON
RM = del /F /Q
MD = md
KILL = taskkill /F /IM
PY = python3.13.exe
TOUCH = ..\..\tools\busybox.exe touch -c

mame: mamekill
#	CMD /C start /d $(MAMEDIR) mame tbblue -window -mouse_device none -skip_gameinfo -natural -ui_active -nounevenstretch -aspect 2:1 -intscalex 2 -video bgfx -bgfx_screen_chains unfiltered -window -hard $(EMUSD)
	CMD /C start /d $(MAMEDIR) mame tbblue -d -plugin console,nextfaststart,debugstart -window -mouse_device none -skip_gameinfo -ui_active -nounevenstretch -aspect 2:1 -intscalex 2 -video bgfx -bgfx_screen_chains unfiltered -window -hard $(EMUSD)
#C:\spec\mame\mame.exe tbblue -window -mouse_device none -skip_gameinfo -ui_active -nounevenstretch -aspect 2:1 -video bgfx -bgfx_screen_chains unfiltered -window -hard C:\spec\sd209\cspect-next-2gb.img
#	nextfaststart,debugstart,nextbreak 

mamekill:
	-$(KILL) mame.exe 

