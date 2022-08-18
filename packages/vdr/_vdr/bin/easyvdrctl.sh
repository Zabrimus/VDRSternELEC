#!/bin/sh

CONF_DIR="XXCONFDIRXX/conf.d"
BIN_DIR="XXBINDIRXX"
LIB_DIR="XXLIBDIRXX/vdr"

${BIN_DIR}/easyvdrctl --plugindir "${LIB_DIR}" --inidir "${CONF_DIR}" $@
