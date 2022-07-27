#!/bin/bash

source /config/integrations/shell_scripts/inc/functions.sh

VAULT1_IP="$(ha_secrets "vault1_ip")"
VAULT1_USER="$(ha_secrets "vault1_user")"
VAULT1_PASS="$(ha_secrets "vault1_pass")"

# Power Down Vault 1
#run_ssh_cmd_pass "${VAULT1_IP}" "${VAULT1_USER}" "${VAULT1_PASS}" "shutdown -h now"
run_ssh_cmd_pass "${VAULT1_IP}" "${VAULT1_USER}" "${VAULT1_PASS}" "shutdown -p now"
