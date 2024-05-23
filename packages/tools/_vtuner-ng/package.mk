# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_vtuner-ng"
PKG_VERSION="bfbc0dde236be60d2b4d92a0e9e3bc710d66707d"
PKG_SHA256="d31651a66e718b9a43ea21800abc63b1c97ccca76c8ed390bc49b947437da102"
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

post_unpack() {
    # sanity check. It's possible that the former build was interrupted.
    rm -f ${PKG_DIR}/patches/vtuner-ng-4.9.patch
    rm -f ${PKG_DIR}/patches/vtuner-ne-5.4.patch
    rm -f ${PKG_DIR}/patches/vtuner-no-5.15.patch

    if [ "${DEVICE}" == "Amlogic-ng" ]; then
        cp ${PKG_DIR}/patches/vtuner-ng-4.9.patch.optional ${PKG_DIR}/patches/vtuner-ng-4.9.patch
    fi

    if [ "${DEVICE}" == "Amlogic-ne" ]; then
    	cp ${PKG_DIR}/patches/vtuner-ne-5.4.patch.optional ${PKG_DIR}/patches/vtuner-ne-5.4.patch
	fi

	if [ "${DEVICE}" == "Amlogic-no" ]; then
        cp ${PKG_DIR}/patches/vtuner-no-5.15.patch.optional ${PKG_DIR}/patches/vtuner-no-5.15.patch
    fi
}

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

  # install scripts
  mkdir -p ${INSTALL}/usr/local/bin
  	cp ${PKG_DIR}/bin/start_vtuner.sh ${INSTALL}/usr/local/bin/sample_start_vtuner.sh
  	cp ${PKG_DIR}/bin/stop_vtuner.sh ${INSTALL}/usr/local/bin/stop_vtuner.sh

  mkdir -p ${INSTALL}/usr/local/system.d
    cp ${PKG_DIR}/_system.d/* ${INSTALL}/usr/local/system.d
}

post_makeinstall_target() {
    rm -f ${PKG_DIR}/patches/vtuner-ng-4.9.patch
    rm -f ${PKG_DIR}/patches/vtuner-ne-5.4.patch
    rm -f ${PKG_DIR}/patches/vtuner-no-5.15.patch
}
