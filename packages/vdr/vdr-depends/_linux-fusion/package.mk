# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_linux-fusion"
PKG_VERSION="9c0013d066de179ec6ba6135d8f5e5b37af8b736"
PKG_SHA256="0cfcea8a712ee1e7af82b71b408d403291fc538c0765770a87e18787f5f3d7a8"
PKG_LICENSE="?"
PKG_SITE="https://github.com/deniskropp/linux-fusion"
PKG_URL="https://github.com/deniskropp/linux-fusion/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="linux-fusion"
PKG_NEED_UNPACK="${LINUX_DEPENDS}"
#PKG_IS_KERNEL_PKG="yes"
PKG_SOURCE_DIR="linux-fusion-${PKG_VERSION}"
PKG_TOOLCHAIN="make"

make_target() {
	KERNEL_VER=$(echo $(basename $(get_install_dir linux)) | sed -e 's/linux-//')

    echo "Kernel Version: ${KERNEL_VER}"
    echo "Kernel Build: $(kernel_path)"
    echo "Sysroot: ${SYSROOT_PREFIX}"

	make KERNEL_VERSION=${KERNEL_VER} KERNEL_BUILD=$(kernel_path) SYSROOT=${SYSROOT_PREFIX} install SHELL="sh -x"
}

# make KERNEL_VERSION=2.6.25.4 SYSROOT=/opt/sh7723 install
# make KERNEL_VERSION=2.6.25.4 SYSROOT=/opt/sh7723 KERNEL_BUILD=/home/sh7723/kernel install