#!/bin/bash

set -e

sed -i "s#--without-add-fonts#--with-add-fonts=/usr/local/vdrshare/fonts,/storage/.config/vdropt/fonts#" packages/x11/other/fontconfig/package.mk
