#!/bin/bash

threshold_warn=150
threshold_crit=200

print_help() {
    echo ""
    echo "lsapi error monitor plugin for Nagios"
    echo ""
    echo "Usage: $PROGNAME [-w|--warning <warn>] [-c|--critical  <crit>]"
    echo ""
}

while test -n "$1"; do
    case "$1" in
        --help)
            print_help
            exit 0
            ;;
        -h)
            print_help
            exit 0
            ;;
        --warning)
            threshold_warn=$2
            shift
            ;;
        -w)
            threshold_warn=$2
            shift
            ;;
        --critical)
            threshold_crit=$2
            shift
            ;;
        -c)
            threshold_crit=$2
            shift
            ;;
        *)
            echo "Unknown argument: $1"
            print_help
            exit 3
            ;;
    esac
    shift
done

LOG_FILE=/var/log/apache2/error_log
TIMEFRAME="1 hours ago"
CURRENT_DATE=$(date '+%b %d')
CURRENT_TIME=$(date '+%T')
HOURS_AGO=$(date --date="$TIMEFRAME" '+%T')
LVE_ERROR_COUNT=$(cat $LOG_FILE | grep lsapi:error | grep "$CURRENT_DATE" | awk -v p="$HOURS_AGO" -v c="$CURRENT_TIME" '$4 <= c && $4 >= p' | wc -l)

eixtstatus=0
result="OK"

### Compare lve_error_count with threshold that have been set ###
if [ -n "$threshold_warn" ]; then
    if [ "$LVE_ERROR_COUNT" -ge "$threshold_warn"  ]; then
        result="Warning"
        exitstatus=1
    fi
fi
if [ -n "$threshold_crit" ]; then
    if [ "$LVE_ERROR_COUNT" -ge "$threshold_crit"  ]; then
        result="Critical"
        exitstatus=2
    fi
fi

echo "$LVE_ERROR_COUNT - $result"
# shellcheck disable=SC2086
exit $exitstatus