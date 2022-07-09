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

  # Remove Lines With Comments
  echo "$(grep -E -v '^# (\s|.+)' "${CRON_FILE}")" > "${CRON_FILE}"
  echo "$(grep -E -v '^#.+' "${CRON_FILE}")" > "${CRON_FILE}"

  # Remove Empty Lines
  echo "$(grep -E -v '^$' "${CRON_FILE}")" > "${CRON_FILE}"

	# Update Cron With New File
	/usr/bin/crontab ${CRON_FILE}

	# Resetup CROND Service
	crond -l 0 -f > /dev/stdout 2> /dev/stderr &
	#crond -l 0 -f > "$(cron_log_file)" 2> /dev/stderr &

  exit 0

fi

exit 0
