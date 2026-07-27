# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_cowsql"
PKG_VERSION="1.15.4"
PKG_SHA256="91d023adf66d00eed0cd774db4e8a7d063d0d8c2d475e1edb8c7b42367f53f76"
PKG_LICENSE="LGPL 3"
PKG_SITE="https://github.com/cowsql/cowsql"
PKG_URL="https://github.com/cowsql/cowsql/archive/refs/tags/v${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _raft"
PKG_BRANCH="master"
PKG_SOURCE_DIR="cowsql-${PKG_VERSION}"
PKG_LONGDESC="Powerful system container and virtual machine manager"
PKG_TOOLCHAIN="configure"
PKG_BUILD_FLAGS="+speed -sysroot"

PKG_CONFIGURE_OPTS_TARGET="--enable-shared \
                           --with-sysroot=${SYSROOT_PREFIX} \
                           "

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||")"
  export LDFLAGS="${LDFLAGS} -L$(get_install_dir _raft)/usr/lib"
  export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:$(get_install_dir _raft)/usr/lib/pkgconfig"

  export CFLAGS=$(echo "${CFLAGS} -Wno-unused-variable -Wno-unused-but-set-variable -Wno-unused-function -Wno-maybe-uninitialized -Wno-unused-parameter")

  autoreconf -i
}
