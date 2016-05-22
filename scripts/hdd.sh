#!/bin/bash

function usage(){
    echo "Usage :"
    echo " hdd.sh [options]"
    echo ""
    echo "checked HDD usage"
    echo ""
    echo "Options :"
    echo " --mount-point <mount-point>  : set the finded path to determine HDD usage"
    echo "                                (default: \"/\")"
    echo " -h                           : show this message"
}

OPTS=$( getopt -o h -l mount-point: -- "$@" )
if [ $? != 0 ]
then
    echo "Bad command $@"
    echo "use -h to see the help message"
    exit 2
fi

eval set -- "$OPTS"

while true ; do
    case "$1" in
        -h) usage;
            exit 0;;
        --mount-point)
            MOUNT_POINT=$2;
            shift 2;;
        --) shift; break;;
    esac
done

if [ -z $MOUNT_POINT ]
    then
    MOUNT_POINT="/"
fi

HDD_UTILIZATION=`df -h | awk '{if ($6 == "'$MOUNT_POINT'") { print $5 }}' | head -1 | cut -d'%' -f1`
HDD_UTILIZATION=${HDD_UTILIZATION%.*}

echo "HDD: "$HDD_UTILIZATION"%"

exit $HDD_UTILIZATION
