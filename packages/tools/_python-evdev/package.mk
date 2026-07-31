# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_python-evdev"
PKG_VERSION="1.6.1"
PKG_SHA256="6b412da2d3b206feff86bb3b6456b8dde8e2b0b9ce23dfd4e556ced125c6ac4f"
PKG_LICENSE=""
PKG_SITE="https://github.com/gvalkov/python-evdev/"
PKG_URL="https://github.com/gvalkov/python-evdev/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libevdev Python3 _distutilscross:host"
PKG_SOURCE_DIR="python-evdev-${PKG_VERSION}"
PKG_LONGDESC="Python bindings for the Linux input subsystem"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed"

pre_configure_target() {
  export LDSHARED="${CC} -shared"
}

make_target() {
  python setup.py \
         build \
         build_ecodes --evdev-headers ${SYSROOT_PREFIX}/usr/include/linux/input.h:${SYSROOT_PREFIX}/usr/include/linux/input-event-codes.h:${SYSROOT_PREFIX}/usr/include/linux/uinput.h \
         build_ext --include-dirs ${SYSROOT_PREFIX}/
}

makeinstall_target() {
  python setup.py install --root=$INSTALL/usr --home=""
}
