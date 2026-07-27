
#!/bin/bash

set -e

sed -i "s#https://gmplib.org/download/gmp/#https://ftp.gnu.org/gnu/gmp/#" packages/devel/gmp/package.mk
