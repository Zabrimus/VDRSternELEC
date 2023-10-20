# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_python-evdev"
PKG_VERSION="2dd6ce6364bb67eedb209f6aa0bace0c18a3a40a"
PKG_SHA256="b802f9e25c6c218facd54780c4b3d6436fb769d51e3aa286df63a382a4c799ab"
PKG_LICENSE=""
PKG_SITE="https://github.com/gvalkov/python-evdev/"
PKG_URL="https://github.com/gvalkov/python-evdev/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain libevdev Python3 distutilscross:host"
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
         build_ecodes --evdev-headers ${SYSROOT_PREFIX}/usr/include/linux/input.h:${SYSROOT_PREFIX}/usr/include/linux/input-event-codes.h \
         build_ext --include-dirs ${SYSROOT_PREFIX}/
}

makeinstall_target() {
  python setup.py install --root=$INSTALL/usr --home=""
}

post_makeinstall_target() {
  find ${INSTALL}/usr/lib -name "*py" -exec rm -rf "{}" ";"
}