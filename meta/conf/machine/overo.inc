require conf/machine/include/omap3.inc

EXTRA_IMAGEDEPENDS = "u-boot-sakoman"

PREFERRED_PROVIDER_virtual/bootloader = "u-boot-sakoman"
UBOOT_MACHINE = "omap3_overo_config"
#PREFERRED_VERSION_pn-u-boot = "2011.12"
#PREFERRED_VERSION_pn-u-boot-sakoman = "2011.09"
UBOOT_BINARY = "u-boot.bin"
UBOOT_IMAGE = "u-boot-${MACHINE}-${PV}-${PR}.bin"

#PREFERRED_PROVIDER_virtual/kernel = "linux-omap3"
PREFERRED_PROVIDER_ntp = "ntp"
#PREFERRED_PROVIDER_virtual/kernel = "linux-sakoman"  
#PREFERRED_VERSION_linux-sakoman= "3.2"  
PREFERRED_PROVIDER_virtual/kernel = "linux-wpss"  
PREFERRED_VERSION_linux-wpss= "3.2"  

PREFERRED_PROVIDER_virtual/xserver = "xserver-xorg"
XSERVER = "xserver-xorg \
           xf86-input-evdev \
           xf86-input-mouse \
           xf86-video-omapfb \
           xf86-input-keyboard"

PREFERRED_PROVIDER_jpeg = "libjpeg-turbo"
PREFERRED_PROVIDER_jpeg-native = "libjpeg-turbo-native"

SERIAL_CONSOLE = "115200 ttyO2"

IMAGE_FSTYPES += "tar.bz2"

MKUBIFS_ARGS = "-m 2048 -e 129024 -c 4044"
UBINIZE_ARGS = "-m 2048 -p 128KiB -s 512"

UBI_VOLNAME = "rootfs"

MACHINE_EXTRA_RDEPENDS = "omap3-writeprom"
MACHINE_EXTRA_RRECOMMENDS = " kernel-modules"

MACHINE_FEATURES = "kernel26 alsa apm ext3 screen usbgadget usbhost vfat wifi"

TOOLCHAIN_PATH ?= "${STAGING_DIR_NATIVE}${prefix_native}/bin/${TUNE_PKGARCH}${HOST_VENDOR}-${HOST_OS}" 
TOOLCHAIN_SYSPATH ?= "${TOOLCHAIN_PATH}/${TARGET_SYS}"
PREFERRED_PROVIDER_udev                  = "systemd"
