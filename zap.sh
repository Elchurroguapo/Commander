#!/bin/sh
#Erase MBR
gdisk /dev/nvme0n1 \
 x \
 z \
 y \
 y \
gdisk /dev/nvme1n1 \
 x \
 z \
 y \
 y \
reboot
