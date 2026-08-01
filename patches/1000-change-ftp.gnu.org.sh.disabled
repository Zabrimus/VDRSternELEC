#!/bin/bash

for i in $(find packages -name "package.mk" -exec grep -l "ftp.gnu.org" {} \;); do
   sed -i -e "s#ftp.gnu.org/pub/gnu#ftpmirror.gnu.org/gnu#" $i
   sed -i -e "s#ftp.gnu.org/gnu#ftpmirror.gnu.org/gnu#" $i
done
