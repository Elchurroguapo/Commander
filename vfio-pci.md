#!/bin/sh
# Kernel Patch
echo "options amd_iommu=on iommu=pt" >> /boot/loader/entries/arch.conf

# Initramfs embedding
sudo nano /etc/mkinitcpio.conf \
 MODULES=(vfio_pci vfio vfio_iommu_type1 ...)
sudo mkinitcpio -P
sudo reboot

# Checking sane IOMMU groupings
sudo dmesg | grep -i -e DMAR -e IOMMU
 
 {#!/bin/bash
shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done;
done;}

# Check kernel drivers and modules used
lspci -nnk -d

# Installing virsh
sudo pacman -S qemu ebtables libvirt edk2-ovmf virt-manager dnsmasq bless tree
sudo systemctl enable libvirtd.service --now
sudo systemctl enable virtlogd.socket --now
sudo usermod -aG kvm qemu libvirt libvirt-qemu $whoami
sudo virsh net-autostart default
sudo virsh net-start default

# Install Base VM OS
1. New VM
2. Browse local
3. 160000 Memory
4. 14 Cores
5. 1 Socket
6. 7 Real Cores
7. 2 Threads
8. Enable SATA Disk at Boot
9. Begin installation

sudo reboot

# Installing hooks
sudo mkdir /etc/libvirt/hooks
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' \
     -O /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu
sudo su
sudo mkdir /etc/libvirt/hooks/qemu.d/{VM NAME}/prepare/begin
sudo mkdir /etc/libvirt/hooks/qemu.d/{VM NAME}/release/end
sudo nano /etc/libvirt/hooks/qemu.d/{VM NAME}/prepare/begin/start.sh
sudo chmod +x /etc/libvirt/hooks/qemu.d/{VM NAME}/prepare/begin/start.sh
sudo chmod +x /etc/libvirt/hooks/qemu.d/{VM NAME}/release/end/revert.sh

# Copy VGA BIOS
sudo mkdir /usr/share/vgabios
sudo mv /home/netrunner/Desktop/patch.rom /usr/share/vgabios

# XML Edits (Remember to change default preferences in menu)
<vendor_id state="on" value="1234567889123"/>
{/hyperv}
##Passthrough both pci GPU hosts, both keyboard and mouse, and disable SATA IDE disk.
<rom file='/usr/share/vgabios/patch.rom'/>

# Optionals
sudo loginctl enable-linger netrunner
sudo chown netrunner:wheel (to hooks, rom files, etc)
