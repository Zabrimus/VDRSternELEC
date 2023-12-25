# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_MP_Logos"
PKG_VERSION="9a70788143ab148f02a96afa607bf9d9553b12e8"
PKG_SHA256="6b41a8853fdb0024901a18af366eceee77c8fd4c4e46af5dbfd2db6767d98226"
PKG_LICENSE="GPL3"
PKG_SITE="https://github.com/MegaV0lt/MP_Logos"
PKG_URL="https://github.com/MegaV0lt/MP_Logos/archive/${PKG_VERSION}.zip"
PKG_SOURCE_DIR="MP_Logos-${PKG_VERSION}"
PKG_DEPENDS_TARGET="toolchain _mediaportal-de-logos"
PKG_TOOLCHAIN="manual"
PKG_BUILD_FLAGS="+speed"

make_target() {
    export MP_LOGODIR="$(get_install_dir _mediaportal-de-logos)/usr/local/vdrshare/logofiles"
    export MAPPING="$(get_install_dir _mediaportal-de-logos)/usr/local/vdrshare/logofiles/LogoMapping.xml"
    export AUTO_UPDATE="false"
    export CLEAN_LINKS="false"
    export TO_LOWER="A-Z"

    touch ${PKG_BUILD}/mp_logos.conf
    cd ${MP_LOGODIR}

# Link "Light" variant
    export LOGO_VARIANT="Light"
    export LOGODIR="${PKG_BUILD}/logos${LOGO_VARIANT}"
    mkdir -p ${LOGODIR}
    bash ${PKG_BUILD}/mp_logos.sh -c ${PKG_BUILD}/mp_logos.conf
    mkdir -p ${INSTALL}/usr/local/vdrshare/logos${LOGO_VARIANT}
    cp -R ${LOGODIR} ${INSTALL}/usr/local/vdrshare

# Link "Dark" variant
    export LOGO_VARIANT="Dark"
    export LOGODIR="${PKG_BUILD}/logos${LOGO_VARIANT}"
    mkdir -p ${LOGODIR}
    bash ${PKG_BUILD}/mp_logos.sh -c ${PKG_BUILD}/mp_logos.conf
    mkdir -p ${INSTALL}/usr/local/vdrshare/logos${LOGO_VARIANT}
    cp -R ${LOGODIR} ${INSTALL}/usr/local/vdrshare
}
