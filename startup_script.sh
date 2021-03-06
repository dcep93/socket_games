#!/bin/bash

set -e
set -o pipefail

NAME=socket_games

LOG_FILE=/var/log/$NAME.log

INDEX=$1

if [ -z "$INDEX" ]; then
	echo "usage: $0 <index_path>" | tee -a $LOG_FILE
	exit 1
fi

echo "$(date) startup" | tee -a $LOG_FILE

screen -S $NAME -Dm bash -c "set -x; cd $(dirname $INDEX); if [[ -f env.sh ]]; then source env.sh; fi; nodemon --delay 1 $INDEX; sh"

iptables -A PREROUTING -t nat -p tcp --dport 80 -j REDIRECT --to-ports 8080
iptables -A PREROUTING -t nat -p tcp --dport 443 -j REDIRECT --to-ports 8080

echo "$(date) success" | tee -a $LOG_FILE
