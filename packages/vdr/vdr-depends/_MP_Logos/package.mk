# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_MP_Logos"
PKG_VERSION="2e12ba4707295a5f3f48170117142d0c42505f7f"
PKG_SHA256="79419c83b4ed6500306c4a10c28e3b7fad91fc6fa0afb68f1aa385abb9534426"
PKG_LICENSE="GPL3"
PKG_SITE="https://github.com/MegaV0lt/MP_Logos"
PKG_URL="https://github.com/MegaV0lt/MP_Logos/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="MP_Logos-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _mediaportal-de-logos"
PKG_TOOLCHAIN="manual"

make_target() {
    export MP_LOGODIR="$(get_install_dir _mediaportal-de-logos)/usr/local/vdrshare/logofiles"
    export MAPPING="$(get_install_dir _mediaportal-de-logos)/usr/local/vdrshare/logofiles/LogoMapping.xml"
    export LOGODIR="${PKG_BUILD}/logos"
    export AUTO_UPDATE="false"
    export LOGO_VARIANT="Light"
    export TO_LOWER="A-Z"

    touch ${PKG_BUILD}/mp_logos.conf

    mkdir -p ${LOGODIR}

    cd ${MP_LOGODIR}
    bash ${PKG_BUILD}/mp_logos.sh -c ${PKG_BUILD}/mp_logos.conf

    mkdir -p ${INSTALL}/usr/local/vdrshare/logos
    cp -R ${LOGODIR} ${INSTALL}/usr/local/vdrshare
}
