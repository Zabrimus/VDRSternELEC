# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_spice-protocol"
PKG_VERSION="499cc8326a672e9e5747efc017319b19e1594b42"
PKG_SHA256="1bde5e1309bd48d59d0c8845416a8475b48b14523fc4f1cde4bd8d61ef04d500"
PKG_LICENSE="GPL3"
PKG_SITE="https://gitlab.freedesktop.org/spice/spice-protocol.git"
PKG_URL="https://gitlab.freedesktop.org/spice/spice-protocol/-/archive/${PKG_VERSION}/spice-protocol-${PKG_VERSION}.tar.gz"
PKG_BRANCH="master"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The protocol definition for SPICE project"
PKG_TOOLCHAIN="auto"
PKG_BUILD_FLAGS="+speed"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}
