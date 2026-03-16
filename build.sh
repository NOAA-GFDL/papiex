#!/bin/bash
set -euo pipefail

# Conda build script for papiex
#
# Dependency strategy:
#   - papi + libpfm4:  provided by conda-forge (available in $PREFIX)
#   - libmonitor:      built from vendored monitor/ source (not yet on conda-forge)

# ---- build libmonitor from vendored source (not yet on conda-forge) --------
cd "${SRC_DIR}/monitor"
./configure --prefix="${PREFIX}" --disable-link-static
make install

# ---- build papiex against conda-forge papi + vendored libmonitor -----------
cd "${SRC_DIR}/papiex"
make CC="${CC}" OCC="${CC}" \
     CONFIG_PAPIEX_PAPI=y \
     CONFIG_PAPIEX_DEBUG=n \
     MONITOR_INC_PATH="${PREFIX}/include" \
     MONITOR_LIB_PATH="${PREFIX}/lib" \
     PAPI_INC_PATH="${PREFIX}/include" \
     PAPI_LIB_PATH="${PREFIX}/lib" \
     PREFIX="${PREFIX}" \
     install
