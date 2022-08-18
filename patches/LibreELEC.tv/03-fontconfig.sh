#!/bin/bash

set -e

sed -i "s#--without-add-fonts#--with-add-fonts=${VDR_PREFIX}/vdrshare/fonts,/storage/.config/vdropt/fonts#" packages/x11/other/fontconfig/package.mk
