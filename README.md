# MAME Next Plugins

Various plugins for [MAME](https://www.mamedev.org/), an emulator for the [ZX Spectrum Next](https://www.specnext.com/about/)™ and many other machines.

## nextfaststart Plugin

nextfaststart plugin is a simple helper to minimize boot time on the [ZX Spectrum Next (tbblue)](https://wiki.specnext.dev/MAME:Installing) machine in the MAME emulator.

The plugin does not have any effect on other MAME emulated machines, even if they are Spectrums or contain Z80 XCPUs with `OUT` instructions.

See the [nextfaststart wiki page](https://github.com/Threetwosevensixseven/MAMENextPlugins/wiki/nextfaststart-Plugin) for installation and usage instructions.

## debugstart Plugin

MAME debugger has a quirk where you cannot use it unless you enable it at MAME startup with `-debug` or `-d` on the command line. Then the GUI is immediately displayed, and you cannot continue with starting the machine unless you press `F12` key to Run and Hide Debugger, or `F5` key to Run.

debugstart plugin will keep the debugger enabled without showing the initial UI, allowing you to later press the Break in Debugger assigned key.

The plugin can be used with all MAME machines, not just the ZX Spectrum Next.

See the [debugstart wiki page](https://github.com/Threetwosevensixseven/MAMENextPlugins/wiki/debugstart-Plugin) for installation and usage instructions.

## Licence and Acknowledgements

All plugins except are copyright © 2025 Robin Verhagen-Guest, and are licensed under [MIT](https://github.com/Threetwosevensixseven/MAMENextPlugins/blob/main/LICENSE).

The MAME project as a whole is distributed under the terms of the GNU General Public License, version 2 or later (GPL-2.0+), since it contains code made available under multiple GPL-compatible licenses. See full licence details [here](https://docs.mamedev.org/license.html).

Big thanks to holub, jjjs, Ped7g, MattN and others for debugging assistance and general moral support while writing these plugins.
