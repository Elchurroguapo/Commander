#Verify EFI Boot
efivar -l

#Check Internet
ping google.com

#Clear Disk
hdparm -i /dev/nvme0n1
gdisk /dev/nvme0n1
x
z
y
y

#Partition Disk
cgdisk /dev/nvme0n1
#(Boot)
  Default
  1024 MiB
  EF00
  BOOT
#(Swap)
  Default
  16 GiB
  8200
  SWAP
#(Root Dir)
  Default
  35 GiB
  Default
  ROOT
#(Home Dir)
  Default
  Default
  Default
  HOME

#Confirm Partitioning
lsblk
/dev/nvme0n1p1 as BOOT
/dev/nvme0n1p2 as SWAP
/dev/nvme0n1p3 as ROOT
/dev/nvme0n1p4 as HOME

#Format Partitions
  mkfs.fat -F32 /dev/nvme0n1p1
  mkswap /dev/nvme0n1p2
  swapon /dev/nvme0n1p2
  mkfs.ext4 /dev/nvme0n1p3
  mkfs.ext4 /dev/nvme0n1p4
  
#Mount Partitions
  mount /dev/nvme0n1p3 /mnt
  mkdir /mnt/boot
  mkdir /mnt/home
  mount /dev/nvme0n1p1 /mnt/boot
  mount /dev/nvme0n1p4 /mnt/home

#Make mirrorlist backup file
  cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup

#Rank the mirrors
  pacman -Sy
  pacman -S pacman-contrib
  rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

#Install Kernel
  pacstrap -i /mnt base base-devel linux linux-headers linux-firmware

#Generate fstab
  genfstab -U -p /mnt >> /mnt/etc/fstab

#Chroot into installed kernel
  arch-chroot /mnt
  
#New installation startup
  pacman -Sy
  pacman -S nano bash-completion

#Generate Locale
  nano /etc/locale.gen [Uncomment "en_US.UTF-8"]
  locale-gen
  echo LANG=en_US.UTF-8 > /etc/locale.conf
  export LANG=en_US.UTF-8

#Set time
  ln -s /usr/share/zoneinfo/US/Eastern > /etc/localtime
  hwclock --systohc
 
#Setup hostname
  echo Commander > /etc/hostname

#Enable multilib (32-bit apps)
  nano /etc/pacman.conf [Uncomment 'multilib' and line below]
  
#Enable SSD Trim Support
  systemctl enable fstrim.timer

#Update Pacman for Multilib
  pacman -Sy
  
#Set passwords and user accounts
  passwd
  useradd -m -g users -G wheel,storage,power -s /bin/bash elchurroguapo
  passwd elchurroguapo
  
#Edit Sudoers
  EDITOR=nano visudo
  [Ctrl+w search, uncomment '%wheel ALL=(ALL) ALL']
  Defaults rootpw [Add to end]

#Check proper EFI Mounting
  mount -t efivarfs efivarfs /sys/firmware/efi/efivars/ [Should be already mounted]
  
#Install Systemd Bootloader
  bootctl install

#Configure Bootloader
  nano /boot/loader/entries/default.conf
    title Arch Linux
    linux /vmlinuz-linux
    initrd /initramfs-linux.img

#Enable CPU Microcode Patches
  pacman -S amd-ucode
  
#Enable Microcode at Boot
  nano /boot/loader/entries/default.conf
    title Arch Linux
    linux /vmlinuz-linux
    initrd /amd-ucode.img
    initrd /initramfs-linux.img

#Ensure correct drive loader for boot
  echo "options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/nvme0n1p3) rw" >> /boot/loader/entries/default.conf

#Configure Network
  pacman -S dhcpcd networkmanager
  ip link [Find network interface for auto boot]
  systemctl enable NetworkManager
  systemctl enable dhcpcd@____.service

#Install Nvidia Drivers
  pacman -S nvidia-dkms libglvnd nvidia-utils opencl-nvidia lib32-libglvnd lib32-nvidia-utils lib32-opencl-nvidia nvidia-settings

#Enable Nvidia modeset at CPIO
  nano /etc/mkinitcpio.conf
  [Default is MODULES=()]
  Edit as MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)

#Enable Nvidia via Bootloader
  nano /boot/loader/entries/default.conf
  [PARTUUID=######## rw nvidia-drm.modeset=1]

#Make pacman hook for upgrade stability
  mkdir /etc/pacman.d/hooks
  nano /etc/pacman.d/hooks/nvidia
    [Trigger]
    Operation=Install
    Operation=Upgrade
    Operation=Remove
    Type=Package
    Target=nvidia
    
    [Action]
    Depends=mkinitcpio
    When=PostTransaction
    Exec=/usr/bin/mkinitcpio -P
    
#Reboot and ensure stability
  sudo reboot
  systemctl --failed
  
#Install Plasma/SDDM GUI
  sudo pacman -S mesa xorg-server xorg-apps xorg-xinit xorg-twm xorg-xclock xterm
  startx
  exit
  sudo pacman -S plasma sddm
  sudo systemctl enable sddm.service
  sudo reboot

#Install apps
  sudo pacman -S konsole firefox p7zip ark dolphin wine yay
  [If yay fails]
  firefox
  search aur.archlinux.org, download snapshot
  cd into install directory
    tar -xzvf yay.tar.gz
    cd yay
    makepkg -csi
    (installs go as depends)
