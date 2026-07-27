# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_preloader"
PKG_VERSION="cb000e0cd7f8a2303cf2167d60c295cac03b3a27"
PKG_SHA256="3fa5358865850c2cb047e749da46000a25433689e2f6f6b9ce5a68e8c47a6732"
PKG_LICENSE=""
PKG_SITE="https://github.com/Theldus/preloader"
PKG_URL="https://github.com/Theldus/preloader/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="preloader-${PKG_VERSION}"
PKG_LONGDESC="Preloader 'pre-loads' dynamically linked executables to speed up their load times"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"
