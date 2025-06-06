#!/bin/bash

BASE_PATH=/home/xrocek/scripts/exams/

cron_job="59 16 * * * cd ${BASE_PATH}; /usr/bin/node ${BASE_PATH}reg.js >> ${BASE_PATH}log 2>&1; crontab -r"

# delete previous crons
crontab -r

# Add the cron job and preserve current crons
echo "$cron_job" | crontab -

echo "Cron job added."