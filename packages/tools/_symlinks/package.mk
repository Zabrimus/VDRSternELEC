# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_symlinks"
PKG_VERSION="e22cde5c1c5ce5ebef0173993dc67e3e9c811c33"
PKG_SHA256="87ad3a19d0aaa5c9b0a79391106942d22f4abe4e4f28b05a8febdab78379a3dd"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/brandt/symlinks"
PKG_URL="https://github.com/brandt/symlinks/archive/e22cde5c1c5ce5ebef0173993dc67e3e9c811c33.zip"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="symlinks-${PKG_VERSION}"
PKG_LONGDESC="scan/change symbolic links"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

makeinstall_host() {
	:
}