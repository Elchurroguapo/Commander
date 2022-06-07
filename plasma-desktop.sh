#!/bin/bash

sudo timedatectl set-ntp true
sudo hwclock --systohc

sudo reflector -c US -a 6 --sort rate --save /etc/pacman.d/mirrorlist

sudo firewall-cmd --add-port=1025-65535/tcp --permanent
sudo firewall-cmd --add-port=1025-65535/udp --permanent
sudo firewall-cmd --reload
sudo virsh net-autostart default

sudo pacman -Syyu --noconfirm wget curl xorg-server xorg-apps xorg-xinit xorg-twm xorg-xclock xterm sddm plasma packagekit-qt5 firefox simplescreenrecorder obs-studio vlc papirus-icon-theme kdenlive materia-kde
cd /home/netrunner/Desktop
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -csi
yay -Syyu timeshift ungoogled-chromium tor-browser bitwarden grub-btrfs btrfs-assistant rpi-imager balena-etcher mullvad-vpn qbittorrent-qt5 flatpak htop neofetch fish alacritty konsole kate bless ledger-live ttf-ms-fonts gnuradio-companion ark p7zip dolphin yubico-authenticator libfido2 yubico-personalization-gui libreoffice-fresh fish zsh pacfinder nmap whois timeshift-autosnap ttf-ms-fonts

/bin/echo -e "\e[1;32mREBOOTING IN 5..4..3..2..1..\e[0m"
sleep 5
reboot
