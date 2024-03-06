# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="incus"
PKG_VERSION="0.6.0"
PKG_VERSION_NUMBER="0.6.0"
PKG_REV="1"
PKG_SHA256="9bbce9ae95b40be4bd11116a97f422ecd2adf2915a2c0b6828fa34435de756d2"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/lxc/incus"
PKG_URL="https://github.com/lxc/incus/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain go:host _cowsql _libacl _lxc"
PKG_SOURCE_DIR="incus-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_SECTION="service"
PKG_LONGDESC="Powerful system container and virtual machine manager"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="incus"
PKG_ADDON_TYPE="xbmc.service"

pre_configure_target() {
  	export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||")"
  	export CFLAGS=$(echo "${CFLAGS} -Wno-use-after-free -I$(get_build_dir _cowsql)/include")
}

make_target() {
    go_configure
    GO=${GOLANG} make  # SHELL='sh -x'
}

makeinstall_target() {
    :
}

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/lib

  echo "==> ADDON"
}
