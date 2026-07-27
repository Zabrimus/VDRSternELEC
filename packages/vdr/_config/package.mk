# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011 Anthony Nash (nash.ant@gmail.com)
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_config"
PKG_VERSION="1.0.0"
PKG_SHA256=""
PKG_LICENSE="GPL"
PKG_SITE=""
PKG_URL=""
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="Common configuration for VDR*ELEC"
PKG_TOOLCHAIN="manual"

makeinstall_target() {
	mkdir -p ${INSTALL}/usr/local/bin
	mkdir -p ${INSTALL}/usr/local/config

	CONFDIR="/storage/.config/vdropt"
    LDPRELOADMALI=""

    if [ "${PROJECT}" = "Amlogic-ce" ]; then
    	LDPRELOADMALI="/usr/lib/libMali.so"
	fi

    SED_SCRIPT="s#XXLDPRELOADMALIXX#${LDPRELOADMALI}#"
    cat ${PKG_DIR}/bin/start_vdr.sh | sed "${SED_SCRIPT}" > ${INSTALL}/usr/local/bin/start_vdr.sh
    cat ${PKG_DIR}/bin/start_vdr_easy.sh | sed "${SED_SCRIPT}" > ${INSTALL}/usr/local/bin/start_vdr_easy.sh

    cp ${PKG_DIR}/bin/easyvdrctl.sh ${INSTALL}/usr/local/bin/easyvdrctl.sh
    cp ${PKG_DIR}/bin/install.sh ${INSTALL}/usr/local/bin/install.sh
    cp ${PKG_DIR}/bin/switch_kodi_vdr.sh ${INSTALL}/usr/local/bin/switch_kodi_vdr.sh
    cp ${PKG_DIR}/bin/vdrsternupgrade.sh ${INSTALL}/usr/local/bin/vdrsternupgrade.sh
    cp ${PKG_DIR}/bin/switch_to_vdr.sh ${INSTALL}/usr/local/bin/switch_to_vdr.sh
    cp ${PKG_DIR}/bin/switch_vdr_softhdodroid.sh ${INSTALL}/usr/local/bin/switch_vdr_softhdodroid.sh
    cp ${PKG_DIR}/bin/switch_kodi_vdr.sh ${INSTALL}/usr/local/bin/switch_kodi_vdr.sh
    cp ${PKG_DIR}/bin/setup_bl301.sh ${INSTALL}/usr/local/bin/setup_bl301.sh
    cp ${PKG_DIR}/bin/ClearOSD.sh ${INSTALL}/usr/local/bin/ClearOSD.sh
    cp ${PKG_DIR}/bin/VDRCoreELEC.sh ${INSTALL}/usr/local/bin/VDRCoreELEC.sh

	# copy system.d folder
    mkdir -p ${INSTALL}/usr/local/system.d
    cp ${PKG_DIR}/_system.d/* ${INSTALL}/usr/local/system.d

    # copy sysctl.d folder
    mkdir -p ${INSTALL}/usr/local/sysctl.d
    cp ${PKG_DIR}/_sysctl.d/* ${INSTALL}/usr/local/sysctl.d

    chmod +x ${INSTALL}/usr/local/bin/*.sh

    # copy and enable services
    mkdir -p ${INSTALL}/usr/lib/systemd/system
    cp ${PKG_DIR}/system.d/VDRCoreELEC.service ${INSTALL}/usr/lib/systemd/system

    enable_service VDRCoreELEC.service

	# copy sample XML (PowerMenu for Kodi which includes a Button to switch to VDR)
  	cp ${PKG_DIR}/config/DialogButtonMenu.xml ${INSTALL}/usr/local/config/DialogButtonMenu.xml

  	# create release links
  	mkdir -p ${INSTALL}/etc
  	rm -f stern_upgrade_links
	echo "STERN_RELEASE=${STERN_RELEASE}" > ${INSTALL}/etc/stern_upgrade_links
    echo "STERN_ADDON=${STERN_ADDON}" >> ${INSTALL}/etc/stern_upgrade_links

    # copy scripts
    mkdir -p ${INSTALL}/storage/.config/vdropt-sample
    cp ${PKG_DIR}/scripts/* ${INSTALL}/storage/.config/vdropt-sample

    mkdir -p ${INSTALL}/usr/local/config
    cd ${INSTALL}
    zip -qrum9 ${INSTALL}/usr/local/config/common-sample-config.zip storage
}
