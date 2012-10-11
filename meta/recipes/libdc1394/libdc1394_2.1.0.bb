DESCRIPTION = "1394-based DC Control Library"
HOMEPAGE = "http://sourceforge.net/projects/libdc1394"
SECTION = "libs"
LICENSE = "LGPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=dcf3c825659e82539645da41a7908589"

PR = "r6"
 
DEPENDS = "libusb1 libsm libv4l"
#EXTRA_OECONF = "--disable-doxygen-docs"
 
SRC_URI = " \
    ${SOURCEFORGE_MIRROR}/libdc1394/libdc1394-${PV}.tar.gz\
    file://firefly_13s2.patch;apply=yes\
    file://videodev_h.patch;apply=yes\
    "
#\\ \
#    file://configure-use-pkgconfig-to-find-libraw1394.patch;patch=1 \
#"
SRC_URI[md5sum] = "51909785c8c3da6881dd983c98c0c6d6"
SRC_URI[sha256sum] = "7175fd261aeb8f7ad991f6da38a1818a59ce6a14a70d4b8d754965aca6f77278"

#deprecated staging 
#do_stage() {
#    autotools_stage_all
#}
 
inherit autotools pkgconfig lib_package
