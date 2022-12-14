# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011 Anthony Nash (nash.ant@gmail.com)
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_vdr"
PKG_VERSION="2.6.3"
PKG_SHA256="3db99b7ebbc0a60b72b191785af27efd49385bd08ef9fb7a8a83694323954ccf"
PKG_LICENSE="GPL"
PKG_SITE="http://www.tvdr.de"
PKG_URL="http://git.tvdr.de/?p=vdr.git;a=snapshot;h=refs/tags/${PKG_VERSION};sf=tbz2"
PKG_SOURCE_NAME="${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain bzip2 fontconfig freetype libcap libiconv libjpeg-turbo"
PKG_LONGDESC="A DVB TV server application."
PKG_TOOLCHAIN="manual"

post_unpack() {
  rm -rf ${PKG_BUILD}/PLUGINS/src/skincurses
  rm -f ${PKG_DIR}/patches/vdr-2.4.6-dynamite.patch
  rm -f ${PKG_DIR}/patches/vdr-plugin-easyvdr.patch
  rm -f ${PKG_DIR}/patches/vdr-2.6-patch-for-permashift.patch

  if [ "${EXTRA_EASYVDR}" = "y" ]; then
  	cp ${PKG_DIR}/optional/vdr-plugin-easyvdr.patch ${PKG_DIR}/patches/vdr-plugin-easyvdr.patch
  fi

  if [ "${EXTRA_DYNAMITE}" = "y" ]; then
  	cp ${PKG_DIR}/optional/vdr-2.4.6-dynamite.patch ${PKG_DIR}/patches/vdr-2.4.6-dynamite.patch
  fi

  if [ "${EXTRA_PERMASHIFT}" = "y" ]; then
  	cp ${PKG_DIR}/optional/vdr-2.6-patch-for-permashift.patch ${PKG_DIR}/patches/vdr-2.6-patch-for-permashift.patch
  fi
}

pre_configure_target() {
  # test if prefix is set
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/lib/iconv -liconv"
}

pre_make_target() {
  PREFIX="/usr/local/"

  cat > Make.config <<EOF
PREFIX = ${PREFIX}
VIDEODIR = /storage/videos
CONFDIR = /storage/.config/vdropt
LIBDIR = ${PREFIX}/lib/vdr
LOCDIR = ${PREFIX}/vdrshare/locale
RESDIR = /storage/.config/vdropt
CACHEDIR = /storage/.cache/vdr
LIBS += -liconv
VDR_USER=root
EOF

  # Ein ganz übler Hack. Es ist nicht gelungen pkg-config zu überreden, bei --cflags oder --libs (aber nur nur bei bestimmten Libs),
  # nicht(!) den Wert */sysroot/opt/vdr/opt/vdr zurückzugeben, den es eigentlich nicht geben darf und der beim compile und beim linken
  # ziemliche Problem macht.
  mkdir -p ${SYSROOT_PREFIX}/usr/local/opt
  cd ${SYSROOT_PREFIX}/usr/local/opt
  ln -f -s ../../vdr/ vdr
  cd $(get_build_dir _vdr)
}

make_target() {
  make vdr vdr.pc
}

makeinstall_target() {
  PREFIX="/usr/local"
  CONFDIR="/storage/.config/vdropt"
  LDPRELOADMALI=""

  if [ "${PROJECT}" = "Amlogic-ce" ]; then
     LDPRELOADMALI="/usr/lib/libMali.so"
  fi

  make DESTDIR="${INSTALL}" install

  SED_SCRIPT="s#XXCONFDIRXX#${CONFDIR}# ; s#XXBINDIRXX#${PREFIX}/bin# ; s#XXVERSIONXX#${PKG_VERSION}# ; s#XXLIBDIRXX#${PREFIX}/lib# ; s#XXPREFIXXX#${PREFIX}# ; s#XXPREFIXCONFXX#${PREFIX}/config# ; s#XXLDPRELOADMALIXX#${LDPRELOADMALI}#"

  cat ${PKG_DIR}/bin/start_vdr.sh | sed "${SED_SCRIPT}" > ${INSTALL}/${PREFIX}/bin/start_vdr.sh
  chmod +x ${INSTALL}/${PREFIX}/bin/start_vdr.sh

  cat ${PKG_DIR}/bin/start_vdr_easy.sh | sed "${SED_SCRIPT}" > ${INSTALL}/${PREFIX}/bin/start_vdr_easy.sh
  chmod +x ${INSTALL}/${PREFIX}/bin/start_vdr_easy.sh

  cat ${PKG_DIR}/bin/easyvdrctl.sh | sed "${SED_SCRIPT}" > ${INSTALL}/${PREFIX}/bin/easyvdrctl.sh
  chmod +x ${INSTALL}/${PREFIX}/bin/easyvdrctl.sh

  cat ${PKG_DIR}/bin/install.sh | sed "${SED_SCRIPT}" > ${INSTALL}/${PREFIX}/bin/install.sh
  chmod +x ${INSTALL}/${PREFIX}/bin/install.sh

  cat ${PKG_DIR}/bin/switch_kodi_vdr.sh | sed "${SED_SCRIPT}" > ${INSTALL}/${PREFIX}/bin/switch_kodi_vdr.sh
  chmod +x ${INSTALL}/${PREFIX}/bin/switch_kodi_vdr.sh

  # Create start parameters depending on the project
  cat<<EOF >> ${INSTALL}/${PREFIX}/bin/switch_kodi_vdr.sh
  if [ "\${START_PRG}" = "vdr" ]; then
    systemctl stop kodi

	if [ ! -z \${SWITCH_VDR_SCRIPT} ]; then
   	  eval \${SWITCH_VDR_SCRIPT} attach
	else
   	  systemctl start vdropt
	fi
  elif [ "\${START_PRG}" = "kodi" ]; then
	if [ ! -z \${SWITCH_VDR_SCRIPT} ]; then
   	  eval \${SWITCH_VDR_SCRIPT} detach
	else
   	  systemctl stop vdropt
	fi

    systemctl start kodi
  fi
EOF

  cp ${PKG_DIR}/bin/switch_to_vdr.sh ${INSTALL}/${PREFIX}/bin/switch_to_vdr.sh
  chmod +x ${INSTALL}/${PREFIX}/bin/switch_to_vdr.sh

  cp ${PKG_DIR}/bin/autostart.sh ${INSTALL}/${PREFIX}/bin/autostart.sh
  chmod +x ${INSTALL}/${PREFIX}/bin/autostart.sh

  cp ${PKG_DIR}/bin/switch_vdr_softhdodroid.sh ${INSTALL}/${PREFIX}/bin/switch_vdr_softhdodroid.sh
  chmod +x ${INSTALL}/${PREFIX}/bin/switch_vdr_softhdodroid.sh

  # Create start parameters depending on the project
  cat<<EOF >> ${INSTALL}/${PREFIX}/bin/autostart.sh
  if [ "\${START_PRG}" = "vdr" ]; then
    systemctl stop kodi
    if [ "${PROJECT}" = "Amlogic-ce" ]; then
      echo 4 > /sys/module/amvdec_h264/parameters/dec_control
    fi
    systemctl start vdropt
  fi
EOF

  # rename perl svdrpsend to svdrpsend.pl and copy the netcat variant
  mv ${INSTALL}/${PREFIX}/bin/svdrpsend ${INSTALL}/${PREFIX}/bin/svdrpsend.pl
  cp ${PKG_DIR}/bin/svdrpsend ${INSTALL}/${PREFIX}/bin/svdrpsend

  # copy system.d folder
  mkdir -p ${INSTALL}/${PREFIX}/system.d
  for i in $(ls ${PKG_DIR}/_system.d/*); do
     cat ${i} | sed "${SED_SCRIPT}" > ${INSTALL}/${PREFIX}/system.d/$(basename $i)
  done

  # copy sysctl.d folder
  mkdir -p ${INSTALL}/${PREFIX}/sysctl.d
  cp ${PKG_DIR}/_sysctl.d/* ${INSTALL}/${PREFIX}/sysctl.d
}

post_makeinstall_target() {
  PREFIX="/usr/local"
  VDR_DIR=$(get_install_dir _vdr)

  # move configuration to another folder to prevent overwriting existing configuration after installation
  mv ${VDR_DIR}/storage/.config/vdropt ${VDR_DIR}/storage/.config/vdropt-sample

  mkdir -p ${VDR_DIR}/storage/.config/vdropt-sample/conf.d
  cp -PR ${PKG_DIR}/conf.d/* ${VDR_DIR}/storage/.config/vdropt-sample/conf.d/

  cat >> ${VDR_DIR}/storage/.config/vdropt-sample/enabled_plugins <<EOF
${VDR_OUTPUTDEVICE}
${VDR_INPUTDEVICE}
EOF

  if find ${INSTALL}/storage/.config/vdropt -mindepth 1 -maxdepth 1 2>/dev/null | read; then
     cp -ar ${INSTALL}/storage/.config/vdropt/* ${INSTALL}/storage/.config/vdropt-sample
     rm -Rf ${INSTALL}/storage/.config/vdropt
  fi

  cat ${PKG_DIR}/config/commands.conf | sed "s#XXBINDIRXX#${PREFIX}/bin#" > ${VDR_DIR}/storage/.config/vdropt-sample/commands.conf

  # create config.zip
  mkdir -p ${INSTALL}${PREFIX}/config
  cd ${INSTALL}
  zip -qrum9 ${INSTALL}${PREFIX}/config/vdr-sample-config.zip storage

  # copy sample XML (PowerMenu for Kodi which includes a Button to switch to VDR)
  cat ${PKG_DIR}/config/DialogButtonMenu.xml | sed "s#XXBINDIRXX#${PREFIX}/bin#" > ${INSTALL}/${PREFIX}/config/DialogButtonMenu.xml

  rm -f ${PKG_DIR}/patches/vdr-2.4.6-dynamite.patch
  rm -f ${PKG_DIR}/patches/vdr-plugin-easyvdr.patch
  rm -f ${PKG_DIR}/patches/vdr-2.6-patch-for-permashift.patch
}
