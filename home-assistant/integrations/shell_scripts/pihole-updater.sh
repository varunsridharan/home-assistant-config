#!/bin/bash

source /config/integrations/shell_scripts/inc/functions.sh

TYPE="$1"

IP="$(ha_secrets "pihole_${TYPE}")"

SSH_USER="$(ha_secrets "pihole_${TYPE}_ssh_user")"

SSH_PASS="$(ha_secrets "pihole_${TYPE}_ssh_pass")"

if [ -z "$SSH_PASS" ]; then
  SSH_PASS="$(ha_secrets "pihole_ssh_pass")"
fi

if [ -z "$SSH_USER" ]; then
  SSH_USER="$(ha_secrets "pihole_ssh_user")"
fi

run_ssh_cmd_pass "${IP}" "${SSH_USER}" "${SSH_PASS}" "pihole -up"

exit 0