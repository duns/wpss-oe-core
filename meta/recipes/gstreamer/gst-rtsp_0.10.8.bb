require gst-rtsp.inc
SRC_URI[md5sum] = "b511af07000595f63c3a705946221643"
SRC_URI[sha256sum] = "9915887cf8515bda87462c69738646afb715b597613edc7340477ccab63a6617"

#do_qa_configure parses config.log and sees errors?
#EXTRA_OECONF = "--with-python-root=${STAGING_DIR_HOST}/${prefix}"
## python bindings cause config.log entries that appear as cross-compilation problems 

do_qa_configure() {
}

