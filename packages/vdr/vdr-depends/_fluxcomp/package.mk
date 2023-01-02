# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_fluxcomp"
PKG_VERSION="d873d29617b4174418e9603f5bcd8f958ca9c793"
PKG_SHA256="716df0ecd5070df4de2279256bd2aa881180ff45832c95bc0a3221fad9d6ad21"
PKG_LICENSE="GPL3"
PKG_SITE="https://github.com/kevleyski/fluxcomp"
PKG_URL="https://github.com/kevleyski/fluxcomp/archive/${PKG_VERSION}.zip"
PKG_BRANCH="distrotech-flux"
PKG_DEPENDS_HOST="toolchain:host"
PKG_LONGDESC="flux is an interface description language used by DirectFB"
PKG_BUILD_FLAGS="+pic"
PKG_SOURCE_DIR="fluxcomp-${PKG_VERSION}"
PKG_TOOLCHAIN="configure"
