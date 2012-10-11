require gst-common.inc

DESCRIPTION = "Gstreamer RTSP server"
LICENSE = "LGPLv2"
LIC_FILES_CHKSUM = "file://COPYING;md5=55ca817ccb7d5b5b66355690e9abc605"

DEPENDS += "check gst-plugins-base gstreamer"

SRC_URI = "http://people.freedesktop.org/~wtay/gst-rtsp-${PV}.tar.bz2"

