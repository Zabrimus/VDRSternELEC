# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_python-evdev"
PKG_VERSION="5227b1672cbf074287088860c855c24bb96fe6b1"
PKG_SHA256="892fcbe408c8dba979d5c2da0e10c58fcf9469c5e0dc74b7188b6eb52843d1b9"
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
