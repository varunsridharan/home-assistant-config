#!/bin/bash

API_KEY="$1"

source /config/integrations/shell_scripts/inc/functions.sh

ha_api_trigger_secret "$API_KEY"

cron_log "Home Assistant Api ${API_KEY} Triggered"

exit 0