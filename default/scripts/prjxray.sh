#cd prjxray/prjxray
cd prjxray
#cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
#      -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DBUILD_PYTHON=OFF -DBUILD_SHARED=OFF \
#      .
sed -i -re "s,cmake ,cmake  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -DBUILD_PYTHON=ON -DPython3_INCLUDE_DIR=${BUILD_DIR}/python3${INSTALL_PREFIX}/include/python3.11 -DPython3_LIBRARY=${BUILD_DIR}/python3${INSTALL_PREFIX}/lib/libpython3.11${SHARED_EXT}  , " \
	Makefile
make INSTALL_DIR=${OUTPUT_DIR} DESTDIR=${OUTPUT_DIR} -j${NPROC} build
make INSTALL_DIR=${OUTPUT_DIR} DESTDIR=${OUTPUT_DIR} -j${NPROC} install

#source ${PATCHES_DIR}/python3_package.sh
#python3_package_setup

#sed -i -re 's,python3 -mvenv,#python3 -mvenv,' Makefile
#sed -i -re 's,python -mpip ,python3_package_pip_install ,' Makefile
#make INSTALL_DIR=${OUTPUT_DIR} DESTDIR=${OUTPUT_DIR} -j${NPROC} env

source ${PATCHES_DIR}/python3_package.sh
python3_package_setup
#if [ ${ARCH} == 'darwin-x64' ]; then
#    sed -i -re "s,sys.platform == \"darwin\",sysconfig.get_platform() == \"darwin-x64\",g" cocotb/cocotb_build_libs.py
#elif [ ${ARCH} == 'darwin-arm64' ]; then
#    sed -i -re "s,sys.platform == \"darwin\",sysconfig.get_platform() == \"darwin-aarch64\",g" cocotb/cocotb_build_libs.py
#fi
#pushd cocotb

#python3_package_pth "prjxray"
#python3_package_install_numpy
sed -i -re "s,'numpy,#'numpy," ./setup.py
sed -i -re 's,numpy,#numpy,' ./requirements.txt
if [ ${ARCH} == "linux-x64" ] ; then
	python3_package_pip_install " --no-compile -r requirements.txt"
else
	python3_package_pip_install " -r requirements.txt"
fi
python3_package_setup
#python3_package_install_numpy
python3_package_install
#MAKEFLAGS="-j 8" python3_package_pip_install " \
#	--config-settings
#	--global-option=build_ext \
#	--global-option=\"--include-dir=${_PYTHON_PROJECT_BASE}/include\" \
#	-r ./requirements.txt ."
#rm -rf ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/cocotb/share/makefiles/simulators/Makefile.verilator
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/prjxray/
cp -r utils ${OUTPUT_DIR}${INSTALL_PREFIX}/lib/python3.11/site-packages/prjxray/

