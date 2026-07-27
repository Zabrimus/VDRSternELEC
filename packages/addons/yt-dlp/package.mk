# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="yt-dlp"
PKG_VERSION="2025.12.08"
PKG_SHA256="10bec5b2bfb367263e7e46ddb69187204506f9d67b7f01bb499d07fa0d54d4b7"
PKG_LICENSE="The Unlicense / GPL3"
PKG_SITE="https://github.com/yt-dlp/yt-dlp"
PKG_URL="https://github.com/yt-dlp/yt-dlp/archive/refs/tags/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain Python3"
PKG_SOURCE_DIR="yt-dlp-${PKG_VERSION}"
PKG_LONGDESC="A feature-rich command-line audio/video downloader "
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

PKG_REV="1"
PKG_IS_ADDON="yes"
PKG_SECTION=""
PKG_ADDON_NAME="yt-dlp"
PKG_ADDON_TYPE="xbmc.service"

make_target() {
	make yt-dlp
}

makeinstall_target() {
	mkdir -p ${INSTALL}/usr/bin

	cp -Pr ${PKG_BUILD}/yt-dlp.sh ${INSTALL}/usr/bin
	cp -Pr ${PKG_BUILD}/yt_dlp ${INSTALL}/usr/bin
}

addon() {
  	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  	cp -Pr $(get_install_dir yt-dlp)/usr/bin/* ${ADDON_BUILD}/${PKG_ADDON_ID}/bin

  	sed -i -e "s#python3#/usr/bin/python3#" ${ADDON_BUILD}/${PKG_ADDON_ID}/bin/yt-dlp.sh
}
