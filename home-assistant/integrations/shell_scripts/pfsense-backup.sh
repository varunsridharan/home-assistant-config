#!/bin/bash

source /config/integrations/shell_scripts/inc/functions.sh

REPOSITORY="$(ha_secrets "pfsense_backup_repo")"
ROUTER_IP="$(ha_secrets "pfsense_router_ip")"
ROUTER_USERNAME="$(ha_secrets "pfsense_username")"
REPOSITORY_FOLDER="$(locate_repo "$REPOSITORY")"

setup_github_repo "$REPOSITORY" "PFSense Auto Backup" "githubactionbot+pfsense@gmail.com"

run_ssh_cmd "$REPOSITORY" "scp ${ROUTER_USERNAME}@${ROUTER_IP}:/cf/conf/config.xml /tmp/pfsensetmp.xml"

mv /tmp/pfsensetmp.xml "$REPOSITORY_FOLDER/config.xml"

cd "$REPOSITORY_FOLDER"

if [ "$(git status --porcelain)" != "" ]; then
  git add "$REPOSITORY_FOLDER/config.xml"
  git commit -m "💾 Configuration Backup"

  push_repo "$REPOSITORY"

  git tag -a "$(date +"%Y.%m.%d.%H.%M.%p")" -m "Auto Backup On $(date +"%B - %d/%m/%Y") @  $(date +%r)"
  push_repo "$REPOSITORY" " --tags"
fi