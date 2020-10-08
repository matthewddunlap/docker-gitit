#!/bin/bash

if [[ $MY_DEBUG = 1 ]]; then
  source /etc/my_init.d/include/debug
else
  source /etc/my_init.d/include/no_debug
fi

BASE_DIR=${GITIT_DIRECTORY}
USER=${GITIT_USER}
GROUP=${GITIT_GROUP}
DIRLIST="static templates"
SRC_DIR=${GITIT_THEME_DIR}
SUFFIX=${GITIT_THEME_ACTIVE}

for DIR in ${DIRLIST}
do
  if [[ $(readlink -f ${BASE_DIR}/${DIR}) != ${BASE_DIR}/${DIR}-${SUFFIX} ]]; then
    unlink ${BASE_DIR}/${DIR}
    if [ ${SUFFIX} != default ]; then
      cp -r "${SRC_DIR}/out/${DIR}" "${BASE_DIR}/${DIR}-${SUFFIX}"
      chown -R ${USER} "${BASE_DIR}/${DIR}-${SUFFIX}"
      chgrp -R ${GROUP} "${BASE_DIR}/${DIR}-${SUFFIX}"
    fi
    ln -sr ${BASE_DIR}/${DIR}-${SUFFIX} ${BASE_DIR}/${DIR}
  fi
done
