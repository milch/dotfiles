#!/bin/bash

LOCKFILE=/tmp/fish_dark_notify.lock

if [ -e "${LOCKFILE}" ]; then
  PID=$(cat ${LOCKFILE})
  if kill -0 "${PID}" 2>/dev/null; then
    exit
  else
    rm -f "${LOCKFILE}"
  fi
fi

nohup dark-notify -c 'fish -c "set --universal apple_interface_style (dark-notify -e)"' &>/dev/null &
echo $! >"${LOCKFILE}"
