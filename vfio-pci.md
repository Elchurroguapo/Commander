# Ensure UEFI BIOS Settings
IOMMU = enabled
NX mode = enabled
SVM mode = enabled

# Kernel Patch
sudo nano /etc/default/grub
 GRUB_CMDLINE_LINUX_DEFAULT="amd_iommu=on iommu=pt..."
sudo grub-mkconfig -o /boot/grub/grub.cfg
 !!!!REBOOT BEFORE PROCEEDING!!!

# Initramfs embedding
sudo nano /etc/mkinitcpio.conf \
 MODULES=(vfio_pci vfio vfio_iommu_type1 ...)
sudo mkinitcpio -P
sudo reboot

# Checking sane IOMMU groupings
sudo dmesg | grep -i -e DMAR -e IOMMU

Copy verification script:

 {#!/bin/bash
shopt -s nullglob
for g in $(find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V); do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done;
done;}

# Check kernel drivers and modules used
lspci -nnk -vv 
Make sure no bridges are added

# Installing virsh
sudo pacman -S qemu ebtables libvirt edk2-ovmf virt-manager dnsmasq vde2 nftables dnsmasq bridge-utils ovmf bless tree
sudo nano /etc/libvirt/libvirtd.conf
# uncomment (unix_sock_group = "libvirt") and unix_sock_rw_perms = "0770"
# append {
log_filters="1:qemu"
log_outputs="1:file:/var/log/libvirt/libvirtd.log"
}
sudo usermod -a -G libvirt $(whoami)

sudo systemctl enable libvirtd.service --now
sudo nano /etc/libvirt/qemu.conf
 #user = "root" to user = "your username"
 #group = "root" to group = "your username"

sudo systemctl enable virtlogd.socket --now
sudo virsh net-autostart default
sudo virsh net-start default
sudo systemctl restart libvirtd.service

# Install Base VM OS
virt-manager
 Q35 Chipset \
 UEFI BIOS w/ x86 ovmf-code.fd firmware
 Give all cores
 Configure storage win10.img w/ (virtio disk bus, raw formatting, cache mode as writeback)
 Enable boot menu, virtio disk 1, sata cdrom 1, 2 for win10 and virtio-drivers
 Virtual Network Default NAT
 NIC source "HOST DEVICE enpXXX: macvtap" bridge mode

Boot into VM
'Select VIRTIO SCSI controller from E:\amd64\w10\viostor.inf" drive 
Virtio disk refresh, install normally
sudo reboot

sudo mkdir /usr/share/vgabios
# place the rom in above directory with
 cd /usr/share/vgabios
#sudo chmod -R 660 <ROMFILE>.rom
#sudo chown username:username <ROMFILE>.rom

# Installing hooks
sudo mkdir /etc/libvirt/hooks
sudo wget 'https://raw.githubusercontent.com/PassthroughPOST/VFIO-Tools/master/libvirt_hooks/qemu' \
     -O /etc/libvirt/hooks/qemu
sudo chmod +x /etc/libvirt/hooks/qemu
sudo su

sudo mkdir /etc/libvirt/hooks/qemu.d/win10/prepare/begin
sudo mkdir /etc/libvirt/hooks/qemu.d/win10/release/end
sudo nano /etc/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
sudo chmod +x /etc/libvirt/hooks/qemu.d/win10/prepare/begin/start.sh
sudo chmod +x /etc/libvirt/hooks/qemu.d/win10/release/end/revert.sh

# XML Edits (Remember to change default preferences in menu)

# Passthrough both pci GPU hosts, both keyboard and mouse, and disable SATA IDE disk.
<rom file="/usr/share/vgabios/<romfile>.rom"/> 
# Remove spice / qxl stuff in VM
 add keyboard and mouse device or passtrough the complete usb device.
# Match XML Edit in Win10
  
  </os>
  </features>
  <cpu mode='host-passthrough' check='none'>
    <topology sockets='1' cores='6' threads='2'/>
    <feature policy='require' name='topoext'/>
  </cpu>  
    <acpi/>
    <apic/>
    <hyperv>
      <relaxed state='on'/>
      <vapic state='on'/>
      <spinlocks state='on' retries='8191'/>
      <vendor_id state='on' value='123456789123'/>
    </hyperv>
    <kvm>
      <hidden state='on'/>
    </kvm>
    <vmport state='off'/>
    <ioapic driver='kvm'/>

# Optionals
Snapshots:  
 <loader readonly='yes' type='rom'>/usr/share/edk2-ovmf/x64/OVMF_CODE.fd</loader>
sudo loginctl enable-linger netrunner

# Troubleshooting
"Error: unsupported configuration: pci backend driver 'default' is not supported"
A: Remove your NIC like virtio and passthrough your own network card like you can find in your IOMMU groups.

