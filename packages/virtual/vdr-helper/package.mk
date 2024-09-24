# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="vdr-helper"
PKG_VERSION="0"
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Some build helper scripts"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
  APIVERSION="$(cat $(get_build_dir _vdr)/config.h | grep '#define APIVERSION' | cut -d '"' -f 2)"
  cp ${PKG_DIR}/zip_config.sh ${PKG_BUILD}
  sed -i s/XXAPIVERSIONXX/${APIVERSION}/ ${PKG_BUILD}/zip_config.sh
}
