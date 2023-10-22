# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011 Anthony Nash (nash.ant@gmail.com)
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_coreelec-cefbrowser"
PKG_VERSION="0.1.0"
PKG_SHA256=""
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL=""
PKG_SOURCE_NAME=""
PKG_DEPENDS_TARGET=""
PKG_LONGDESC="cefbrowser install scripts for CoreELEC/Docker environments"
PKG_TOOLCHAIN="manual"

post_makeinstall_target() {
  # install binary in /usr/local/bin
  mkdir -p ${INSTALL}/usr/local/bin
  cp ${PKG_DIR}/bin/* ${INSTALL}/usr/local/bin

  mkdir -p ${INSTALL}/storage/.config/system.d
  cp ${PKG_DIR}/_system.d/cefbrowser.service ${INSTALL}/storage/.config/system.d

  mkdir -p ${INSTALL}/storage/browser
  cp ${PKG_DIR}/config/sockets.ini ${INSTALL}/storage/browser

  # zip static files
  mkdir -p ${INSTALL}/usr/local/config
  cd ${INSTALL}
  zip -qrum9 ${INSTALL}/usr/local/config/web-cefbrowser.zip storage
}