#!/bin/bash
set -e

if [[ ! -f "$ZOOCFGDIR/zoo.cfg" ]]; then
    CONFIG="$ZOOCFGDIR/zoo.cfg"
    {
        echo "dataDir=$ZOODATADIR" 
        echo "clientPort=2181"
        echo "tickTime=$ZOO_TICK_TIME"
        echo "initLimit=$ZOO_INIT_LIMIT"
        echo "syncLimit=$ZOO_SYNC_LIMIT"

        echo "autopurge.snapRetainCount=$ZOO_AUTOPURGE_SNAPRETAINCOUNT"
        echo "autopurge.purgeInterval=$ZOO_AUTOPURGE_PURGEINTERVAL"
        echo "maxClientCnxns=$ZOO_MAX_CLIENT_CNXNS"
    } >> "$CONFIG"

    if [[ -n $K8S_ZOO_REPLICAS ]]; then
        HOST=`hostname -s`
        DOMAIN=`hostname -d`
        ZOO_MY_ID=$((${HOSTNAME##*-}+1))
        PREFIX=${HOSTNAME::-1}
        echo "${ZOO_MY_ID:-1}" > "$ZOODATADIR/myid"
        for (( i=1; i<=$K8S_ZOO_REPLICAS; i++ ))
        do
            echo "server.$i=$PREFIX$((i-1)).$DOMAIN:2888:3888" >> "$CONFIG"
        done
    fi

    for server in $ZOO_SERVERS; do
        echo "$server" >> "$CONFIG"
    done

    if [[ -n $ZOO_4LW_COMMANDS_WHITELIST ]]; then
        echo "4lw.commands.whitelist=$ZOO_4LW_COMMANDS_WHITELIST" >> "$CONFIG"
    fi

fi

if [[ ! -f "$ZOODATADIR/myid" ]]; then
    echo "${ZOO_MY_ID:-1}" > "$ZOODATADIR/myid"
fi

exec "$@"