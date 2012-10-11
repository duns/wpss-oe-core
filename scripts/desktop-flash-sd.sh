#!/bin/bash

#
# This script flashes an image onto a connected SDHC card
#
USBDEVICE=/dev/sdd
FATDIR=/tmp/BOOT
ROOTDIR=/tmp/ROOT
ROOTTAR=testing-desktop-image-overo.tar.bz2
KERNELFILE=uImage-overo.bin
MODULEFILES=modules-2.6.34-r102-overo.tgz
IMAGEDIR=$OVEROTOP/tmp/deploy/glibc/images/overo
XLOADER=x-load-overo.bin.ift
#IMAGEDIR=/tmp/tt2/overo

sudo mkdir -p ${FATDIR} ${ROOTDIR}

sudo mount ${USBDEVICE}1 ${FATDIR}
sudo mount ${USBDEVICE}2 ${ROOTDIR}


# Copy the u-boot bootloader
sudo cp -f ${IMAGEDIR}/u-boot-overo.bin ${FATDIR}/u-boot.bin

# Copy the kernel image
sudo cp -f ${IMAGEDIR}/${KERNELFILE} ${FATDIR}/uImage

# Copy the x-loader
sudo cp -f ${IMAGEDIR}/${XLOADER} ${FATDIR}/MLO



# Remove old files (if any)
sudo rm -rf ${ROOTDIR}/* && sudo mkdir ${ROOTDIR}/lost+found
# Flash the root file system
sudo tar xjf ${IMAGEDIR}/${ROOTTAR} -C ${ROOTDIR}
# Copy the kernel image and modules
sudo cp -f ${IMAGEDIR}/${KERNELFILE} ${ROOTDIR}/boot/uImage
sudo tar xvzf ${IMAGEDIR}/${MODULEFILES} -C ${ROOTDIR}

sudo umount ${FATDIR} ${ROOTDIR}
echo TODO .scr
