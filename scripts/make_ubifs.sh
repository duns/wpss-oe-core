#!/bin/bash

#
# This script flashes an image onto a connected SDHC card
#
RANDN=`echo $RANDOM|md5sum|awk '{print $1}'`
DEVICE=/dev/sdc
FATDIR=/tmp/BOOT-$RANDN
ROOTDIR=/tmp/ROOT-$RANDN

KERNELFILE=uImage-3.2-r103-overo.bin
MODULEFILES=modules-3.2-r103-overo.tgz
UBIIMG=phase2-console-image-overo.ubi
ROOTTAR=phase2-console-image-overo.tar.bz2
UBICFG=ubinize.cfg

IMAGEDIR=$OVEROTOP/tmp/deploy/glibc/images/overo
LOADERDIR=$OVEROTOP/tmp/deploy/glibc/images/overo
#LOADERDIR=$OVEROTOP/user.collection/loaders
IMAGEDIR=/tmp/tmp/overo
LOADERDIR=/tmp/tmp/overo

echo untaring root dir
sudo mkdir -p  ${ROOTDIR}
echo untaring the root file system
sudo tar xjf ${IMAGEDIR}/${ROOTTAR} -C ${ROOTDIR}
cat > $UBICFG << EOF
[ubifs] 
mode=ubi
image=${UBIIMG}.img
vol_id=0 
vol_type=dynamic 
vol_name=rootfs 
echo vol_flags=autoresize 
EOF

mkfs.ubifs -m 2048 -e 129024 -c 4000 -o $UBIIMG.img -r $ROOTDIR
ubinize -o $UBIIMG -m 2048 -p 128KiB -s 512 $UBICFG

sudo rm -rf ${ROOTDIR}
exit

# Remove old files (if any)
#sudo rm -rf ${ROOTDIR}/* && sudo mkdir ${ROOTDIR}/lost+found
# Flash the root file system
# Copy the kernel image and modules
echo copying the kernel image 
sudo cp -f ${IMAGEDIR}/${KERNELFILE} ${ROOTDIR}/boot/${KERNELFILE}
echo copying the kernel modules
sudo tar xzf ${IMAGEDIR}/${MODULEFILES} -C ${ROOTDIR}
