# Just copy the prjxray-db repo to the output directory.
mkdir -p ${OUTPUT_DIR}${INSTALL_PREFIX}/share/prjxray-db
cp -r prjxray-db/* ${OUTPUT_DIR}${INSTALL_PREFIX}/share/prjxray-db

# Remove the timings file if it is not a directory but a broken link.
if [ ! -d ${OUTPUT_DIR}${INSTALL_PREFIX}/share/prjxray-db/virtex7/timings ]; then
    rm ${OUTPUT_DIR}${INSTALL_PREFIX}/share/prjxray-db/virtex7/timings
fi