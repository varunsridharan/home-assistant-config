#!/bin/bash

# Add SSHPass
apk add  --no-cache sshpass rsync

if [ ! -d "/config/.deploy-keys" ]; then
  mkdir -p /config/.deploy-keys
fi

if [ ! -f '~/.ssh/config' ]; then
  if [ ! -d "~/.ssh" ]; then
    mkdir -p ~/.ssh/
  fi
  touch ~/.ssh/config
  echo "
  Host *
  StrictHostKeyChecking no
  " >> ~/.ssh/config
fi



# Setup SSH Keys
#ssh-keyscan -H github.com >> ~/.ssh/known_hosts

# Setup Cron
bash /config/integrations/shell_scripts/setup-cron.sh "start"