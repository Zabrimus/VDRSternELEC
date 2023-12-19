# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vtuner-ng"
PKG_VERSION="18f22fa9be5ea07a839bbddd3a3f9c152e49a981"
PKG_SHA256="4fc8009bdf253c9485ed37a862305f211622fc6ba7d47eb6f1fe320860098f1d"
PKG_LICENSE=""
PKG_SITE="https://github.com/joed74/vtuner-ng"
PKG_URL="https://github.com/joed74/vtuner-ng/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain linux"
PKG_NEED_UNPACK="$LINUX_DEPENDS"
PKG_SOURCE_DIR="vtuner-ng-${PKG_VERSION}"
PKG_IS_KERNEL_PKG="yes"
PKG_LONGDESC="Virtualized DVB driver"
PKG_TOOLCHAIN="make"
PKG_BUILD_FLAGS="+speed"

make_target() {
    # build kernel module
	kernel_make KDIR=$(kernel_path) -C $(kernel_path) M=${PKG_BUILD}/kernel

	# build satip
	make -C satip
}

makeinstall_target() {
  # install kernel module
  mkdir -p ${INSTALL}/$(get_full_module_dir)/${PKG_NAME}
    cp kernel/*.ko ${INSTALL}/$(get_full_module_dir)/${PKG_NAME}

  # install satip
  mkdir -p ${INSTALL}/usr/local/bin
  	cp satip/satip ${INSTALL}/usr/local/bin
}