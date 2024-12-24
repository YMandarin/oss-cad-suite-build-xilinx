pushd prjxray/libxray
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DBUILD_PYTHON=ON \
      .
make -j${NPROC} pyxray
popd
pushd nextpnr/xilinx
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DTRELLIS_LIBDIR=${BUILD_DIR}/prjxray/libxray \
      -DTRELLIS_DATADIR=${BUILD_DIR}/prjxray \
      .
make
mkdir -p ${OUTPUT_DIR}/xilinx/chipdb
cp chipdb/* ${OUTPUT_DIR}/xilinx/chipdb/.
popd

