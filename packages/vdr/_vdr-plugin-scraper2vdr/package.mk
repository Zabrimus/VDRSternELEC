# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-scraper2vdr"
PKG_VERSION="ee20d354965f7d7e428aace41aec11a7821e4a6f"
PKG_SHA256="e73c03c03c49a8f6ca55a2ec24f046c85816184f525ffaacc94b7bf2218b7b98"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/horchi/scraper2vdr"
PKG_URL="https://github.com/horchi/scraper2vdr/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="scraper2vdr-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _mariadb-connector-c _graphicsmagick"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory Python3) $(get_pkg_directory _mariadb-connector-c)"
PKG_LONGDESC="scraper2vdr acts as client and provides scraped metadata for tvshows and movies from epgd to other plugins via its service interface."
PKG_TOOLCHAIN="manual"

post_unpack() {
	# Copy patches.cond
	rm -f ${PKG_DIR}/patches/uint64_t.patch

	if [ "${DISTRO}" = "LibreELEC" ] && [ "${ARCH}" = "arm" ]; then
		cp ${PKG_DIR}/patches.cond/uint64_t.patch ${PKG_DIR}/patches/uint64_t.patch
	fi;
}

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

make_target() {
  VDR_DIR=$(get_build_dir _vdr)
  PYTHON_DIR=(get_install_dir Python3)
  MARIADB_DIR=(get_install_dir _mariadb-connector-c)

  export PKG_CONFIG_PATH=${VDR_DIR}:${SYSROOT_PREFIX}/usr/local/lib/pkgconfig:${PYTHON_DIR}/usr/lib/pkgconfig:${MARIADB_DIR}/usr/lib/pkgconfig:${PKG_CONFIG_PATH}
  export CPLUS_INCLUDE_PATH=${VDR_DIR}/include

  make
}

makeinstall_target() {
  LIB_DIR=${INSTALL}/$(pkg-config --variable=locdir vdr)/../../lib/vdr
  make DESTDIR="${INSTALL}" LIBDIR="${LIB_DIR}" install
}

post_makeinstall_target() {
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/conf.d
  cp -PR ${PKG_DIR}/conf.d/* ${INSTALL}/storage/.config/vdropt-sample/conf.d/

  if find ${INSTALL}/storage/.config/vdropt -mindepth 1 -maxdepth 1 2>/dev/null | read; then
    cp -ar ${INSTALL}/storage/.config/vdropt/* ${INSTALL}/storage/.config/vdropt-sample
    rm -Rf ${INSTALL}/storage/.config/vdropt
  fi

  # create config.zip
  VERSION=$(pkg-config --variable=apiversion vdr)
  cd ${INSTALL}
  mkdir -p ${INSTALL}/usr/local/config/
  zip -qrum9 "${INSTALL}/usr/local/config/scraper2vdr-sample-config.zip" storage

  rm -f ${PKG_DIR}/patches/uint64_t.patch
}
