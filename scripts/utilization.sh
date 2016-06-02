#!/bin/bash

function usage(){
    echo "Usage :"
    echo " utilisation.sh [options] <command>"
    echo ""
    echo "launch utilization check relative to command"
    echo ""
    echo "Options :"
    echo " --warning-limit <limit>  : set the warning limit (default: 50)"
    echo " --fail-limit <limit>     : set the fail limit \
(default: warning-limit + (100 - warning-limit) / 2)"
    echo " -h                       : show this message"
    echo ""
    echo "Commands :"
    echo "cpu, ram, hdd"
}

function init() {

    if [ -z $WARN_LIMIT ]
        then
        WARN_LIMIT=50
    fi

    if [ -z $FAIL_LIMIT ]
        then
        FAIL_LIMIT=$( echo "(100 - $WARN_LIMIT) / 2 + $WARN_LIMIT" | bc)
    fi
}

go_exit() {
    if (( $RETURN > $FAIL_LIMIT ))
        then
        return 2
    fi

    if (( $RETURN > $WARN_LIMIT ))
        then
        return 1
    fi

    return 0
}

SRC=${BASH_SOURCE[0]}

if [ -L ${BASH_SOURCE[0]} ];then
    SRC=$( readlink "$SRC" )
fi

DIR=$( dirname $( readlink -f $SRC ))

OPTS=$( getopt -o h -l warning-limit:,fail-limit: -- "$@" )
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
        --warning-limit)
            WARN_LIMIT=$2;
            shift 2;;
        --fail-limit)
            FAIL_LIMIT=$2;
            shift 2;;
        --) shift; break;;
    esac
done

if [ $# -eq 0 ]
    then
    echo "Bad command $@"
    echo "use -h to see the help message"
    exit 2
fi

init

CMD=$1
shift
OPTIONS=$@

CMD=$DIR/$CMD.sh $OPTIONS

LOG=$($CMD)
RETURN=$?

DATE=$(date "+%Y-%m-%d %H:%M:%S")
echo $LOG $DATE
echo $DATE : $LOG >> /var/log/utilization.log

go_exit
