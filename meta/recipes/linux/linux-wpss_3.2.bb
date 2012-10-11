require linux.inc

DESCRIPTION = "Linux kernel for WPSS system"
KERNEL_IMAGETYPE = "uImage"

#DEFAULT_PREFERENCE = "-1"

COMPATIBLE_MACHINE = "overo"

BOOT_SPLASH ?= "logo_linux_clut224-generic.ppm"
PV = "3.2"

S = "${WORKDIR}/git"

SRCREV = "513770d80c0cfb26cc406c9ca3916df2e7afe46d"
SRC_URI = "git://www.sakoman.com/git/linux.git;branch=omap-3.2;protocol=git \
	   file://defconfig \
           file://${BOOT_SPLASH} \
           "

