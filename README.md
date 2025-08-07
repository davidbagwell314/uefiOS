# uefiOS

# source code
source code for the bootloader is in boot/src/
source code for the kernel is in kernel/src/

# gnu-efi
gnu-efi can be installed with 'git clone https://git.code.sf.net/p/gnu-efi/code gnu-efi'
all members of 'LibStubUnicodeInterface' in gnu-efi/lib/data.c are set to NULL to remove unnecessary dependencies

# ovmf
ovmf can be installed with 'sudo apt-get install ovmf'
copy files into the project:
    mkdir ovmf
    cp /usr/share/OVMF/OVMF_CODE_4M.fd ovmf/OVMF_CODE.fd
    cp /usr/share/OVMF/OVMF_VARS_4M.fd ovmf/OVMF_VARS.fd

# dependencies
other dependencies can be installed with 'sudo apt-get install qemu-system binutils-mingw-w64 gcc-mingw-w64 xorriso mtools'

# scripts
run.sh compiles the OS and bootloader into build/disk.img, which is then emulated with QEMU
create_image.sh creates and partions build/disk.img as a FAT32-formatted, GPT-partitioned disk image