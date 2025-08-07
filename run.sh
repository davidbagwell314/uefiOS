#!/bin/bash

set -e

# very important files
EFI="gnu-efi"
OVMF_CODE="ovmf/OVMF_CODE.fd"
OVMF_VARS="ovmf/OVMF_VARS.fd"
DISK="build/disk.img"

# cleanup the project
rm -f *.o *.efi *.img *.fd *.elf *.so
rm -rf boot/bin/*
rm -rf kernel/bin/*

# compile the bootloader
x86_64-w64-mingw32-gcc -O0 -c -o boot/bin/boot.o boot/src/boot.c -I"$EFI/inc" -I"$EFI/inc/x86_64" -I"$EFI/inc/protocol" -I"global/inc" -I"boot/inc" -ffreestanding
x86_64-w64-mingw32-gcc -O0 -c -o boot/bin/data.o $EFI/lib/data.c -I"$EFI/inc" -I"$EFI/inc/x86_64" -I"$EFI/inc/protocol" -I"global/inc" -I"boot/inc" -ffreestanding

# link the bootloader as an EFI application with 'efi_main' as the entry point
x86_64-w64-mingw32-gcc -nostdlib -Wl,-dll -shared -Wl,--subsystem,10 -e efi_main -o boot/bin/BOOTX64.EFI boot/bin/boot.o boot/bin/data.o

# remove then re-add BOOTX64.EFI to build/uefi.img
mdel -i build/uefi.img ::/EFI/BOOT/BOOTX64.EFI
mcopy -i build/uefi.img boot/bin/BOOTX64.EFI ::/EFI/BOOT

# rebuild build/disk.img
sudo modprobe dm-mod
sudo kpartx -av $DISK
sudo dd if=build/uefi.img of=/dev/mapper/loop29p1 bs=1M
sudo kpartx -dv $DISK

# emulate with QEMU
DISPLAY=:1 qemu-system-x86_64 \
  -drive file=$OVMF_CODE,format=raw,if=pflash \
  -drive file=$OVMF_VARS,format=raw,if=pflash \
  -drive file=$DISK,format=raw \
  -serial stdio \
  -m 1G