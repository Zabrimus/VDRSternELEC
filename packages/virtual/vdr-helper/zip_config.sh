#!/bin/bash

INSTALL=$1
PKG_DIR=$2
PLUGIN=$3

mkdir -p ${INSTALL}/storage/.config/vdropt-sample/conf.d
cp -PR ${PKG_DIR}/conf.d/* ${INSTALL}/storage/.config/vdropt-sample/conf.d/

if find ${INSTALL}/storage/.config/vdropt -mindepth 1 -maxdepth 1 2>/dev/null | read; then
  cp -ar ${INSTALL}/storage/.config/vdropt/* ${INSTALL}/storage/.config/vdropt-sample
  rm -Rf ${INSTALL}/storage/.config/vdropt
 fi

# create config.zip
cd ${INSTALL}
mkdir -p ${INSTALL}/usr/local/config/
zip -yqrum9 "${INSTALL}/usr/local/config/${PLUGIN}-sample-config.zip" storage
