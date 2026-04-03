# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team CoreELEC (https://coreelec.org)

PKG_NAME="_entware"
PKG_VERSION="1"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/Entware/Entware"
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_SECTION="tools"
PKG_LONGDESC="entware: A software repository that offers various software programs that can be installed on your device"
PKG_TOOLCHAIN="manual"

make_target() {
  mkdir -p ${INSTALL}
  ln -sf /storage/.opt ${INSTALL}/opt

  mkdir -p ${INSTALL}/usr/sbin
    cp -P ${PKG_DIR}/scripts/installentware ${INSTALL}/usr/sbin

    # Replace distro name
    sed -e "s/@DISTRONAME@/${DISTRONAME}/g" \
        -i ${INSTALL}/usr/sbin/installentware

	if [ ${ARCH} = "aarch64" ]; then
		export ENTWARE_ARCH="aarch64-k3.10"
	elif [ ${ARCH} = "arm" ]; then
		export ENTWARE_ARCH="armv7sf-k3.2"
	elif [ ${ARCH} = "x86_64" ]; then
		export ENTWARE_ARCH="x64-k3.2"
	fi

    # Replace target architecture
    sed -e "s/@ENTWARE_ARCH@/${ENTWARE_ARCH}/g" \
        -i ${INSTALL}/usr/sbin/installentware

  mkdir -p ${INSTALL}/etc/profile.d
  	cp ${PKG_DIR}/profile.d/* ${INSTALL}/etc/profile.d

  mkdir -p ${INSTALL}/usr/lib/systemd/system
  	 cp ${PKG_DIR}/system.d/* ${INSTALL}/usr/lib/systemd/system

  enable_service entware.service
}
