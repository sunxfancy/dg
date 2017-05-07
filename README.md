# DG
* Forked from https://github.com/mchalupa/dg
* Extended to support multiple slicing of the same function
## Build
```
git checkout extended-slicing
mkdir build
cd build
cmake \ 
    -DLLVM_SRC_PATH=<LLVM_SRC_DIR> \
    -DLLVM_BUILD_PATH=<LLVM_OBJ_DIR> \
    -DLLVM_DIR=<LLVM_OBJ_DIR>/share/llvm/cmake/ \
    -DCMAKE_C_FLAGS="-m32" \
    -DCMAKE_CXX_FLAGS="-m32" \
    ..
make
```
