#!/bin/sh
sudo pacman -Sy
sudo pacman -S base-devel linux-lts linux-lts-headers linux-firmware
nano /etc/default/grub
#Add options amd_iommu=on iommu=pt
