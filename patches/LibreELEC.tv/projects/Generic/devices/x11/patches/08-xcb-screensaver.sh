#!/bin/bash

set -e

sed -i "s/--disable-screensaver/--enable-screensaver/" packages/x11/lib/libxcb/package.mk