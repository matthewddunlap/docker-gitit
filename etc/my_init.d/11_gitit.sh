#!/bin/bash

if [[ $MY_DEBUG = 1 ]]; then
  source /etc/my_init.d/include/debug
else
  source /etc/my_init.d/include/no_debug
fi

BASE_DIR=${GITIT_DIRECTORY}
CONF=${GITIT_CONF}
USER=${GITIT_USER}
GROUP=${GITIT_GROUP}
BIN=gitit
BINARG="-f ${GITIT_CONF}"
BINENV="/etc/service/gitit/env"
GIT_DIR=${GITIT_REPOSITORY}
GIT_DISCOVERY_ACROSS_FILESYSTEM=1
DIRLIST="static templates"
GITIT_THEME_ACTIVE=${GITIT_THEME_ACTIVE}

if [[ ! -d ${GIT_DIR}/.git ]]; then
  TEMP_DIR=$(mktemp -d)
  cd ${TEMP_DIR}
  gitit --print-default-config > gitit.conf
  chpst -u ${USER}:${GROUP} -e ${BINENV} ${BIN} -f ./gitit.conf &
  sleep 2
  kill $!
  (cd ${TEMP_DIR}/wikidata && tar cf - .) | (cd ${GIT_DIR} && tar xf -)
  chown -R ${USER} ${GIT_DIR}
  chgrp -R ${GROUP} ${GIT_DIR}
fi

if [[ ! -f ${CONF} ]]; then
  cd ${BASE_DIR}
  gitit --print-default-config > ${CONF}
  chown ${USER} ${CONF}
  chgrp ${GROUP} ${CONF}
  chpst -u ${USER}:${GROUP} -e ${BINENV} ${BIN} ${BINARG} &
  sleep 2
  kill $!
fi

for DIR in ${DIRLIST}
do
  if [[ ! -L ${BASE_DIR}/${DIR}-default ]]; then
    mv ${BASE_DIR}/${DIR}{,-default}
    ln -sr ${BASE_DIR}/${DIR}-default ${BASE_DIR}/$DIR
  fi
done

FILE="${CONF}"
LINE="port: ${GITIT_PORT}"
cd ${BASE_DIR}
grep -qxF -- "$LINE" "$FILE" || sed -i "/^port: [[:digit:]]*/a ${LINE}" $FILE
