# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-scraper2vdr"
PKG_VERSION="d62670c2168fc88b8f5929617889334a68a2f166"
PKG_SHA256="6139480b4642521ccf77337c77ad8bb36d42c38f961275734f435fe95a6d141c"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/horchi/scraper2vdr"
PKG_URL="https://github.com/horchi/scraper2vdr/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="scraper2vdr-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _mariadb-connector-c _graphicsmagick"
PKG_DEPENDS_CONFIG="_vdr _mariadb-connector-c _graphicsmagick"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory Python3) $(get_pkg_directory _mariadb-connector-c)"
PKG_LONGDESC="scraper2vdr acts as client and provides scraped metadata for tvshows and movies from epgd to other plugins via its service interface."

post_unpack() {
	# Copy patches.cond
	rm -f ${PKG_DIR}/patches/uint64_t.patch

	if [ "${DISTRO}" = "LibreELEC" ] && [ "${ARCH}" = "arm" ]; then
		cp ${PKG_DIR}/patches.cond/uint64_t.patch ${PKG_DIR}/patches/uint64_t.patch
	fi;
}

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
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
