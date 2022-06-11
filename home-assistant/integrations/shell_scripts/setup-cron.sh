#!/bin/bash
STATUS="${1}"
CRON_BASE_DIR="/config/integrations/cron"
CRON_FILE="/tmp/custom-cron.txt"

# Kill Existing CROND Service
pkill crond

if [ "start" == "${STATUS}" ] || [ "restart" == "${STATUS}" ]; then
	if [ -f "$CRON_FILE" ]; then
		rm -r "$CRON_FILE"
	fi
	
	touch "$CRON_FILE"
	
	for FILE in "${CRON_BASE_DIR}"/*.cron; do
		FILE_CONTENT=$(cat "$FILE")
		echo "$FILE_CONTENT" >> "${CRON_FILE}"
	done

	# Update Cron With New File
	/usr/bin/crontab ${CRON_FILE}

	# Resetup CROND Service
	#crond -l 0 -f > /dev/stdout 2> /dev/stderr &
	crond -l 0 -f > /tmp/cron.log 2> /dev/stderr &

  exit 0
	# List New Cron
	#/usr/bin/crontab -l > /dev/stdout
fi

exit 0
