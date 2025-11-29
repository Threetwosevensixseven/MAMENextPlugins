# debugstart Plugin

MAME debugger has a quirk where you cannot use it unless you enable it at MAME startup with `-debug` or `-d` on the command line. Then the GUI is immediately displayed, and you cannot continue with starting the machine unless you press `F12` key to Run and Hide Debugger, or `F5` key to Run.

**debugstart** plugin will keep the debugger enabled without showing the initial UI, allowing you to later press the Break in Debugger assigned key.

The plugin can be used with all MAME machines, not just the ZX Spectrum Next.

## Installation

To install, download the `debugstart.zip` file from the [latest release](https://github.com/Threetwosevensixseven/MAMENextPlugins/releases/latest), and unzip it into your configured [MAME plugins folder](https://docs.mamedev.org/plugins/index.html#using-plugins) folder, so that the MAME plugins folder contains a `debugstart` folder with the `.lua` and `.json` files inside it.

You may either enable plugins by as described [here](https://docs.mamedev.org/plugins/index.html#using-plugins), or by adding the `-plugins` argument to your MAME command line (useful in build scripts).

You also need to add the [`-d`](https://docs.mamedev.org/commandline/commandline-all.html#debugging-options) argument to your MAME command line, to enable the debugger so it can be used later.

You also need to add `-plugin debugstart` to your command line arguments, to enable nextfaststart to run. If you want to see messages when the plugin is doing something, you can add `-plugin console,debugstart` instead, which will open a console window containing realtime log entries when MAME is launched.

## Usage

### Starting MAME

If you run MAME like this now (with the console plugin as well), you should see that the Next machine starts up without showing the debugger UI, and you should see something like this in the console:

```
       /|  /|    /|     /|  /|    _______
      / | / |   / |    / | / |   /      /
     /  |/  |  /  |   /  |/  |  /  ____/
    /       | /   |  /       | /  /_
   /        |/    | /        |/  __/
  /  /|  /|    /| |/  /|  /|    /____
 /  / | / |   / |    / | / |        /
/ _/  |/  /  /  |___/  |/  /_______/
         /  /
        / _/

mame 0.282
Copyright (C) Nicola Salmoria and the MAME team

Lua 5.4
Copyright (C) Lua.org, PUC-Rio

debugstart: Started plugin
[MAME]> debugstart: Hiding debugger but keeping it enabled


MAME debugger version 0.282 (mame0238-15324-g0d8caa2ab84)
Currently targeting tbblue (ZX Spectrum Next: TBBlue)
```

Now press the [Break in Debugger](https://docs.mamedev.org/usingmame/defaultkeys.html#mame-user-interface-controls) assigned key, and you should see the debugger UI window(s) appear.

### When Not Debugging

When the `-d` or -`debug` arguments are omitted from the command line, the plugin shows this at startup:

```
debugstart: Started plugin
[MAME]> debugstart: Debugger not enabled, start MAME with -d
```

The [Break in Debugger](https://docs.mamedev.org/usingmame/defaultkeys.html#mame-user-interface-controls) assigned key will have no effect when you press it.

### Tips
Another way of controlling the debugger at startup is by making a `debug.txt` file with `g` as the only line. Then launch MAME with this on the command line: 

```
-debugscript debug.txt
```

This has a slightly different effect from the debugstart plugin. Instead of hiding the debug window and continuing (similar to the Run and Hide Debugger command in the debugger UI), this keeps the debug window open and continues (similar to the Run command in the debugger UI).

When you use this technique you don't need to use the debugstart plugin.

## Licence and Acknowledgements

All plugins except are copyright © 2025 Robin Verhagen-Guest, and are licensed under [MIT](https://github.com/Threetwosevensixseven/MAMENextPlugins/blob/main/LICENSE).

The MAME project as a whole is distributed under the terms of the GNU General Public License, version 2 or later (GPL-2.0+), since it contains code made available under multiple GPL-compatible licenses. See full licence details [here](https://docs.mamedev.org/license.html).

Big thanks to holub, jjjs, Ped7g, MattN and others for debugging assistance and general moral support while writing these plugins.