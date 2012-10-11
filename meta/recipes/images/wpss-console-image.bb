# Personal testing console image

require recipes-images/gumstix/gumstix-console-image.bb
LICENSE = "LGPLv2"
#PREFERRED_PROVIDER_virtual/kernel = "linux-wpss"


#PREFERRED_PROVIDER_virtual/kernel = "linux-omap3-econ"
#PREFERRED_VERSION_linux-libc-headers = "2.6.34"
#PREFERRED_VERSION_gcc-cross-sdk = "4.3.3"
#PREFERRED_VERSION_ti-linuxutils = "3_22_00_02"

# If you need additional packages by default, you can add them to the installation image here.
# This example installs everything to make OpenCV work on BeagleBoard and Gumstix
# with native support for Point Grey Firefly MV USB 2.0 machine vision cameras.
# (run "opencv-cvcap 0" to test, but to do so you have to change the line above
# to "require recipes/images/omap3-desktop-image.bb")
#
# It also contains GCC and binutils, so you can compile code on the board itself
# opencv \
# opencv-dev \
# opencv-bin \
# boost-dev \
#  gst-plugins-bad \
#  gst-ffmpeg \
#  gst-omapfb \
#  gst-plugins-base \
#  gst-plugins-good \
#  gst-plugins-ugly \
#  gstreamer-ti \
#kernel-module-econ \
#  networkmanager \

IMAGE_INSTALL += " \
  kernel-module-twl4030-pwrbutton \
  kernel-module-gpio-keys \
  libgsm \
  gst-ffmpeg \
  gst-plugins-base-meta \
  gst-plugins-good-meta \
  gst-plugins-ugly-meta \
  gst-plugins-base-apps \
  gst-plugins-good-apps \
  gst-plugins-ugly-apps \
  task-native-sdk \
  pkgconfig \
  libdc1394 \
  grep \
  dropbear \
  git \
  ncurses-dev \
  nano \
  vim \
  screen \
  lighttpd \
  lighttpd-module-fastcgi \
  php \
  php-cgi \
  php-cli \
  php-pear \
  openvpn \
  v4l-utils \
  ptu-software \
  boost \
  gst-testsource \
  linphone \
  linphonec \
  ti-linuxutils \
  gstreamer-ti \
  ifplugd \
  usbutils \
 "
#  gst-omapfb \
#  gsl-dev \
#  gst-rtsp \
#  task-gstreamer-ti \
#  linux-input \

export IMAGE_BASENAME = "wpss-console-image"
