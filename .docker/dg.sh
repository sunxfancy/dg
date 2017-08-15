#!/bin/bash -x
# Make sure we exit if there is a failure
set -e

cd ${BUILD_DIR}
mkdir build-dg
cd build-dg
cmake \
    -DLLVM_SRC_PATH=${BUILD_DIR}/llvm-3.4.2.src \
    -DLLVM_BUILD_PATH=${BUILD_DIR}/llvm-3.4.2-build \
    -DLLVM_DIR=${BUILD_DIR}/llvm-3.4.2/share/llvm/cmake/ \
    ${SRC_DIR}/dg
make
