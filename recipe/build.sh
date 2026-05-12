#!/bin/bash
set -exuo pipefail

export OPENCARP_DIR="$PREFIX"
# cmake references `cpp` instead of $CPP, make it work without needing a patch
ln -s $CPP $BUILD_PREFIX/bin/cpp

cmake -S ${SRC_DIR} -B _build \
  ${CMAKE_ARGS} \
  -DDLOPEN=ON

cmake --build _build -j"${CPU_COUNT:-1}"
# cmake --install by default default installs duplicate petsc that doesn't work (?!)
for component in core tool; do
  cmake --install _build --component $component
done
