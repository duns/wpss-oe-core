FILESEXTRAPATHS := "${THISDIR}/files"
SRC_URI_append_overo= " file://001-WPSS-Pin-Mux-initialization.patch \
			file://002-change-default-env.patch"
#SRC_URI += "file://001-WPSS-Pin-Mux-initialization.patch"
