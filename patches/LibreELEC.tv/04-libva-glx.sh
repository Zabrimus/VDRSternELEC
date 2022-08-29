#!/bin/bash

set -e

sed -i "s#-Dwith_x11=yes -Dwith_glx=no -Dwith_wayland=no#-Dwith_x11=yes -Dwith_glx=yes -Dwith_wayland=no#" packages/multimedia/libva/package.mk



