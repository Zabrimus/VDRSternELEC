# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2016-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_drm-vc4-grabber"
PKG_VERSION="1af6f9a6845495ca7fc122cab701b9e9e855f053"
PKG_SHA256="8c3d564c7146e2ef13ca7e54b97cb4fc16194818ddacd8f9570263b1d8ef46da"
PKG_LICENSE="MIT"
PKG_SITE="https://github.com/rudihorn/drm-vc4-grabber"
PKG_URL="https://github.com/rudihorn/drm-vc4-grabber/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain cairo _rust"
PKG_SOURCE_DIR="drm-vc4-grabber-${PKG_VERSION}"
PKG_LONGDESC="Hyperion DRM VC4 screen grabber"
PKG_TOOLCHAIN="manual"
PKG_DEPENDS_UNPACK="_rust"
PKG_BUILD_FLAGS="+speed"

make_target() {
	. "$(get_build_dir _rust)/cargo/env"
	cargo build --release --target aarch64-unknown-linux-gnu
}

makeinstall_target() {
	${STRIP} ${PKG_BUILD}/.${TARGET_NAME}/aarch64-unknown-linux-gnu/release/drm-vc4-grabber
	mkdir -p ${INSTALL}/usr/local/bin
	cp ${PKG_BUILD}/.${TARGET_NAME}/aarch64-unknown-linux-gnu/release/drm-vc4-grabber ${INSTALL}/usr/local/bin

	mkdir -p ${INSTALL}/usr/local/system.d
        cp ${PKG_DIR}/_system.d/* ${INSTALL}/usr/local/system.d
}

