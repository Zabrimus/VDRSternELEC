#!/bin/sh

PROGNAME=$0

PREFIX="XXPREFIXXX"
CONF_DIR="XXPREFIXCONFXX"
BIN_DIR="XXBINDIRXX"

usage() {
  cat << EOF >&2
Usage: $PROGNAME [-install-config] [-boot kodi|vdr]

-i      : Extracts the default configuration into directory /storage/.config/vdropt-sample and copy the sample folder to /storage/.config/vdropt if it does not exists.
-C      : Use with care! All configuration entries of vdropt will be copied to vdropt-sample. And then all entries of vdropt-sample will be copied to vdropt.
-b kodi : Kodi will be started after booting
-b vdr  : VDR will be started after booting
EOF
  exit 1
}

install() {
  # delete old sample configuration if it exists and extract the new one
  rm -Rf /storage/.config/vdropt-sample

  cd /
    for i in `ls ${CONF_DIR}/*-sample-config.zip`; do
       unzip $i
    done

  if [ ! -d /storage/.config/vdropt ]; then
    # copy samples to final directory
    cp -a /storage/.config/vdropt-sample /storage/.config/vdropt
  fi

  cp -a XXPREFIXXX/system.d/* /storage/.config/system.d
  systemctl daemon-reload

  # disable everything. This is important and shall not be changed!
  for i in `ls XXPREFIXXX/system.d/*`; do
     systemctl disable $(basename $i)
  done

  # copy sysctl.d files
  cp -a XXPREFIXXX/sysctl.d/* /storage/.config/sysctl.d

  # create autostart.sh if it does not exists
  if [ ! -f /storage/.config/autostart.sh ]; then
cat > /storage/.config/autostart.sh<< EOF
#!/bin/sh
XXBINDIRXX/autostart.sh
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

while getopts b:iC o; do
  case $o in
    (i) install;;
    (C) install_copy;;
    (b) boot "$OPTARG";;
    (*) usage
  esac
done

# create default directories
mkdir -p /storage/.cache/vdr/markad
