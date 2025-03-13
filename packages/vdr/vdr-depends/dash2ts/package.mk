# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="dash2ts"
PKG_VERSION="a0416e26d03612459575d786f53bc916ce989de3"
PKG_SHA256="a073492228c841245983f2caf27d8d5848920a4eff792e70590832e22b2697eb"
PKG_LICENSE="AGPLv3"
PKG_SITE="https://github.com/jojo61/dash2ts"
PKG_URL="https://github.com/jojo61/dash2ts/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _vdr-plugin-iptv ffmpeg"
PKG_NEED_UNPACK="$(get_pkg_directory kodi)"
PKG_LONGDESC="A Stream Converter for MPD/DASH Streams for VDR, depends on Kodi addon inputstream-adaptive."
PKG_TOOLCHAIN="auto"
PKG_BUILD_FLAGS="+speed"

RT_PREFIX="/usr/local"

pre_make_target() {
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

make_target() {
	KODI_ADDON_INCLUDE=$(get_build_dir kodi)/xbmc/addons/kodi-dev-kit/include make -j
	cd zattoo
	KODI_ADDON_INCLUDE=$(get_build_dir kodi)/xbmc/addons/kodi-dev-kit/include make -j
}

makeinstall_target() {
	mkdir -p ${INSTALL}/usr/local/bin
	cp ${PKG_BUILD}/build/dash2ts ${INSTALL}/usr/local/bin
	cp ${PKG_BUILD}/zattoo/build/zattoostream ${INSTALL}/usr/local/bin
	cp ${PKG_BUILD}/zattoo/build/zattood ${INSTALL}/usr/local/bin
}

post_makeinstall_target() {
  # prepare sample archive
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/iptv/
  mkdir -p ${INSTALL}/storage/.config/system.d/

  cp -r ${PKG_BUILD}/Test/orfstream.sh ${INSTALL}/storage/.config/vdropt-sample/plugins/iptv/
  cp -r ${PKG_BUILD}/zattoo/Test/zattoostream.sh ${INSTALL}/storage/.config/vdropt-sample/plugins/iptv/
  cp -r ${PKG_BUILD}/Test/channels.conf ${INSTALL}/storage/.config/vdropt-sample/channels.conf.dash2ts-sample
  cp -r ${PKG_BUILD}/zattoo/Test/zattood.service.sample ${INSTALL}/storage/.config/system.d/

  # zip everything
  mkdir -p ${INSTALL}/usr/local/config
  cd ${INSTALL}
  	zip -qrum9 ${INSTALL}/usr/local/config/dash2ts-sample-config.zip storage/.config
}
