#!/bin/sh

cd CoreELEC
git diff HEAD f2023c083fe8879dee07f334e5121096594912fd packages/sysutils/systemd > ../patches/CoreELEC.coreelec-22/tmp_downgrade_systemd.patch
git diff HEAD f2023c083fe8879dee07f334e5121096594912fd projects/Amlogic-ce/devices/Amlogic-no/patches/systemd > ../patches/CoreELEC.coreelec-22/tmp_downgrade_systemd-2.patch
