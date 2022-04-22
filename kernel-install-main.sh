#!/bin/sh
pacman -S base-devel linux linux-headers linux-firmware
mkinitcpio -P
grub-mkconfig -o /boot/grub/grub.cfg
reboot
