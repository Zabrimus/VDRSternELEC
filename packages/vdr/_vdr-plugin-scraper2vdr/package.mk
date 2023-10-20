# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-scraper2vdr"
PKG_VERSION="d62670c2168fc88b8f5929617889334a68a2f166"
PKG_SHA256="6139480b4642521ccf77337c77ad8bb36d42c38f961275734f435fe95a6d141c"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/horchi/scraper2vdr"
PKG_URL="https://github.com/horchi/scraper2vdr/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="scraper2vdr-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _mariadb-connector-c _graphicsmagick vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _mariadb-connector-c _graphicsmagick"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr Python3 _mariadb-connector-c vdr-helper)"
PKG_LONGDESC="scraper2vdr acts as client and provides scraped metadata for tvshows and movies from epgd to other plugins via its service interface."
PKG_BUILD_FLAGS="+speed"

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
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}

  rm -f ${PKG_DIR}/patches/uint64_t.patch
}
