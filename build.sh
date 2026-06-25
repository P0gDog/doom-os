#!/bin/bash
set -e

echo "[1/6] Installing dependencies..."
sudo apt install -y gcc build-essential linux-libc-dev grub-pc-bin grub-efi-amd64-bin xorriso mtools busybox-static wget

echo "[2/6] Cloning doomgeneric-fb..."
git clone https://github.com/P0gDog/doomgeneric-fb doomgeneric
cp -f doomgeneric-fb/doomgeneric_fb.c doomgeneric/doomgeneric_fb.c

echo "[3/6] Building DOOM..."
cd doomgeneric
sed -i 's/doomgeneric_xlib\.o/doomgeneric_fb.o/' Makefile
sed -i 's/^CC=clang.*/CC=gcc/' Makefile
sed -i 's/^LIBS+=.*/LIBS+=-lm/' Makefile
sed -i 's/^CFLAGS+=.*-Wall.*/CFLAGS+=-Wall -DNORMALUNIX -DLINUX -DSNDSERV -D_DEFAULT_SOURCE/' Makefile
echo 'CFLAGS+=-static -O2' >> Makefile
echo 'LDFLAGS+=-static' >> Makefile
make clean && make
cd ..

echo "[4/6] Downloading kernel..."
wget -q https://kernel.ubuntu.com/mainline/v6.6.30/amd64/linux-image-unsigned-6.6.30-060630-generic_6.6.30-060630.202405021537_amd64.deb
dpkg-deb -x linux-image-unsigned-6.6.30-060630-generic_6.6.30-060630.202405021537_amd64.deb kernel-extract

echo "[5/6] Building initramfs..."
echo "NOTE: Place doom1.wad in this directory before continuing."
read -p "Press Enter when doom1.wad is ready..."
mkdir -p initramfs/bin initramfs/dev initramfs/proc
cp doomgeneric/doomgeneric/doomgeneric initramfs/bin/doom
cp doom1.wad initramfs/bin/doom1.wad
cp /bin/busybox initramfs/bin/busybox
ln -sf /bin/busybox initramfs/bin/sh
ln -sf /bin/busybox initramfs/bin/mount
cp doom-os/initramfs/init initramfs/init
chmod +x initramfs/init
cd initramfs
find . -print0 | cpio --null -oH newc | gzip -9 > ../initramfs.cpio.gz
cd ..

echo "[6/6] Building ISO..."
mkdir -p iso/boot/grub
cp kernel-extract/boot/vmlinuz-6.6.30-060630-generic iso/boot/vmlinuz
cp initramfs.cpio.gz iso/boot/initramfs.cpio.gz
cp doom-os/iso/boot/grub/grub.cfg iso/boot/grub/grub.cfg
grub-mkrescue -o doomos.iso iso/

echo "Done! doomos.iso is ready."
