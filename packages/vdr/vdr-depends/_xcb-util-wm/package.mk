# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_xcb-util-wm"
PKG_VERSION="0.4.1"
PKG_SHA256="038b39c4bdc04a792d62d163ba7908f4bb3373057208c07110be73c1b04b8334"
PKG_LICENSE="OSS"
PKG_SITE="http://xcb.freedesktop.org"
PKG_URL="https://xcb.freedesktop.org/dist/xcb-util-wm-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libxcb"
PKG_LONGDESC="The XCB util modules provides a number of libraries which sit on top of libxcb"
PKG_BUILD_FLAGS="+pic +speed"

PKG_CONFIGURE_OPTS_TARGET="--prefix=/usr/local"

