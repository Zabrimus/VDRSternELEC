#!/bin/sh

PROGNAME=$0

PREFIX="/usr/local"
CONF_DIR="${PREFIX}/config"
BIN_DIR="${PREFIX}/bin"

usage() {
  cat << EOF >&2
Usage: $PROGNAME [-i] [-b kodi|vdr] [-T] [-w] [-c (url)] [-p (url)]

-i       : Extracts the default configuration into directory /storage/.config/vdropt-sample and copy the sample folder to /storage/.config/vdropt if it does not exists.
-C       : Use with care! All configuration entries of vdropt will be copied to vdropt-sample. And then all entries of vdropt-sample will be copied to vdropt.
-b kodi  : Kodi will be started after booting
-b vdr   : VDR will be started after booting
-T       : install all necessary files and samples for triggerhappy (A lightweight hotkey daemon)
-w       : install/update web components (remotetranscode, cefbrowser)
-c (url) : install/update cef binary lib (located at url or within /storage/.update or at /usr/local/config)
-p (url) : install/update private configs (located at url or within /storage/.update)
EOF
  exit 1
}

install() {
  # delete old sample configuration if it exists and extract the new one
  rm -Rf /storage/.config/vdropt-sample
  rm -Rf /storage/cefbrowser-sample

  cd /
  for i in `ls ${CONF_DIR}/*-sample-config.zip`; do
     unzip -o $i
  done

  for i in `ls ${CONF_DIR}/*-sample.zip`; do
     unzip -o $i
  done

  # copy samples to final directory
  if [ ! -d /storage/.config/vdropt ]; then
    cp -a /storage/.config/vdropt-sample /storage/.config/vdropt
  fi

  # copy cefbrowser files to final directory
  if [ ! -d /storage/cefbrowser ]; then
    cp -a /storage/cefbrowser-sample /storage/cefbrowser
  fi

  cp -a /usr/local/system.d/* /storage/.config/system.d
  systemctl daemon-reload

  # disable everything. This is important and shall not be changed!
  for i in `ls /usr/local/system.d/*`; do
     systemctl disable $(basename $i)
  done

  # copy sysctl.d files
  cp -a /usr/local/sysctl.d/* /storage/.config/sysctl.d

  # create autostart.sh if it does not exists
  if [ ! -f /storage/.config/autostart.sh ]; then
cat > /storage/.config/autostart.sh<< EOF
#!/bin/sh
/usr/local/bin/autostart.sh
EOF

  chmod +x /storage/.config/autostart.sh
  else
      echo "/storage/.config/autostart.sh already exists."
      echo "Please insert '/storage/.opt/vdr/bin/autostart.sh' manually into this file (without quotes)."
  fi

  # copy default skin and add VDR menu entry in the power menu
  if [ ! -d  /storage/.kodi/addons/skin.estuary ]; then
      cp -a /usr/share/kodi/addons/skin.estuary /storage/.kodi/addons
      cp ${CONF_DIR}/DialogButtonMenu.xml /storage/.kodi/addons/skin.estuary/xml
  else
      echo "Skin already exists. Modification of DialogButtonMenu.xml will not be copied."
      echo "Please add VDR entry manually. Sample: ${CONF_DIR}/DialogButtonMenu.xml"
  fi
}

install_triggerhappy() {
  # create all directories if they currently not exists
  mkdir -p /storage/.config/system.d
  mkdir -p /storage/.config/udev.rules.d
  mkdir -p /storage/.config/triggers.d

  # copy files
  cp /usr/local/config/triggerhappy/system.d/* /storage/.config/system.d
  cp /usr/local/config/triggerhappy/udev.rules.d/* /storage/.config/udev.rules.d
  cp /usr/local/config/triggerhappy/triggers.d/* /storage/.config/triggers.d

  systemctl daemon-reload

  systemctl enable triggerhappy.socket
  systemctl enable triggerhappy.service

  systemctl start triggerhappy.socket
  systemctl start triggerhappy.service
}

install_web() {
  if [ ! -f "/storage/cef/libcef.so" ]; then
    echo "libcef.so is missing, install cef first!"
    echo "   -> install.sh -c [url]"
    exit 1
  fi

  mkdir -p /storage/cefbrowser
  cp -a /storage/cefbrowser-sample/* /storage/cefbrowser/

  # copy system.d files
  mkdir -p /storage/.config/system.d

  . /etc/os-release
  if [ "$NAME" == "CoreELEC" ]; then
    cp /usr/local/system.d/coreelec.cefbrowser.service /storage/.config/system.d/cefbrowser.service
  else
    cp /usr/local/system.d/libreelec.cefbrowser.service /storage/.config/system.d/cefbrowser.service
  fi

  cp /usr/local/system.d/remotetranscode.service /storage/.config/system.d
  systemctl daemon-reload
  systemctl enable cefbrowser.service
  systemctl enable remotetranscode.service
}

install_cef() {
  rm -Rf /storage/tmp
  mkdir /storage/tmp
  cd /storage/tmp

  # Get zip file
  # 1. try downloading
  if [ -n "$1" ]; then
    echo "Download cef libs from $1"
    if wget -q "$1" -O cef.zip; then
      sync
      echo "$1 saved to /storage/tmp"
    else
      echo "Error downloading $1"
      exit 1
    fi
  # 2. read from /storage/.update/cef.zip
  elif [ -e "/storage/.update/cef.zip" ]; then
    echo "Move /storage/.update/cef.zip"
    mv "/storage/.update/cef.zip" "/storage/tmp/cef.zip"
  # 3. read from /usr/local/config/cef.zip
  elif [ -e "/usr/local/config/cef.zip" ]; then
    echo "Copy /usr/local/config/cef.zip"
    cp "/usr/local/config/cef.zip" "/storage/tmp/cef.zip"
  else
    echo "No cef library file found, exiting"
    exit 1
  fi

  # unzip cef.zip
  if [ -e "/storage/tmp/cef.zip" ]; then
    cd /
    echo "Unzip cef.zip"
    unzip -o "/storage/tmp/cef.zip"
  else
    echo "No cef zip found, exiting"
    exit 1
  fi
}

install_private() {
  rm -Rf /storage/tmp
  mkdir /storage/tmp
  cd /storage/tmp

  # Get zip file
  # 1. try downloading
  if [ -n "$1" ]; then
    echo "Download private confs from $1"
    if wget -q "$1" -O ve-private-conf.zip; then
      sync
      echo "$1 saved to /storage/tmp"
    else
      echo "Error downloading $1"
      exit 1
    fi
  # 2. read from /storage/.update/ve-private-conf.zip
  elif [ -e "/storage/.update/ve-private-conf.zip" ]; then
    echo "Move /storage/.update/ve-private-conf.zip"
    mv "/storage/.update/ve-private-conf.zip" "/storage/tmp/ve-private-conf.zip"
  else
    echo "No private conf file found, exiting"
    exit 1
  fi

  # unzip ve-private-conf.tar.bz2
  if [ -e "/storage/tmp/ve-private-conf.zip" ]; then
    cd /
    echo "Unzip cef.zip"
    unzip -o "/storage/tmp/ve-private-conf.zip"
  else
    echo "No private conf zip found, exiting"
    exit 1
  fi
}

install_copy() {
  install

  cp -a /storage/.config/vdropt/* /storage/.config/vdropt-sample/
  cp -a /storage/.config/vdropt-sample/* /storage/.config/vdropt/
}


boot() {
  if [ "$1" = "kodi" ]; then
      echo "Boot Kodi"

      if [ -f /storage/.profile ]; then
          sed -i -e "/^START_PRG.*$/d" /storage/.profile
      fi
      echo "START_PRG=kodi" >> /storage/.profile
  elif [ "$1" = "vdr" ]; then
      echo "Boot VDR"

      if [ -f /storage/.profile ]; then
          sed -i -e "/^START_PRG.*$/d" /storage/.profile
      fi
      echo "START_PRG=vdr" >> /storage/.profile
  else
      echo "Unknown Boot parameter"
      exit 1
  fi
}

if [ "$#" = "0" ]; then
    usage
fi

while getopts b:iTCwc:p: o; do
  case $o in
    (i) install;;
    (C) install_copy;;
    (b) boot "$OPTARG";;
    (T) install_triggerhappy;;
    (w) install_web;;
    (c) eval url=\${$(( $OPTIND -1 ))}
        if [ -n $url ]; then
          install_cef "$url"
        else
          install_cef
        fi
        ;;
    (p) eval url=\${$(( $OPTIND -1 ))}
        if [ -n $url ]; then
          install_private "$url"
        else
          install_private
        fi
        ;;
    (*) usage
  esac
done

# create default directories
mkdir -p /storage/.cache/vdr/markad
