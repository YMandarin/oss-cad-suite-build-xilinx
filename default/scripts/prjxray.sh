cd prjxray

sed -i -re "s,cmake ,cmake  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DBUILD_PYTHON=ON -DPython3_INCLUDE_DIR=${BUILD_DIR}/python3${INSTALL_PREFIX}/include/python3.11 -DPython3_LIBRARY=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/libpython3.11${SHARED_EXT}  , " \
	Makefile
make INSTALL_DIR=${OUTPUT_DIR} DESTDIR=${OUTPUT_DIR} -j${NPROC} build
make INSTALL_DIR=${OUTPUT_DIR} DESTDIR=${OUTPUT_DIR} -j${NPROC} install


source ${PATCHES_DIR}/python3_package.sh
python3_package_setup

# Fix _sysconfigdata so the native Python reports the correct include dir.
# The upstream patch only replaces "/yosyshq/" (trailing slash), but sysconfig
# stores bare "/yosyshq" (prefix, includedir, etc.), so Meson's Python.h
# detection was checking a non-existent path. Rewrite all occurrences.
sed -i -re "s,/yosyshq,${BUILD_DIR}/python3-native${INSTALL_PREFIX},g" \
    "${BUILD_DIR}/python3-native${INSTALL_PREFIX}/lib/python3.11/_sysconfigdata__linux_x86_64-linux-gnu.py"

sed -i -re "s,'numpy,#'numpy," ./setup.py
sed -i -re 's,numpy,#numpy,' ./requirements.txt

if [ ${ARCH} == "linux-x64" ] ; then
	python3_package_pip_install " --no-compile -r requirements.txt"
else
	python3_package_pip_install " -r requirements.txt"
fi

python3_package_setup
python3_package_install

mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/prjxray/
cp -r utils ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/prjxray/

