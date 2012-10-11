DESCRIPTION="Video streaming source prototype"
PR="r0"
LICENSE = "LGPLv2"

DEPENDS="boost \
         gstreamer"

#SRC_URI="file:///home/kostas/workspace/${PN}-${PV}.tar.gz"
#SRC_URI[archive.md5sum]="de370b6148434f43ce02ddbfc93d709c"

SRCREV =  "${AUTOREV}"
SRC_URI = "git://github.com/chpap/ptu-software.git;branch=develop;protocol=git \
"
LIC_FILES_CHKSUM = "file://../../README.md;md5=0cf88e25d6f970bc6d959af1763e288c"



S = "${WORKDIR}/git/src/gst-testsource"

inherit autotools
