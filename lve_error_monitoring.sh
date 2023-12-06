#!/bin/bash

LOG_FILE=/var/log/apache2/error_log
TIMEFRAME="1 hours ago"
CURRENT_DATE=$(date '+%b %d')
CURRENT_TIME=$(date '+%T')
HOURS_AGO=$(date --date="$TIMEFRAME" '+%T')
LVE_ERROR_COUNT=$(cat $LOG_FILE | grep lsapi:error | grep "$CURRENT_DATE" | awk -v p="$HOURS_AGO" -v c="$CURRENT_TIME" '$4 <= c && $4 >= p' | wc -l)