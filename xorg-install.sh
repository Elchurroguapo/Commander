#!/bin/bash
sudo pacman -Syy
sudo pacman -S xf86-video-fbdev xf86-video-vesa xf86-video-nouveau mesa lib32-mesa
sudo pacman -Syu
sudo pacman -S xorg-server xorg-apps xorg-xinit nitrogen firefox git
sudo pacman -S git
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -csi
