nano /etc/libvirt/hooks/qemu.d/win10/release/end/revert.sh
  #Debug
  set -x
  
  #Load Variables
  source "/etc/libvirt/hooks/kvm.conf"
  
  #Unload vfio-pci
  modprobe -r vfio_pci
  modprobe -r vfio_iommu_type1
  modprobe -r vfio
  
  #Rebind GPU
  virsh nodedev-reattach $VIRSH_GPU_VIDEO
  virsh nodedev-reattach $VIRSH_GPU_AUDIO
  
  #Rebind VTConsoles
  echo 1 > /sys/class/vtconsole/vtcon0/bind
  echo 0 > /sys/class/vtconsole/vtcon1/bind
  
  #Read nvidia x config
  nvidia-xconfig --query-gpu-info > /dev/null 2>&1
  
  #Bind EFI-framebuffer
  echo "efi-framebuffer.0" > /sys/bus/platform/drivers/efi-framebuffer/bind
  
  #Load Nvidia
  modprobe nvidia_drm
  modprobe nvidia_modeset
  modprobe drm_kms_helper
  modprobe nvidia
  modprobe drm
  modprobe nvidia_uvm
  
  #Restart Display Service
  systemctl start sddm.service
