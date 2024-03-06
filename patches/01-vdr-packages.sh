#/bin/bash

set -e

sed -i 's:# cache packages folder:# cache VDR packages\n    find "${ROOT}/../${PACKAGES}" -not -path "${ROOT}/../${PACKAGES}/addons/*" -type f -name package.mk 2>/dev/null | sed -e "s#CoreELEC/../##g" | sed -e "s#LibreELEC/../##g" | sed "s#/package\.mk\\$#${_ANCHOR}#" >> "${temp_global}"\n\n    # cache packages folder:g' config/functions

