#!/bin/sh

cd LibreELEC.tv
git diff HEAD f2023c083fe8879dee07f334e5121096594912fd packages/sysutils/systemd > ../patches/LibreELEC.tv.libreelec-13/tmp_downgrade_systemd.patch
