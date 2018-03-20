#!/bin/sh
# script to run bcm.user

#export SOC_BOOT_FLAGS=0x1000

export BCM_CONFIG_FILE=/opt/adva/qumran/shell/config.bcm

./bcm.user

