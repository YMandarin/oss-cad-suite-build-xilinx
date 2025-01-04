#pushd prjxray/prjxray
pushd prjxray
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DBUILD_PYTHON=ON \
      .
#make -j${NPROC} pyxray
make -j${NPROC} 
popd
pushd nextpnr-xilinx
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DPRJXRAY_LIBDIR=${BUILD_DIR}/prjxray/prjxray \
      -DPRJXRAY_DATADIR=${BUILD_DIR}/prjxray \
      -DEXTERNAL_CHIPDB=ON \
      -DARCH=xilinx \
      .
make
mkdir -p ${OUTPUT_DIR}/xilinx/chipdb
cp chipdb/* ${OUTPUT_DIR}/xilinx/chipdb/. || echo "Could not find any chipdb file"
popd

