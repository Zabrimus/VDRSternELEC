# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_python-evdev"
PKG_VERSION="a5d8cf0749f15d44feb76bbed27b30a75b3c7c1f"
PKG_SHA256="cb641d8a57749017083c33a546b80659706b1e78cce3e8d60367692ad0dc25c7"
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
         build_ecodes --evdev-headers ${SYSROOT_PREFIX}/usr/include/linux/input.h:${SYSROOT_PREFIX}/usr/include/linux/input-event-codes.h \
         build_ext --include-dirs ${SYSROOT_PREFIX}/
}

makeinstall_target() {
  python setup.py install --root=$INSTALL/usr --home=""
}

post_makeinstall_target() {
  find ${INSTALL}/usr/lib -name "*py" -exec rm -rf "{}" ";"
}