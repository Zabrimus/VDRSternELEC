# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_tsduck"
PKG_VERSION="v3.37-3670"
PKG_SHA256="dbb7c654330108c509f2d8a97fe0346e3a1f55ad959e13dcee4a40dd04507886"
PKG_LICENSE="BSD-2-Clause license "
PKG_SITE="https://tsduck.io/"
PKG_URL="https://github.com/tsduck/tsduck/archive/refs/tags/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain _tsduck:host"
PKG_DEPENDS_HOST="gcc:host"
PKG_LONGDESC="The MPEG Transport Stream Toolkit"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

make_host() {
  make -j NOTEST=1 \
          NODTAPI=1 \
          NODEKTEC=1 \
          NOHIDES=1 \
          NOVATEK=1 \
          NOPCSC=1 \
          NOEDITLINE=1 \
          NOGITHUB=1 \
          NOJAVA=1 \
          NODOXYGEN=1 \
          BINDIR=$(get_build_dir _tsduck)/native
}

makeinstall_host() {
	:
}

make_target() {

  if [ ${ARCH} = "aarch64" ]; then
  	export CXXFLAGS_EXTRA="-mno-outline-atomics"
  fi

  mkdir -p $(get_install_dir _tsduck)/usr/bin

  make -j NOTEST=1 \
          NODTAPI=1 \
          NODEKTEC=1 \
          NOHIDES=1 \
          NOVATEK=1 \
          NOPCSC=1 \
          NOEDITLINE=1 \
          NOGITHUB=1 \
          NOJAVA=1 \
          NODOXYGEN=1 \
          NATIVEBINDIR=$(get_build_dir _tsduck)/native \
          CROSS_PREFIX=${TOOLCHAIN} \
          CROSS_TARGET=$(basename ${CC} | sed -e "s/-gcc//") \
          SYSROOT=$(get_install_dir _tsduck) \
          cross install
}

makeinstall_target() {
	:
}