# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_netcat"
PKG_VERSION="7221e6094740382219304bbd813783a860a0948a"
PKG_SHA256="8bdc51863cdec8ff3978fe6e15b72db5130a5b24496f6a9d6792cac66a4f3d32"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Zabrimus/netcat-1.10-debian"
PKG_URL="https://github.com/Zabrimus/netcat-1.10-debian/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="netcat-1.10-debian-${PKG_VERSION}"
PKG_LONGDESC="Schweizer Taschenmesser für TCP/IP"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

make_target() {
	make linux CC=${CC}
}

makeinstall_target() {
 	mkdir -p ${INSTALL}/usr/bin
 	cp $(get_build_dir _netcat)/nc ${INSTALL}/usr/bin/netcat
}