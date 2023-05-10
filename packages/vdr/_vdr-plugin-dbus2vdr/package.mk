# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vdr-plugin-dbus2vdr"
PKG_VERSION="119b4e8f02b39d37af6d41365208cc44e8cd986d"
PKG_SHA256="f34197b71f402d19effa2847fce3872dad1aff0aa321aa129e40f86f659b7ba2"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/flensrocker/vdr-plugin-dbus2vdr"
PKG_URL="https://github.com/flensrocker/vdr-plugin-dbus2vdr/archive/${PKG_VERSION}.zip"
PKG_BRANCH="master"
PKG_SOURCE_DIR="vdr-plugin-dbus2vdr-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _vdr _libpngpp dbus glib libjpeg-turbo vdr-helper"
PKG_DEPENDS_CONFIG="_vdr _libpngpp"
PKG_NEED_UNPACK="$(get_pkg_directory _vdr _libpngpp vdr-helper)"
PKG_LONGDESC="This plugin will expose some methods via DBus to control the vdr."

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"
  export CPLUS_INCLUDE_PATH=$(get_build_dir _libpngpp)
}

post_makeinstall_target() {
  # remove unneeded
  rm -Rf ${INSTALL}/etc/init

  # move other files
  mkdir -p ${INSTALL}/usr/local/bin
  mv ${INSTALL}/usr/share/vdr-plugin-dbus2vdr/* ${INSTALL}/usr/local/bin
  cp $(get_pkg_directory _vdr-plugin-dbus2vdr)/config/vdr-dbus-send.sh ${INSTALL}/usr/local/bin

  cp $(get_pkg_directory _vdr-plugin-dbus2vdr)/config/de.tvdr.vdr.conf ${INSTALL}/etc/dbus-1/system.d/de.tvdr.vdr.conf

  PLUGIN="$(cat ${PKG_BUILD}/Makefile | grep 'PLUGIN = ' | cut -d ' ' -f 3)"
  $(get_build_dir vdr-helper)/zip_config.sh ${INSTALL} ${PKG_DIR} ${PLUGIN}
}
