#!/bin/bash

sudo timedatectl set-ntp true
sudo hwclock --systohc

sudo reflector -c US -a 6 --sort rate --save /etc/pacman.d/mirrorlist

sudo firewall-cmd --add-port=1025-65535/tcp --permanent
sudo firewall-cmd --add-port=1025-65535/udp --permanent
sudo firewall-cmd --reload
# sudo virsh net-autostart default

#git clone https://aur.archlinux.org/yay.git
#cd yay/
#makepkg -csi
#yay -S auto-cpufreq
#sudo systemctl enable --now auto-cpufreq


sudo pacman -S --noconfirm wget curl xorg-server xorg-apps xorg-xinit xorg-twm xorg-xclock xterm sddm plasma kde-applications packagekit-qt5 firefox simplescreenrecorder obs-studio vlc papirus-icon-theme kdenlive materia-kde

sudo systemctl enable sddm
/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
