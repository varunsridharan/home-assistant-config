#!/bin/sh

KEYNAME=$1

if [ -z "$KEYNAME" ]; then
    echo "Enter A Valid Deploy Key Name :"
    exit 1
fi

source /config/integrations/shell_scripts/functions.sh

# Generates Key Storage Path
KEY_STORAGE="$(locate_key "$KEYNAME")"

# Creates Storage Dir
mkdir -p "$KEY_STORAGE"

# Generates Keygen
ssh-keygen -t rsa -b 4096 -C "$KEYNAME" -f "$KEY_STORAGE/key"

chmod 700 -R "$(key_storage_location)"
chmod 600 "$KEY_STORAGE/key" # Private Key File
chmod 640 "$KEY_STORAGE/key.pub" # Public Key File

echo " "
echo "Key Generated & Stored @ $KEY_STORAGE"
echo " "

exit 0