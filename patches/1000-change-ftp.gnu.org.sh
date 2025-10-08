#!/bin/bash

for i in $(find CoreELEC/packages LibreELEC.tv/packages -name "package.mk" -exec grep -l "ftp.gnu.org" {} \;); do
   sed -i -e "s#ftp.gnu.org/pub/gnu#mirror.netcologne.de/gnu#" $i
   sed -i -e "s#ftp.gnu.org/gnu#mirror.netcologne.de/gnu#" $i
done