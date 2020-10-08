#!/bin/bash

if [[ $MY_DEBUG = 1 ]]; then
  source /etc/my_init.d/include/debug
else
  source /etc/my_init.d/include/no_debug
fi

BASE_DIR=$GITIT_DIRECTORY
USER=${GITIT_USER}
GROUP=${GITIT_GROUP}

OLD_UID=$(getent passwd ${USER} |  awk -F: '{ print $3 }')
OLD_GID=$(getent group ${GROUP} |  awk -F: '{ print $3 }')
NEW_UID=$(stat -c %u $BASE_DIR)
NEW_GID=$(stat -c %g $BASE_DIR)

if [[ ${USER} = "root" && ${NEW_UID} != 0 ]]; then
    echo "${BASE_DIR} must be root owned when running as root."
    exit 1;
fi

if [[ ${USER} != "root" && ${NEW_UID} = 0 ]]; then
    echo "${BASE_DIR} must NOT be root owned when NOT running as root."
    exit 1;
fi

if [ -z "$BASE_DIR" ]; then
  echo "Directory not specified"
  exit 1;
fi

if [ -z "$USER" ]; then
  echo "Username not specified"
  exit 1;
fi

if [ -z "$GROUP" ]; then
  echo "Groupname not specified"
  exit 1;
fi

if [ ! -d "$BASE_DIR" ]; then
  echo "$BASE_DIR does not exist"
  exit 1;
fi

if [ "${USER}" != "root" ]; then
    usermod -u $NEW_UID $USER
    groupmod -g $NEW_GID $GROUP
    find / \( -name proc -o -name dev -o -name sys \) -prune -o \( -user ${OLD_UID} -exec chown -hv ${NEW_UID} {} + -o -group ${OLD_GID} -exec chgrp -hv ${NEW_GID} {} + \)
fi
