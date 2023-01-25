# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_mediaportal-de-logos"
PKG_VERSION="88e665029d19a8e099c4b2bf8b670428d1e66c3a"
PKG_SHA256="9b55b52e8a51d072ed18329f496fb39345e05734189e56599f377e8c8d0ef2e0"
PKG_LICENSE="?"
PKG_SITE="https://github.com/Jasmeet181/mediaportal-de-logos"
PKG_SOURCE_DIR="mediaportal-de-logos-${PKG_VERSION}"
PKG_URL="https://github.com/Jasmeet181/mediaportal-de-logos/archive/${PKG_VERSION}.zip"
PKG_DEPENDS_TARGET="toolchain"
PKG_TOOLCHAIN="manual"

make_target() {
    INSTALLPATH="${INSTALL}/usr/local/vdrshare/logofiles"

    mkdir -p ${INSTALLPATH}/Radio/.Light
    cp -R ${PKG_BUILD}/Radio/.Light ${INSTALLPATH}/Radio
    mkdir -p ${INSTALLPATH}/Radio/.Dark
    cp -R ${PKG_BUILD}/Radio/.Dark ${INSTALLPATH}/Radio

    mkdir -p ${INSTALLPATH}/TV/.Light
    cp -R ${PKG_BUILD}/TV/.Light ${INSTALLPATH}/TV
    mkdir -p ${INSTALLPATH}/TV/.Dark
    cp -R ${PKG_BUILD}/TV/.Dark ${INSTALLPATH}/TV

    cp  ${PKG_BUILD}/LogoMapping.xml ${INSTALLPATH}/LogoMapping.xml
}
