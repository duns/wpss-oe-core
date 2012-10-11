#!/bin/bash
#
# Do some OE cleanup before switching kernels
#

if [[ -z "${OETMP}" ]]; then
        OETMP=${OVEROTOP}/tmp
fi

packages=( ti-dsplib \
           ti-dsplink \
           ti-dmai \
           ti-dspbios \
           ti-local-power-manager \
           ti-linuxutils \
	task-gstreamer-ti \
)

ASD="
sysvinit-2.86 \
gstreamer-ti \
ti-c6accel-apps \
ti-c6accel \
ti-codecs-omap3530-server \
ti-codecs-omap3530 \
ti-framework-components \ 
ti-codec-engine-examples \
ti-codec-engine \
ti-xdctools \
ti-cgt6x \
ti-xdais \
ti-edma3lld \
ti-biosutils \
virtual/kernel \
kernel-module-econ \
)
"




for pkg in ${packages[@]}
do
    bitbake -c clean $pkg
done

rm -rf $OETMP/cache/*
for pkg in ${packages[@]}
do
    bitbake $pkg
done

