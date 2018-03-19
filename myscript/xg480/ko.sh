#!/bin/bash
# install Broadcom ko

# remount
mount -o remount,rw /opt/adva
echo "remount done."

# dhcp
dhclient ni0
echo "dhcp done."

# insmod .ko
cd /opt/adva/qumran/ko
insmod linux-kernel-bde.ko dmasize=16M maxpayload=128 debug=4 dma_debug=4
insmod linux-user-bde.ko
insmod linux-bcm-knet.ko
insmod linux-uk-proxy.ko

mknod /dev/linux-bcm-knet c 122 0
mknod /dev/linux-uk-proxy c 125 0
mknod /dev/linux-user-bde c 126 0
mknod /dev/linux-kernel-bde c 127 0
echo "BCM .ko install done."

# others
# alias
#alias ll='ls -l'
#alias lspci='/boot/pciutils/sbin/lspci'

