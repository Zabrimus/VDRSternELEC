# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-epg2vdr"
PKG_VERSION="189871b8c840a3b07587ae9b2b504c7ed4095aff"
PKG_SHA256="f1b977c0f88d14997aa48b545c452cb621bc39e8f6eb939fd469998fa18e1131"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/horchi/vdr-plugin-epg2vdr"
PKG_URL="https://github.com/horchi/vdr-plugin-epg2vdr/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-epg2vdr-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr Python3 util-linux _mariadb-connector-c _jansson tinyxml2 libarchive vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _mariadb-connector-c"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr Python3 _mariadb-connector-c vdr-helper)"
PKG_LONGDESC="This plugin is used to retrieve EPG data into the VDR. The EPG data was loaded from a mariadb database."

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
