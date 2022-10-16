# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_triggerhappy"
PKG_VERSION="4866a97e5628f7ad781dd3ae11b2a0f071ca92d8"
PKG_SHA256="f1f070eeabbf62b78e84731f01c0bbfe294beb264f8bff32d51edacc613c6075"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/matt2005/triggerhappy"
PKG_URL="https://github.com/matt2005/triggerhappy/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="triggerhappy-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="A lightweight hotkey daemon"
PKG_TOOLCHAIN="make"

pre_configure_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/local/lib"
}

post_makeinstall_target() {
	PREFIX="/usr/local"

	# copy _system.d folder
    mkdir -p ${INSTALL}/${PREFIX}/config/triggerhappy/system.d
    for i in $(ls ${PKG_DIR}/_system.d/*); do
    	cp ${PKG_DIR}/_system.d/* ${INSTALL}/${PREFIX}/config/triggerhappy/system.d
	done

	# copy _udev.rules.d folder
    mkdir -p ${INSTALL}/${PREFIX}/config/triggerhappy/udev.rules.d
    cp ${PKG_DIR}/_udev.rules.d/* ${INSTALL}/${PREFIX}/config/triggerhappy/udev.rules.d

    # copy trigger-samples
    mkdir -p ${INSTALL}/${PREFIX}/config/triggerhappy/triggers.d
    cp ${PKG_DIR}/trigger-sample/* ${INSTALL}/${PREFIX}/config/triggerhappy/triggers.d
}