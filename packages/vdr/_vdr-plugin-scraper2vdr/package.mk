# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-scraper2vdr"
PKG_VERSION="70f227568716ee1939e68a4508e44ec2974c7384"
PKG_SHA256="c55c2d08bdc37291eed9c45c51b1dc22bd34433ec4e4a4709235f5e45541383d"
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
