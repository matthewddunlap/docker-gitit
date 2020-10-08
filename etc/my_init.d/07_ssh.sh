#!/bin/bash

if [[ $MY_DEBUG = 1 ]]; then
  source /etc/my_init.d/include/debug
else
  source /etc/my_init.d/include/no_debug
fi

FILE="/etc/ssh/sshd_config"

LINE="AuthorizedKeysFile ${SSH_AUTHORIZED_KEYS}"
grep -qxF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

LINE="Port ${SSH_PORT}"
grep -qxF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
