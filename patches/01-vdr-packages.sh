#/bin/bash

set -e

sed -i 's:# cache packages folder:# cache VDR packages\n    find "${ROOT}/../${PACKAGES}" -type f -name package.mk 2>/dev/null | sed "s#/package\.mk\\$#${_ANCHOR}#" >> "${temp_global}"\n\n    # cache packages folder:g' config/functions

