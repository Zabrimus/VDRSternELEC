# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_rustup.rs"
PKG_VERSION="1.28.2"
PKG_SHA256="5987dcb828068a4a5e29ba99ab26f2983ac0c6e2e4dc3e5b3a3c0fafb69abbc0"
PKG_LICENSE="MIT"
PKG_SITE="https://www.rust-lang.org"
PKG_URL="https://github.com/rust-lang-nursery/rustup.rs/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The Rust toolchain installer."
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed"
