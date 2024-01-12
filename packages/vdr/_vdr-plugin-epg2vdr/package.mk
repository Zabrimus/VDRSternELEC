# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-epg2vdr"
PKG_VERSION="a9a1bf336317e604ae202494b17ee44dfe69a50c"
PKG_SHA256="a71c32b260f4ed0669d5703d65404dc2195dcfa1da9050a1155374cf0629b8c1"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/horchi/vdr-plugin-epg2vdr"
PKG_URL="https://github.com/horchi/vdr-plugin-epg2vdr/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-epg2vdr-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr Python3 util-linux _mariadb-connector-c _jansson tinyxml2 libarchive vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _mariadb-connector-c"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr Python3 _mariadb-connector-c vdr-helper)"
PKG_LONGDESC="This plugin is used to retrieve EPG data into the VDR. The EPG data was loaded from a mariadb database."
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
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN} epg2vdr

  rm -f ${PKG_DIR}/patches/uint64_t.patch
}
