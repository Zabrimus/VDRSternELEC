# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2011 Anthony Nash (nash.ant@gmail.com)
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_vdr"
PKG_VERSION="2.7.7"
PKG_SHA256="f0d8d30b6a8012f6838eaaf9c337b7352bfac67f1cea6342b9c685e8df88c856"
PKG_LICENSE="GPL"
PKG_SITE="http://www.tvdr.de"
PKG_URL="http://git.tvdr.de/?p=vdr.git;a=snapshot;h=refs/tags/${PKG_VERSION};sf=tbz2"
PKG_SOURCE_NAME="${PKG_NAME}-${PKG_VERSION}.tar.bz2"
PKG_DEPENDS_TARGET="toolchain bzip2 fontconfig freetype libcap libiconv libjpeg-turbo"
PKG_LONGDESC="A DVB TV server application."
PKG_BUILD_FLAGS="+speed"

post_unpack() {
  rm -rf ${PKG_BUILD}/PLUGINS/src/skincurses
  rm -f ${PKG_DIR}/patches/vdr-2.*-dynamite.patch
  rm -f ${PKG_DIR}/patches/vdr-plugin-easyvdr.patch
  rm -f ${PKG_DIR}/patches/vdr-2.6-patch-for-permashift.patch

  if [ "${EXTRA_EASYVDR}" = "y" ]; then
  	cp ${PKG_DIR}/optional/vdr-plugin-easyvdr.patch ${PKG_DIR}/patches/vdr-plugin-easyvdr.patch
  fi

  if [ "${EXTRA_DYNAMITE}" = "y" ]; then
  	cp ${PKG_DIR}/optional/vdr-2.7.6-dynamite.patch ${PKG_DIR}/patches/vdr-2.7.6-dynamite.patch
  fi

  if [ "${EXTRA_PERMASHIFT}" = "y" ]; then
  	cp ${PKG_DIR}/optional/vdr-2.6-patch-for-permashift.patch ${PKG_DIR}/patches/vdr-2.6-patch-for-permashift.patch
  fi
}

pre_make_target() {
  export LDFLAGS="$(echo ${LDFLAGS} | sed -e "s|-Wl,--as-needed||") -L${SYSROOT_PREFIX}/usr/lib/iconv -liconv"
  export PKG_CONFIG_DISABLE_SYSROOT_PREPEND="yes"

  cat > Make.config <<EOF
CFLAGS += -O3
CXXFLAGS += -O3
PREFIX = /usr/local
VIDEODIR = /storage/videos
CONFDIR = /storage/.config/vdropt
LIBDIR = /usr/local/lib/vdr
LOCDIR = /usr/local/vdrshare/locale
RESDIR = /storage/.config/vdropt
CACHEDIR = /storage/.cache/vdr
LIBS += -liconv
VDR_USER=root

EOF
}

post_makeinstall_target() {
  CONFDIR="/storage/.config/vdropt"
  mkdir -p ${INSTALL}/usr/local/bin

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

  cp ${PKG_DIR}/config/commands.conf ${VDR_DIR}/storage/.config/vdropt-sample/commands.conf

  # rename perl svdrpsend to svdrpsend.pl and copy the netcat variant
  mv ${INSTALL}/usr/local/bin/svdrpsend ${INSTALL}/usr/local/bin/svdrpsend.pl
  cp ${PKG_DIR}/bin/svdrpsend ${INSTALL}/usr/local/bin/svdrpsend

  chmod +x ${INSTALL}/usr/local/bin/*

  # create config.zip
  mkdir -p ${INSTALL}/usr/local/config
  cd ${INSTALL}
  zip -qrum9 ${INSTALL}/usr/local/config/vdr-sample-config.zip storage

  rm -f ${PKG_DIR}/patches/vdr-2.*-dynamite.patch
  rm -f ${PKG_DIR}/patches/vdr-plugin-easyvdr.patch
  rm -f ${PKG_DIR}/patches/vdr-2.6-patch-for-permashift.patch
}