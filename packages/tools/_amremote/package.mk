# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011 Anthony Nash (nash.ant@gmail.com)
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_amremote"
PKG_VERSION="0.1.0"
PKG_SHA256="2aafc4dd1bc5ca7724d5b5185799ea981cbd0b9c99075e6b5ce86a699f0c5cc5"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL=""
PKG_SOURCE_NAME=""
PKG_DEPENDS_TARGET="toolchain _python-evdev"
PKG_LONGDESC="amremote"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed"

post_makeinstall_target() {
  PREFIX="/usr/local"

   rm -rf ${INSTALL}/usr/lib/udev/rules.d
      mkdir -p ${INSTALL}/usr/lib/udev/rules.d
      cp -PR ${PKG_DIR}/_udev.d/*.rules ${INSTALL}/usr/lib/udev/rules.d

   rm -rf ${INSTALL}/usr/local/bin
      mkdir -p ${INSTALL}/usr/local/bin
      cp -PR ${PKG_DIR}/bin/* ${INSTALL}/usr/local/bin

   mkdir -p ${INSTALL}/usr/lib/systemd/system
      cp ${PKG_DIR}/_system.d/amremote.service ${INSTALL}/usr/lib/systemd/system
      enable_service amremote.service
}