# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="dash2ts"
PKG_VERSION="34ae8dca106e9d756f7e12c2e2ff68d80df9cb5d"
PKG_SHA256="e7be4938ed73068a89855eb08ec963fbc5934fa47c2b912f665a99da0a747ea2"
PKG_LICENSE="AGPLv3"
PKG_SITE="https://github.com/jojo61/dash2ts"
PKG_URL="https://github.com/jojo61/dash2ts/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain _vdr-plugin-iptv"
PKG_LONGDESC="A Stream Converter for MPD/DASH Streams for VDR, depends on Kodi addon inputstream-adaptive."
PKG_TOOLCHAIN="auto"
PKG_BUILD_FLAGS="+speed"

RT_PREFIX="/usr/local"

pre_make_target() {
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

makeinstall_target() {
	mkdir -p ${INSTALL}/usr/local/bin
	cp ${PKG_BUILD}/build/dash2ts ${INSTALL}/usr/local/bin
}

post_makeinstall_target() {
  # prepare sample archive
  mkdir -p ${INSTALL}/storage/.config/vdropt-sample/plugins/iptv/
  cp -r ${PKG_BUILD}/Test/dashstream.sh ${INSTALL}/storage/.config/vdropt-sample/plugins/iptv/
  cp -r ${PKG_BUILD}/Test/channels.conf ${INSTALL}/storage/.config/vdropt-sample/channels.conf.dash2ts-sample

  # zip everything
  mkdir -p ${INSTALL}/usr/local/config
  cd ${INSTALL}
  	zip -qrum9 ${INSTALL}/usr/local/config/dash2ts-sample-config.zip storage/.config
}
