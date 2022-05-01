#!/bin/bash
#debugging
set -x

#stop display manager
systemctl stop sddm.service
  
#Unbind VTConsoles
echo 0 > /sys/class/vtconsole/vtcon0/bind
echo 0 > /sys/class/vtconsole/vtcon1/bind
  
#Unbind EFI-framebuffer
echo efi-framebuffer.0 > /sys/bus/platform/drivers/efi-framebuffer/unbind
  
#Avoid race condition
sleep 10
  
#Unload Nvidia
modprobe -r nvidia_drm
modprobe -r nvidia_modeset
modprobe -r drm_kms_helper
modprobe -r nvidia
modprobe -r i2c_nvidia_gpu
modprobe -r nvidia_uvm
modprobe -r nouveau

#Unbind gpu
virsh nodedev-detach pci_0000_0b_00_0
virsh nodedev-detach pci_0000_0b_00_1
  
#Load VFIO
modprobe vfio
modprobe vfio_pci
modprobe vfio_iommu_type1
