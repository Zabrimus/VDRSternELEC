# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="incus"
PKG_VERSION="6.0.0"
PKG_ADDON_VERSION="6.0.0-1"
PKG_SHA256="0e7f7de3a61a2ca33ad8f04c4e37fe9eaa0c775de3723dc43cebafdea029f000"
PKG_LICENSE="GPL"
PKG_SITE="https://github.com/lxc/incus"
PKG_URL="https://github.com/lxc/incus/archive/refs/tags/v${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain go:host _cowsql _libacl _lxc _lxcfs _squashfs-tools _tar _dnsmasq libseccomp"
PKG_SOURCE_DIR="incus-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_SECTION="tools"
PKG_LONGDESC="Powerful system container and virtual machine manager"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed -sysroot"

PKG_IS_ADDON="yes"
PKG_SECTION="service"
PKG_ADDON_NAME="incus"
PKG_ADDON_TYPE="xbmc.service"

pre_configure_target() {
    export CFLAGS="$(echo ${CFLAGS} -Wno-use-after-free)"
}

make_target() {
    go_configure

	export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:$(get_install_dir _lxc)/storage/.kodi/addons/service.incus/lib/pkgconfig"
	export PKG_CONFIG_PATH="${PKG_CONFIG_PATH}:$(get_install_dir libseccomp)/usr/lib/pkgconfig"

	export CGO_CFLAGS="${CGO_CFLAGS} -I$(get_install_dir _cowsql)/usr/include -I$(get_install_dir _raft)/usr/include -I$(get_install_dir _libacl)/usr/include -I$(get_install_dir _lxc)/storage/.kodi/addons/service.incus/include"

	export CGO_LDFLAGS="${CGO_LDFLAGS} -L$(get_install_dir libseccomp)/usr/lib -lseccomp"
	export CGO_LDFLAGS="${CGO_LDFLAGS} -L$(get_install_dir _libacl)/usr/lib -lacl"
	export CGO_LDFLAGS="${CGO_LDFLAGS} -L$(get_install_dir _cowsql)/usr/lib -lcowsql"
	export CGO_LDFLAGS="${CGO_LDFLAGS} -L$(get_install_dir _raft)/usr/lib -lraft"
	export CGO_LDFLAGS="${CGO_LDFLAGS} -L$(get_install_dir _lxc)/storage/.kodi/addons/service.incus/lib -llxc"
	export CGO_LDFLAGS="${CGO_LDFLAGS} -L$(get_install_dir _lxcfs)/storage/.kodi/addons/service.incus/lib/lxcfs -llxcfs"

    GO=${GOLANG} make  # SHELL='sh -x'
}

makeinstall_target() {
    :
}

addon() {
  go_configure

  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/lib
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/data
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/etc
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/system.d

  # copy cowsql
  cp -a $(get_install_dir _cowsql)/usr/lib/libcowsql.so* \
  		${ADDON_BUILD}/${PKG_ADDON_ID}/lib

  # copy raft
  cp -a $(get_install_dir _raft)/usr/lib/libraft.so* \
  		${ADDON_BUILD}/${PKG_ADDON_ID}/lib

  # copy zstd
  cp -a $(get_install_dir _zstd)/usr/local/lib/libzstd.so* \
  		${ADDON_BUILD}/${PKG_ADDON_ID}/lib

  cp -a $(get_install_dir _zstd)/usr/local/bin/* \
		${ADDON_BUILD}/${PKG_ADDON_ID}/bin

  # copy libseccomp
  cp -a $(get_install_dir libseccomp)/usr/lib/libseccomp.so* \
  		${ADDON_BUILD}/${PKG_ADDON_ID}/lib

  cp -a $(get_install_dir libseccomp)/usr/bin/* \
		${ADDON_BUILD}/${PKG_ADDON_ID}/bin

  # copy lxc
  cp -ar $(get_install_dir _lxc)/storage/.kodi/addons/service.incus/* \
  		 ${ADDON_BUILD}/${PKG_ADDON_ID}
  cp -a  $(get_install_dir _lxc)/usr/lib/systemd/system/* \
         ${ADDON_BUILD}/${PKG_ADDON_ID}/system.d
  rm -rf ${ADDON_BUILD}/${PKG_ADDON_ID}/include
  rm -rf ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/pkgconfig
  rm -rf ${ADDON_BUILD}/${PKG_ADDON_ID}/lib/*.a

  # copy lxcfs
  cp -ar $(get_install_dir _lxcfs)/storage/.kodi/addons/service.incus/data/* \
  		 ${ADDON_BUILD}/${PKG_ADDON_ID}/data
  cp -ar $(get_install_dir _lxcfs)/storage/.kodi/addons/service.incus/bin/* \
  		 ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  cp -ar $(get_install_dir _lxcfs)/storage/.kodi/addons/service.incus/lib/lxcfs/* \
   		 ${ADDON_BUILD}/${PKG_ADDON_ID}/lib
  cp -a  $(get_install_dir _lxcfs)/usr/lib/systemd/system/* \
         ${ADDON_BUILD}/${PKG_ADDON_ID}/system.d

  # copy squashfs
  cp -a $(get_build_dir _squashfs-tools)/squashfs-tools/mksquashfs \
  		${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  cp -a $(get_build_dir _squashfs-tools)/squashfs-tools/unsquashfs \
        ${ADDON_BUILD}/${PKG_ADDON_ID}/bin

  # copy fuse3
  cp -a $(get_install_dir fuse3)/usr/lib/*.so* \
    	${ADDON_BUILD}/${PKG_ADDON_ID}/lib
  cp -a $(get_install_dir fuse3)/usr/bin/* \
    	${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  cp -a $(get_install_dir fuse3)/usr/sbin/* \
    	${ADDON_BUILD}/${PKG_ADDON_ID}/bin

  # copy tar
  cp -a $(get_install_dir _tar)/usr/bin/tar \
        ${ADDON_BUILD}/${PKG_ADDON_ID}/bin

  # copy dnsmasq
  cp -a $(get_install_dir _dnsmasq)/usr/local/sbin/* \
        ${ADDON_BUILD}/${PKG_ADDON_ID}/bin

  # copy incus
  cp -a $(get_build_dir incus)/.gopath/bin/linux_${TARGET_KERNEL_ARCH}/* \
        ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
}
