#!/bin/bash


AVAILABLE_RAM=`cat /proc/meminfo | grep '^MemAvailable' | awk '{print $2}'`
AVAILABLE_RAM=$(echo "$AVAILABLE_RAM/1024" | bc)
TOTAL_RAM=`cat /proc/meminfo | grep '^MemTotal' | awk '{print $2}'`
TOTAL_RAM=$(echo "$TOTAL_RAM/1024" | bc)

USED_RAM=$(echo "$TOTAL_RAM-$AVAILABLE_RAM" | bc)
RAM_UTILIZATION=$(echo "scale = 2; $USED_RAM/$TOTAL_RAM*100" | bc)
RAM_UTILIZATION=${RAM_UTILIZATION%.*}

echo "RAM: "$RAM_UTILIZATION"% ("$USED_RAM"/"$TOTAL_RAM")"

exit $RAM_UTILIZATION
