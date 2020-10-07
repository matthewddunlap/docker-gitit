#!/bin/bash

if [[ $MY_DEBUG = 1 ]]; then
  source /etc/my_init.d/include/debug
else
  source /etc/my_init.d/include/no_debug
fi

BASE_DIR=$GITIT_DIRECTORY
USER=${GITIT_USER}
GROUP=${GITIT_GROUP}

if [ -d "${BASE_DIR}" ]; then
  echo "${BASE_DIR} exist"
else
  echo "${BASE_DIR} does not exist"
  echo "Creating ${BASE_DIR}"
  mkdir ${BASE_DIR}
  chown -R ${USER} ${BASE_DIR}
  chgrp -R ${GROUP} ${BASE_DIR}
fi
