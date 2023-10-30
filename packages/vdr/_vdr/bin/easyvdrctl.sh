#!/bin/sh

CONF_DIR="/storage/.config/vdropt/conf.d"
BIN_DIR="/usr/local/bin"
LIB_DIR="/usr/local/lib/vdr"

${BIN_DIR}/easyvdrctl --plugindir "${LIB_DIR}" --inidir "${CONF_DIR}" $@
