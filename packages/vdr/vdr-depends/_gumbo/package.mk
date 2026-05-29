# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_gumbo"
PKG_VERSION="3134b780192433161202e8118f7692f30ab7cc6c"
PKG_SHA256="fd67bff5b8cabe5da06e3c843ccce2e4c2e74dc1fc4c66bfff4cfc18079fabf7"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/GerHobbelt/gumbo-parser"
PKG_URL="https://github.com/GerHobbelt/gumbo-parser/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="gumbo-parser-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Gumbo - A pure-C HTML5 parser."
PKG_TOOLCHAIN="meson"
PKG_BUILD_FLAGS="+speed"

PKG_MESON_OPTS_TARGET="-Dtests=false  \
                      --prefix=/usr/local \
                      --bindir=/usr/local/bin \
                      --libdir=/usr/local/lib \
                      --libexecdir=/usr/local/bin \
                      --sbindir=/usr/local/sbin \
                      --sysconfdir=/usr/local/etc \
                      "
