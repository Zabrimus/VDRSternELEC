# SPDX-License-Identifier: GPL-2.0-or-later

PKG_NAME="_dnsmasq"
PKG_VERSION="2.90"
PKG_SHA256="8f6666b542403b5ee7ccce66ea73a4a51cf19dd49392aaccd37231a2c51b303b"
PKG_LICENSE="GPL 2"
PKG_SITE="https://thekelleys.org.uk/dnsmasq/doc.html"
PKG_URL="https://thekelleys.org.uk/dnsmasq/dnsmasq-${PKG_VERSION}.tar.gz"
PKG_DEPENDS_TARGET="toolchain"
PKG_SOURCE_DIR="dnsmasq-${PKG_VERSION}"
PKG_BRANCH="master"
PKG_LONGDESC="Dnsmasq provides network infrastructure for small networks: DNS, DHCP, router advertisement and network boot."
PKG_TOOLCHAIN="auto"
PKG_BUILD_FLAGS="+speed"
