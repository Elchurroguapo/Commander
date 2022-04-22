#!/bin/sh
#Formatting GPT Primaries
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme1n1p1
swapon /dev/nvme1n1p1
mkfs.ext4 /dev/nvme0n1p2
mkfs.ext4 /dev/nvme1n1p2
#Mounting GPT Primaries
mount /dev/nvme0n1p2 /mnt
mkdir /mnt/boot
mkdir /mnt/home
mount /dev/nvme0n1p1 /mnt/boot
mount /dev/nvme1n1p2 /mnt/home
lsblk
#Verify locale
timedatectl set-ntp true
#Install base
pacstrap /mnt base
#Install export fstab and chroot
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt

#Setting Locale
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
hwclock --systohc

#Installing Editors for Locale.conf
pacman -Sy
pacman -S nano bash-completion
nano /etc/locale.gen
#Uncomment en_US.UTF-8
locale-gen

#Setting up Network
nano /etc/hostname
##append cyberpsycho
nano /etc/hosts
##127.0.0.1  localhost
##::1  localhost
##127.0.1.1  cyberpsycho.localdomain cyberpsycho

#Setting up admin user account
passwd
useradd -m netrunner
passwd netrunner
usermod -aG wheel,audio,video,optical,storage,power -s /bin/bash netrunner
EDITOR=nano visudo
##Uncomment %wheel
##Append Defaults rootpw

#Enabling Multilib and Installing Microcode Patch
pacman -Sy
nano /etc/pacman.conf
##uncomment Multilib
#pacman -Sy
##pacman -S amd-ucode
