# MAMENextPlugins

Various plugins for [MAME](https://www.mamedev.org/), an emulator for the [ZX Spectrum Next](https://www.specnext.com/about/)™ and many other machines.

## 1) nextfaststart Plugin

nextfaststart plugin is a simple helper to minimize boot time on the [ZX Spectrum Next (tbblue)](https://wiki.specnext.dev/MAME:Installing) machine in the MAME emulator.

The plugin does not have any effect on other MAME emulated machines, even if they are Spectrums or contain Z80 XCPUs with `OUT` instructions.

### Installation

To install, download the `nextfaststart.zip` file from the [latest release](https://github.com/Threetwosevensixseven/MAMENextPlugins/releases/latest), and unzip it into your configured [MAME plugins folder](https://docs.mamedev.org/plugins/index.html#using-plugins) folder, so that the MAME plugins folder contains a `nextfaststart` folder with the `.lua` and `.json` files inside it.

You may either enable plugins by as described [here](https://docs.mamedev.org/plugins/index.html#using-plugins), or by adding the `-plugins` argument to your MAME command line (useful in build scripts).

You also need to add `-plugin nextfaststart` to your command line arguments, to enable nextfaststart to run. If you want to see when the plugin is switching between Normal Speed and Fast Speed, you can add `-plugin console,nextfaststart` instead, which will open a console window containing realtime log entries when MAME is launched.

### Usage

#### Starting MAME
If you run MAME like this now (with the console plugin as well), you should see that the Next machine was greatly reduced (yay!), and should see something like this in the console:

 something like this:

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

nextfaststart: Started plugin
[MAME]> nextfaststart: Started Next machine at  Max Speed
nextfaststart: Reset at Max Speed
```

If you press the F11 key in MAME, you will see something like `skip 10/10 2000%` which indicates that MAME is currently running at max speed (equivalent to the [`-nothrottle`](https://docs.mamedev.org/commandline/commandline-all.html#mame-commandline-nothrottle) command line argument) and with max frame skips (equivalent to the [`-frameskip 10`](https://docs.mamedev.org/commandline/commandline-all.html#mame-commandline-frameskip) arg).

### Sending Speed Commands
#### Normal Speed Command
However, this is way too fast to actually type in NextBASIC, or to test that asm/C/Boriel/forth/whatever program you were using MAME to debug. So we need a way to slow it back down at the right point, ready for usage.

Add this to your NextBASIC `autoexec.bas`:

```
  10 OUT %$2f3b, 0
9998 ERASE
9999 CLEAR:SAVE "c:/NextZXOS/autoexec.bas" LINE 0
```
You may also add other NextBasic statements or dot commands to launch your project file, for example

```
  20 CD "c:/My Development Files"
  30 .nexload MyGame.nex
```

`$2f3b` (`12091` in decimal) is a Z80 I/O port which is not used by the Next, and is unlikely to be currently used by other Spectrum hardware (meaning you could get away with accidentally leaving it in your code, at a pinch).

Sending `0` to this port will slow down the plugin back to Normal Speed (the original values of `-frameskip` and `-[no]throttle` you had configured before installing the plugin).

Instead of adding the `OUT` to `autoexec.bas`, you can also add it at the start of your project file, for example in Z80 asm:

```
 ld bc, $2f3b
 ld a, 0 ; xor a is slightly shorter
 out (c), a
```

If you run with this `OUT` being executed, your console output should look like this:

```
nextfaststart: Started plugin
[MAME]> nextfaststart: Started Next machine at  Max Speed
nextfaststart: Reset at Max Speed
nextfaststart: Normal Speed command received
```

Doing the Normal Speed `OUT` inside your project file is likely to result in slightly more speedup than doing it in NextBASIC, as the loading of the project file will also be speeded up to Max Speed.

#### Max Speed Command
Writing `1` to I/O port `$2f3b` will put the MAME ZX Spectrum Next machine back to max speed, similar to how it starts up. So in NextBASIC:

```
OUT %$2f3b, 1
```

and in Z80 asm:

```
 ld bc, $2f3b
 ld a, 1
 out (c), a
```

You may liberally mix Normal Speed and Max Speed commands throughout your code. For example, maybe you have a program UI sequence to be done at Normal Speed, followed by a long running calculation to be done at Max Speed, followed by another UI sequence to be done at Normal Speed again.

Every time you hard or soft reset the MAME ZX Spectrum Next machine (`F3` key), the plugin will also switch to Max Speed again.

#### Other Commands
If you write any other values to port I/O port `$2f3b`, such as `OUT %$2f3b, 99`, the plugin will ignore them and log this output:

```
nextfaststart: Command 99 ignored
```

It is likely that other ZX Spectrum Next plugins will use other command numbers on this port, and will similarly ignore commands `0` and `1`.

## 2) debugstart Plugin

MAME debugger has a quirk where you cannot use it unless you enable it at MAME startup with `-debug` or `-d` on the command line. Then the GUI is immediately displayed, and you cannot continue with starting the machine unless you press `F12` key to Run and Hide Debugger, or `F5` key to Run.

debugstart plugin will keep the debugger enabled without showing the initial UI, allowing you to later press the Break in Debugger assigned key.

The plugin can be used with all MAME machines, not just the ZX Spectrum Next.

### Installation

To install, download the `debugstart.zip` file from the [latest release](https://github.com/Threetwosevensixseven/MAMENextPlugins/releases/latest), and unzip it into your configured [MAME plugins folder](https://docs.mamedev.org/plugins/index.html#using-plugins) folder, so that the MAME plugins folder contains a `debugstart` folder with the `.lua` and `.json` files inside it.

You may either enable plugins by as described [here](https://docs.mamedev.org/plugins/index.html#using-plugins), or by adding the `-plugins` argument to your MAME command line (useful in build scripts).

You also need to add the [`-d`](https://docs.mamedev.org/commandline/commandline-all.html#debugging-options) argument to your MAME command line, to enable the debugger so it can be used later.

You also need to add `-plugin debugstart` to your command line arguments, to enable nextfaststart to run. If you want to see messages when the plugin is doing something, you can add `-plugin console,debugstart` instead, which will open a console window containing realtime log entries when MAME is launched.

### Usage

#### Starting MAME

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

### Licence and Acknowledgements

All plugins except are copyright © 2025 Robin Verhagen-Guest, and are licensed under [MIT](https://github.com/Threetwosevensixseven/MAMENextPlugins/blob/main/LICENSE).

The MAME project as a whole is distributed under the terms of the GNU General Public License, version 2 or later (GPL-2.0+), since it contains code made available under multiple GPL-compatible licenses. See full licence details [here](https://docs.mamedev.org/license.html).

Big thanks to holub, jjjs, Ped7g, MattN and others for debugging assistance and general moral support while writing these plugins.

Other MAME speedup plugins for different usage scenarios are available, for example [skipstartupframes](https://github.com/Jakobud/skipstartupframes).
