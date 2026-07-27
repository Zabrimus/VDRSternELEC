#!/bin/bash

set -e

sed -i "s#PKG_URL=.*\$#PKG_URL=\"http://ftp.rz.tu-braunschweig.de/pub/mirror/ubuntu-packages/pool/universe/c/cxxtools/cxxtools_\${PKG_VERSION}.0.orig.tar.gz\"#" packages/addons/addon-depends/cxxtools/package.mk
sed -i "s#PKG_URL=.*\$#PKG_URL=\"http://slackware.uk/sbosrcarch/by-name/network/tntnet/\${PKG_NAME}-\${PKG_VERSION}.tar.gz\"#" packages/addons/addon-depends/tntnet/package.mk
