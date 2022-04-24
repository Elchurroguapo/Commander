#!/bin/bash
#debugging
set-x

#unbind VTConsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind

#unbind EFI framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind

#avoid race condition
sleep 10

#Unload nvidia drivers
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r nvidia
modprobe -r drm
modprobe -r nvidia_uvm
modprobe -r nouveau

#unbind GPU
virsh nodedev-detach pci_0000_0b_00_0
virsh nodedev-detach pci_0000_0b_00_1

#load vfio
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1
