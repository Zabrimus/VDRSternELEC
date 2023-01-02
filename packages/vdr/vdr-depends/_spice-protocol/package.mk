# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_spice-protocol"
PKG_VERSION="4f31c1853646fe394d638beeff7e6bded9b0d86a"
PKG_SHA256="1f7d990c88e29b903476c8fc7bda40602c8a3a9596ffabda4ab988680438b89e"
PKG_LICENSE="GPL3"
PKG_SITE="https://gitlab.freedesktop.org/spice/spice-protocol"
PKG_URL="https://gitlab.freedesktop.org/spice/spice-protocol/-/archive/${PKG_VERSION}/spice-protocol-${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The protocol definition for SPICE project"
PKG_TOOLCHAIN="auto"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
