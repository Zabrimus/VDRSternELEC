# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_python-evdev"
PKG_VERSION="a47b5b5a6f79bde6823095d1105501856338aed7"
PKG_SHA256="8f1c9b0e64765d2ef086f93baa27c87934a4966ce0326b4c537b5a52c5e3f221"
PKG_LICENSE=""
PKG_SITE="https://github.com/gvalkov/python-evdev/"
PKG_URL="https://github.com/gvalkov/python-evdev/archive/${PKG_VERSION}.zip"
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
