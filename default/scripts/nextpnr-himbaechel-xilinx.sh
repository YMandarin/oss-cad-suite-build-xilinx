# script inspired by https://github.com/openXC7/toolchain-installer/blob/main/toolchain-sources-builder.sh
export PATH=${BUILD_DIR}/python3-native${INSTALL_PREFIX}/bin:$PATH
cd nextpnr-xc7
build_gui="OFF"
if [ ${ARCH} == 'linux-x64' ] || [ ${ARCH} == 'windows-x64' ] || [ ${ARCH} == 'darwin-x64' ] || [ ${ARCH} == 'darwin-arm64' ]; then
      build_gui="ON"
fi
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} \
      -DPython3_INCLUDE_DIR=${BUILD_DIR}/python3${INSTALL_PREFIX}/include/python3.11 \
      -DPython3_LIBRARY=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/libpython3.11${SHARED_EXT} \
      -DARCH=himbaechel -DHIMBAECHEL_UARCH="xilinx" -DHIMBAECHEL_SPLIT=ON \
      -DHIMBAECHEL_XILINX_DEVICES= \
      -DHIMBAECHEL_PRJXRAY_DB="${BUILD_DIR}/prjxray-db/${INSTALL_PREFIX}/share/prjxray-db" \
      -DBUILD_GUI=${build_gui} -DUSE_IPO=OFF \
      -B build

make -C build DESTDIR=${OUTPUT_DIR} -j${NPROC} install

cp ./build/bba/bbasm ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/bbasm-xilinx${EXE}

share="${OUTPUT_DIR}${INSTALL_PREFIX}/share/nextpnr/himbaechel"
mkdir -p "$share/uarch/xilinx"
mkdir -p "${OUTPUT_DIR}${INSTALL_PREFIX}/lib/"
cp -r himbaechel/uarch/xilinx/gen "$share/uarch/xilinx/"
cp -r himbaechel/uarch/xilinx/meta "$share/uarch/xilinx/"
cp himbaechel/uarch/xilinx/constids.inc "$share/uarch/xilinx/"
cp -r himbaechel/himbaechel_dbgen "$share/"
cp himbaechel/uarch/xilinx/constids.inc "${OUTPUT_DIR}${INSTALL_PREFIX}/lib/"

${STRIP} ${OUTPUT_DIR}${INSTALL_PREFIX}/bin/nextpnr-himbaechel-xilinx${EXE}
