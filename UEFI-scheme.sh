#!/bin/sh
#EFI Boot Verify
efivar -l
#GPT Create
cgdisk /dev/nvme0n1

#New Primary Partition
#Default Start Alignment
#1024 MiB
#EF00
#esp

#New Primary Partition
#Default Start Alignment
#Default End Alignment
#8300
#/mnt

#write, yes

cgdisk /dev/nvme1n1

#New Primary Partition
#Default Start Alignment
#16 GiB
#8200
#swap

#New Primary Partition
#Default Start Alignment
#Default End Alignment
#8300
#~./home

#write, yes

lsblk
