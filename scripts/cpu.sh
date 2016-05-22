#!/bin/bash


PREV_IDLE=`cat /proc/stat | grep "^cpu\ " | awk '{print $5 + $6}'`
PREV_NON_IDLE=`cat /proc/stat | grep "^cpu\ " | awk '{print $2 + $3 + $4 + $7 + $8 + $9}'`

sleep 1s

IDLE=`cat /proc/stat | grep "^cpu\ " | awk '{print $5 + $6}'`
NON_IDLE=`cat /proc/stat | grep "^cpu\ " | awk '{print $2 + $3 + $4 + $7 + $8 + $9}'`

PREV_TOTAL=$(echo "$PREV_IDLE + $PREV_NON_IDLE" | bc)
TOTAL=$(echo "$IDLE + $NON_IDLE" | bc)

TOTALD=$(echo "$TOTAL - $PREV_TOTAL" | bc)
IDLED=$(echo "$IDLE - $PREV_IDLE" | bc)

CPU_UTILIZATION=$(echo "scale = 2; 100*($TOTALD - $IDLED)/$TOTALD" | bc)
CPU_UTILIZATION=${CPU_UTILIZATION%.*}

echo "CPU: "$CPU_UTILIZATION"%"

exit $CPU_UTILIZATION
