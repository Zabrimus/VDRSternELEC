# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="vdr-helper"
PKG_VERSION="0"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Some build helper scripts"
PKG_TOOLCHAIN="manual"

make_target() {
  cp ${PKG_DIR}/zip_config.sh ${PKG_BUILD}
}
