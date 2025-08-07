# Automates the partitioning process
AUTOMATE="mktable gpt \n
mkpart primary fat32 2048s 131071s \n
mkpart primary fat32 131072s 100% \n
align-check optimal 1 \n
align-check optimal 2 \n
name 1 UEFI \n
name 2 SYSTEM \n
quit"

# Creates the disk.img file
dd if=/dev/zero of=build/disk.img bs=1M count=256
# Partitions the file
echo -e $AUTOMATE | sudo parted build/disk.img

# Creates the uefi.img file
dd if=/dev/zero of=build/uefi.img bs=1M count=33
# Formats the disk image as FAT32
mkfs.vfat build/uefi.img -F 32
# Creates the subdirectories.
mmd -i build/uefi.img ::/EFI
mmd -i build/uefi.img ::/EFI/BOOT