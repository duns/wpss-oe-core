#!/bin/bash

#
# This script flashes an image onto a connected SDHC card
#
DEVICE=/dev/sdc
FATDIR=/tmp/BOOT
ROOTDIR=/tmp/ROOT

XLOADER=MLO-overo
BOOTSCR=boot.scr
UBOOT=u-boot-overo.bin
KERNELFILE=uImage-3.2-r103-overo.bin
MODULEFILES=modules-3.2-r103-overo.tgz

ROOTTAR=phase2-console-image-overo.tar.bz2

IMAGEDIR=$OVEROTOP/tmp/deploy/glibc/images/overo
LOADERDIR=$OVEROTOP/user.collection/loaders
IMAGEDIR=/tmp/tmp/overo
LOADERDIR=/tmp/tmp/overo
#IMAGEDIR=/tmp/tt2/overo

sudo mkdir -p ${FATDIR} ${ROOTDIR}

sudo mount ${DEVICE}1 ${FATDIR}
sudo mount ${DEVICE}2 ${ROOTDIR}




# Copy the kernel image
sudo cp -f ${IMAGEDIR}/${KERNELFILE} ${FATDIR}/uImage




# Copy the kernel image and modules
sudo cp -f ${IMAGEDIR}/${KERNELFILE} ${ROOTDIR}/boot/${KERNELFILE}
sudo tar xvzf ${IMAGEDIR}/${MODULEFILES} -C ${ROOTDIR}

sudo umount ${FATDIR} ${ROOTDIR}
echo TODO .scr
