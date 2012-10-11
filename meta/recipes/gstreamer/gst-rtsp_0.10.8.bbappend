FILES_${PN} += "/usr/local/bin/* \
		"
do_install_append() {
       install -d ${D}/usr/local/bin/
	install -m 755 ${S}/examples/.libs/test-launch  ${D}/usr/local/bin/
}

