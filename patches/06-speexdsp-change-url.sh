
#!/bin/bash

set -e

sed -i "s#PKG_URL=.*\$#PKG_URL=\"https://github.com/xiph/speexdsp/archive/refs/tags/SpeexDSP-\${PKG_VERSION}.tar.gz\"#" packages/audio/speex/package.mk
sed -i "s#PKG_SHA256=.*\$#PKG_SHA256=\"d17ca363654556a4ff1d02cc13d9eb1fc5a8642c90b40bd54ce266c3807b91a7\"#" packages/audio/speex/package.mk

sed -i "s#PKG_URL=.*\$#PKG_URL=\"https://github.com/xiph/speex/archive/refs/tags/Speex-\${PKG_VERSION}.tar.gz\"#" packages/audio/speexdsp/package.mk
sed -i "s#PKG_SHA256=.*\$#PKG_SHA256=\"beaf2642e81a822eaade4d9ebf92e1678f301abfc74a29159c4e721ee70fdce0\"#" packages/audio/speexdsp/package.mk

