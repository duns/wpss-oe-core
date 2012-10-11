#!/bin/bash
MACHINE=overo

# export an alternative OETMP before sourcing this file if you
# don't want the default
if [[ -z "${OETMP}" ]]; then
	OETMP=${OVEROTOP}/tmp
fi

SYSROOTSDIR=${OETMP}/sysroots
STAGEDIR=${SYSROOTSDIR}/`uname -m`-linux/usr

export KERNELDIR=${SYSROOTSDIR}/${MACHINE}-angstrom-linux-gnueabi/kernel

PATH=${PATH}:${STAGEDIR}/bin:${STAGEDIR}/armv7a/bin

unset CFLAGS CPPFLAGS CXXFLAGS LDFLAGS MACHINE

export ARCH="arm"
export CROSS_COMPILE="arm-angstrom-linux-gnueabi-"
export CC="arm-angstrom-linux-gnueabi-gcc"
export LD="arm-angstrom-linux-gnueabi-ld"
export STRIP="arm-angstrom-linux-gnueabi-strip"

