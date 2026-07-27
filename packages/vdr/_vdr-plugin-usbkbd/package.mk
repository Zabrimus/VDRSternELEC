# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-usbkbd"
PKG_VERSION="abfd8d45d8e2d567f6201861efeffb767a1e8c3e"
PKG_SHA256="784582db5b2b4c85aaf8209fc95f38c0cf3e0ed1aa7574b95b5edafd0c4a1952"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/j1rie/vdr-plugin-usbkbd"
PKG_URL="https://github.com/j1rie/vdr-plugin-usbkbd/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="vdr-plugin-usbkbd-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr vdr-helper"
PKG_DEPENDS_CONFIG="_vdr"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr) $(get_pkg_directory vdr-helper)"
PKG_DEPENDS_UNPACK="vdr-helper"
PKG_LONGDESC="The usbkbd plugin sends keypresses from an USB keyboard to VDR. Even when X is active."
PKG_BUILD_FLAGS="+speed"

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export VDRDIR=$(get_install_dir _vdr)/usr/local/lib/pkgconfig
}

post_makeinstall_target() {
  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}

  rm -rf ${INSTALL}/usr/lib/udev/rules.d
  	mkdir -p ${INSTALL}/usr/lib/udev/rules.d
    cp -PR ${PKG_DIR}/_udev.d/*.rules ${INSTALL}/usr/lib/udev/rules.d
}
