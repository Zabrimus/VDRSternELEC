# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_gumbo"
PKG_VERSION="d708b4e2f73b0e75c6e16593b6cf7ff98c7f4693"
PKG_SHA256="d200c76ee63d345f9de503519561e4819f522193ceb2497484c5409a134015c2"
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
