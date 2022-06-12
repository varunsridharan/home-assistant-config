#!/bin/bash

source /root/scripts/functions.sh

REPOSITORY="vs-backups/pfsense"
REPOSITORY_FOLDER="$(locate_repo "$REPOSITORY")"

setup_github_repo "$REPOSITORY" "PFSense Auto Backup" "githubactionbot+pfsense@gmail.com"
run_ssh_cmd "$REPOSITORY" "scp pfsensebackup@10.0.100.1:/cf/conf/config.xml /tmp/pfsensetmp.xml"

mv /tmp/pfsensetmp.xml "$REPOSITORY_FOLDER/config.xml"
cd "$REPOSITORY_FOLDER"

if [ "$(git status --porcelain)" != "" ]; then
    git add "$REPOSITORY_FOLDER/config.xml"
    git commit -m "💾 Configuration Backup"
   push_repo "$REPOSITORY"
fi

git tag -a "$(date +"%Y.%m.%d.%H.%M.%p")" -m "Auto Backup On $(date +"%B - %d/%m/%Y") @  $(date +%r)"
push_repo "$REPOSITORY" " --tags"