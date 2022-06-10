#!/bin/sh

source /config/integrations/shell_scripts/functions.sh

REPOSITORY="varunsridharan/home-assistant-config"
REPOSITORY_FOLDER="$(locate_repo "$REPOSITORY")"

setup_github_repo "$REPOSITORY" "Varun Sridharan" "varunsridharan23@gmail.com"

if [ -d "${REPOSITORY_FOLDER}/home-assistant/" ]; then
  rm -rf "${REPOSITORY_FOLDER}/home-assistant/"
fi

if [ -d "${REPOSITORY_FOLDER}/esphome/" ]; then
  rm -rf "${REPOSITORY_FOLDER}/esphome/"
fi

if [ ! -d "/tmp/hassio-cfg/" ]; then
  mkdir -p /tmp/hassio-cfg/
fi

if [ ! -d "/tmp/hassio-cfg-draft/" ]; then
  mkdir -p /tmp/hassio-cfg-draft/
fi

if [ ! -d "/tmp/esphome-cfg/" ]; then
  mkdir -p /tmp/esphome-cfg/
fi

if [ ! -d "/tmp/esphome-cfg-draft/" ]; then
  mkdir -p /tmp/esphome-cfg-draft/
fi

# Clone Home Assistant Config To Github
cp -r /config/ /tmp/hassio-cfg/
rsync -r --delete --exclude-from="${REPOSITORY_FOLDER}/.gitignore" "/tmp/hassio-cfg/" "/tmp/hassio-cfg-draft/"
cp -r /tmp/hassio-cfg-draft/* "${REPOSITORY_FOLDER}/home-assistant/"

# Clone Esphome Config
cp -r /mnt/esphome/ /tmp/esphome-cfg/
rsync -r --delete --exclude-from="${REPOSITORY_FOLDER}/.gitignore" "/tmp/esphome-cfg/" "/tmp/esphome-cfg-draft/"
cp -r /tmp/esphome-cfg-draft/* "${REPOSITORY_FOLDER}/esphome/"


rm -r /tmp/hassio-cfg/
rm -r /tmp/esphome-cfg/
rm -r /tmp/hassio-cfg-draft/
rm -r /tmp/esphome-cfg-draft/


if [ "$(git status --porcelain)" != "" ]; then
    git add "$REPOSITORY_FOLDER/home-assistant/*"
    git add "$REPOSITORY_FOLDER/esphome/*"
    git commit -m "💾  Config Updated"
    push_repo "$REPOSITORY"
fi