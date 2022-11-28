# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-epg2vdr"
PKG_VERSION="c2a373bb23540a037dbc3969c3995d76e233a931"
PKG_SHA256="2f1b1e6189bc9060920cf05fd918432a4c59ab66efee1768c0d91cdcc83ecfc0"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/horchi/vdr-plugin-epg2vdr"
PKG_URL="https://github.com/horchi/vdr-plugin-epg2vdr/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-epg2vdr-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr Python3 util-linux _mariadb-connector-c _jansson tinyxml2 libarchive"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory Python3) $(get_pkg_directory _mariadb-connector-c)"
PKG_LONGDESC="This plugin is used to retrieve EPG data into the VDR. The EPG data was loaded from a mariadb database."
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
  zip -qrum9 "${INSTALL}/usr/local/config/epg2vdr-sample-config.zip" storage

  rm -f ${PKG_DIR}/patches/uint64_t.patch
}
