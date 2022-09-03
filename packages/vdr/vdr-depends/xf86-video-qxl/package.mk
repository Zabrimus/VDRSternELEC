# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Stephan Raue (stephan@openelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="xf86-video-qxl"
PKG_VERSION="0.1.5"
PKG_SHA256="dd25c4e76211c293d2edf890fdb82b4e82aacd9fca6bb241409d0c5028cc1a83"
PKG_ARCH="x86_64"
PKG_LICENSE="OSS"
PKG_SITE="https://www.x.org"
PKG_URL="https://www.x.org/releases/individual/driver/xf86-video-qxl-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain libdrm xorg-server _spice_vd_agent _spice-protocol"
PKG_LONGDESC="Xorg driver for KVM QXL GPUs using the qxl kernel driver."
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-udev \
                           --enable-glamor \
                           --with-xorg-module-dir=${XORG_PATH_MODULES}"

#post_makeinstall_target() {
#  rm -r ${INSTALL}/usr/share
#  mkdir -p ${INSTALL}/etc/X11
#    cp ${PKG_BUILD}/conf/10-amdgpu.conf ${INSTALL}/etc/X11/xorg-amdgpu.conf
#}
