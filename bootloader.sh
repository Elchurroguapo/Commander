#!/bin/sh
pacman -S efibootmgr dosfstools os-prober mtools
mkdir /boot/EFI
mount /dev/nvme0n1p1 /boot/EFI
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

#Before reboot
pacman -S networkmanager git
systemctl enable NetworkManager
#exit
#umount -R /mnt
#reboot
