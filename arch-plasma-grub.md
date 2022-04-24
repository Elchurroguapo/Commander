#Boot into Arch ISO
#Time Protocol
timedatectl set-ntp true
#Reflector install for server syncing
pacman -Sy
pacman -S reflector -c UnitedStates -a 6 --sort rate --save /etc/pacman.d/mirrorlist

#Show Disks
fdisk /dev/nvmeXXX
g
n
1
default
+200M
t
1
n
2
def
def
w

#Format partitions
mkfs.fat -F32 /dev/nvmeXXXX
mkfs.ext4 /dev/nvmeXXXX
mount (ext4)
mkdir /mnt/boot
mount (fat32) /mnt/boot
pacstrap /mnt base linux linux-firmware nano
genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

arch-chroot /mnt
fallocate -l 2GB /swapfile
chmod 600 /swapfile
swapon /swapfile
nano /etc/fstab
  /swapfile none  swap  defaults  0 0
  
ln -sf /usr/share/zoninfo/America/New_York /etc/localtime
hwclock --systohc
nano /etc/locale.gen
(uncomment en_US.UTF-8)
locale-gen
nano /etc/locale.conf
  LANG=en_US.UTF-8
nano /etc/hosts
  127.0.0.1 localhost
  ::1 localhost
  127.0.1.1 (hostname)!.localdomain
  
pacman -S grub efibootmgr networkmanager network-manager-applet wireless_tools wpa_supplicant dialog os-prober base-devel linux-headers reflector git bluez bluez-utils cups xdg-utils xdg-user-dirs
pacman -S openssh

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable networkmaanger , bluetooth , org.cups.cupd
useradd -mG wheel (USER)
EDITOR=nano visudo

umount -a
reboot

ip a
systemctl start sshd
nmti 
select wifi + password

(VM) drivers: xf86-video-qxl
(NVIDIA) nvidia nvidia-utils
sudo pacman -S xorg
pacman -S plasma kde-applications packagekit-qt5

pacman -S libreoffice
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si PKGBUILD
yay -S ttf-ms-fonts
yay -S timeshift
systemctl enable fstrim.timer




