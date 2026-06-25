# DoomOS

A minimal Linux-based OS that boots directly into DOOM. No init system, no display server, not even a userspace. It's just the Linux Kernel running Doom as PID 1.
![C](https://img.shields.io/badge/c-%2300599C.svg?style=for-the-badge&logo=c&logoColor=white)![Bash Script](https://img.shields.io/badge/bash_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://opensource.org/license/gpl-2.0)

## What it is
- Linux kernel boots via GRUB 2
- Starts a minimal initramfs containing only DOOM + busybox
- DOOM renders directly to `/dev/fb0`
- Keyboard input via `/dev/input/eventX`

## Requirements
- WSL2 Ubuntu (or any Ubuntu 22.04+)
- A `doom1.wad` file (shareware, freely available)

## Build
```bash
chmod +x build.sh
./build.sh
```

This produces `doomos.iso`. Flash it to a USB drive with Rufus. When prompted after clicking "Start", ensure it's set to DD mode.

## Controls
- Arrow keys - move / navigate menus
- Ctrl - fire
- Space - use
- Enter - confirm
- Escape - menu

## Repos
- [doomgeneric-fb](https://github.com/P0gDog/doomgeneric-fb) - framebuffer backend fork
- [doom-os](https://github.com/P0gDog/doom-os) - OS build infrastructure

