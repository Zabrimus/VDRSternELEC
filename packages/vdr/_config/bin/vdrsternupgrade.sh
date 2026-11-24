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

  cd /
    for i in `ls ${CONF_DIR}/*-sample-config.zip`; do
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

  # upgrade live, its web files have to fit the plugin version.
  # siteprefs.css and ffmpeg.conf are meant for own changes, keep them.
  LIVE=/storage/.config/vdropt/plugins/live
  LIVE_SAMPLE=/storage/.config/vdropt-sample/plugins/live
  if [ -d ${LIVE} ] && [ -d ${LIVE_SAMPLE} ]; then
    (cd ${LIVE_SAMPLE} && find . ! -type d) | while read -r f; do
      case "$f" in
        ./css/siteprefs.css|./ffmpeg.conf) [ -e "${LIVE}/$f" ] && continue;;
      esac
      mkdir -p "${LIVE}/${f%/*}"
      cp -a "${LIVE_SAMPLE}/$f" "${LIVE}/$f"
    done
  fi

  # change /storage/.config/autostart.sh if it exists
  if [ -f /storage/.config/autostart.sh ]; then
    sed -i -e 's#/usr/local/bin/autostart.sh##' /storage/.config/autostart.sh
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