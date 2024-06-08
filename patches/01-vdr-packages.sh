#/bin/bash

set -e

sed -i 's:# cache packages folder:# cache VDR packages\n    find "${ROOT}/../${PACKAGES}" -type f -name package.mk -not -path "${ROOT}/../packages/addons/*" -exec realpath {} \\\; 2>/dev/null | sed -e "s#CoreELEC/../##g" | sed -e "s#LibreELEC/../##g" | sed "s#/package\.mk\\$#${_ANCHOR}#" >> "${temp_global}"\n\n    # cache packages folder:g' config/functions

# copy addons
mkdir -p packages/addons/tools/vdrsterneelec
cp -a ../packages/addons/* packages/addons/tools/vdrsterneelec

