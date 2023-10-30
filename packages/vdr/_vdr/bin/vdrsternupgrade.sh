#!/bin/sh

set -e

PROGNAME=$0

PREFIX="/usr/local"
CONF_DIR="${PREFIX}/config"
BIN_DIR="${PREFIX}/bin"

VERSION_FILE=/storage/.config/vdropt/os-release

upgrade() {
  if [ ! -d /storage/.config/vdropt ]; then
      # configuration does not exists at all.
      # Is this a clean install?
      return
  fi

  # delete old sample configuration if it exists and extract the new one
  rm -Rf /storage/.config/vdropt-sample
  rm -Rf /storage/.config/cefbrowser-sample
  rm -Rf /storage/.config/remotetranscode-sample
  # delete existing development links and files and reset them to default
  # manual changes on the links are erased
  # TODO: find a better solution
  rm -Rf /storage/.config/vdrlibs/save/*
  rm -Rf /storage/.config/vdrlibs/bin/*

  cd /
    for i in `ls ${CONF_DIR}/*-sample-config.zip`; do
      unzip -o $i
    done

    for i in `ls ${CONF_DIR}/*-sample.zip`; do
      unzip -o $i
    done

  # upgrade epg2vdr
  if [ -f /storage/.config/vdropt/plugins/epg2vdr/epg.dat ]; then
    cp /storage/.config/vdropt-sample/plugins/epg2vdr/epg.dat /storage/.config/vdropt/plugins/epg2vdr/epg.dat
  fi

  # upgrade scraper2vdr
  if [ -f /storage/.config/vdropt/plugins/scraper2vdr/epg.dat ]; then
    cp /storage/.config/vdropt-sample/plugins/scraper2vdr/epg.dat /storage/.config/vdropt/plugins/scraper2vdr/epg.dat
  fi

  # upgrade live
  if [ -d /storage/.config/vdropt/plugins/live ]; then
    cp -a /storage/.config/vdropt-sample/plugins/live/* /storage/.config/vdropt/plugins/live/
  fi
}

# read existing version, if it exists
if [ -f "${VERSION_FILE}" ]; then
   . ${VERSION_FILE}
fi

# read installed (CE or LE) version
. /etc/os-release

# if installed and current version differs, do something useful
if [ ! "${VERSION}" = "${VDRSTERNELEC_INSTALLED}" ]; then
    upgrade
    echo "VDRSTERNELEC_INSTALLED=${VERSION}" > ${VERSION_FILE}
fi