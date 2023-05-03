# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-epg2vdr"
PKG_VERSION="189871b8c840a3b07587ae9b2b504c7ed4095aff"
PKG_SHA256="f1b977c0f88d14997aa48b545c452cb621bc39e8f6eb939fd469998fa18e1131"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/horchi/vdr-plugin-epg2vdr"
PKG_URL="https://github.com/horchi/vdr-plugin-epg2vdr/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-epg2vdr-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr Python3 util-linux _mariadb-connector-c _jansson tinyxml2 libarchive"
PKG_DEPENDS_CONFIG="_vdr _mariadb-connector-c"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory Python3) $(get_pkg_directory _mariadb-connector-c)"
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
  zip -qrum9 "${INSTALL}/usr/local/config/epg2vdr-sample-config.zip" storage

  rm -f ${PKG_DIR}/patches/uint64_t.patch
}
