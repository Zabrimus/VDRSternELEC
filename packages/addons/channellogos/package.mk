# SPDX-License-Identifier: GPL-2.0-or-later

. $(get_pkg_directory _MP_Logos)/package.mk

PKG_NAME="channellogos"
PKG_URL=""
PKG_DEPENDS_UNPACK+=" _MP_Logos"
PKG_BUILD_FLAGS="-sysroot"
PKG_SOURCE_DIR=""
PKG_DEPENDS_TARGET+=" _symlinks:host"

PKG_REV="1"
PKG_IS_ADDON="yes"
PKG_ADDON_NAME="channellogos"
PKG_ADDON_TYPE="xbmc.service"

unpack() {
  mkdir -p ${PKG_BUILD}

  SRC_PART="${SOURCES}/_MP_Logos/_MP_Logos-${PKG_VERSION}"

  if [ -f "${SRC_PART}.tar.xz" ]; then
	tar --strip-components=1 -xf ${SOURCES}/_MP_Logos/_MP_Logos-${PKG_VERSION}.xz -C ${PKG_BUILD}
  elif [ -f "${SRC_PART}.tar.gz" ]; then
	tar --strip-components=1 -xf ${SOURCES}/_MP_Logos/_MP_Logos-${PKG_VERSION}.gz -C ${PKG_BUILD}
  elif [ -f "${SRC_PART}.zip" ]; then
  	unzip ${SRC_PART}.zip -d ${PKG_BUILD}

	mv ${PKG_BUILD}/MP_Logos-${PKG_VERSION}/* ${PKG_BUILD}
	rm -Rf ${PKG_BUILD}/MP_Logos-${PKG_VERSION}
  else
	tar --strip-components=1 -xf ${SRC_PART}.tar.bz2 -C ${PKG_BUILD}
  fi
}

addon() {
	# create directories
  	mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/logofiles
  	cp -a $(get_install_dir _mediaportal-de-logos)/usr/local/vdrshare/logofiles/* ${ADDON_BUILD}/${PKG_ADDON_ID}/logofiles

	INSTALLDIR="$(get_install_dir _mediaportal-de-logos)/usr/local/vdrshare/logofiles"
	ADDONDIR="${ADDON_BUILD}/${PKG_ADDON_ID}"

	# convert all absolute links to relative links
	(
		cd $(get_install_dir _mediaportal-de-logos)/usr/local/vdrshare/logosDark
		$(get_build_dir _symlinks)/symlinks -rc .

		cd $(get_install_dir _mediaportal-de-logos)/usr/local/vdrshare/logosLight
		$(get_build_dir _symlinks)/symlinks -rc .
	)

	cp -a $(get_install_dir _mediaportal-de-logos)/usr/local/vdrshare/logosDark ${ADDON_BUILD}/${PKG_ADDON_ID}
	cp -a $(get_install_dir _mediaportal-de-logos)/usr/local/vdrshare/logosLight ${ADDON_BUILD}/${PKG_ADDON_ID}
}
