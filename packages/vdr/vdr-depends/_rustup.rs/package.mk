# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="_rustup.rs"
PKG_VERSION="1.26.0"
PKG_SHA256="6f20ff98f2f1dbde6886f8d133fe0d7aed24bc76c670ea1fca18eb33baadd808"
PKG_LICENSE="MIT"
PKG_SITE="https://www.rust-lang.org"
PKG_URL="https://github.com/rust-lang-nursery/rustup.rs/archive/${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_LONGDESC="The Rust toolchain installer."
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed"
