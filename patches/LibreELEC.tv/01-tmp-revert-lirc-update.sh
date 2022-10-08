#!/bin/sh

# Temporary fix of lirc, revert to 0.10.1
# If build has been fixed this patch will be deleted
#
# Error message:
# cp: cannot overwrite non-directory 'xxx/toolchain/x86_64-libreelec-linux-gnu/sysroot/usr/include/lirc/media' with directory 'xxx/.sysroot/lirc.target/usr/include/lirc/media'
# *********** FAILED COMMAND ***********
# cp -PRf "${SYSROOT_PREFIX}"/* "${PKG_ORIG_SYSROOT_PREFIX}"
# **************************************

git restore --source=2da3f0e9edbd0d2c82f69bf852e8be8e9ebaab19 packages/sysutils/lirc


