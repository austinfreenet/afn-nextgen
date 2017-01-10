#!/bin/bash

GOLD_COPY=/home/gold/user
CLIENT_HOME=/home/user

if ! [ -e "$GOLD_COPY" ]; then
	echo "error: gold copy $GOLD_COPY does not exist" >&2
	exit 2
fi

if ! [ -e "$CLIENT_HOME" ]; then
	echo "error: client home dir $CLIENT_HOME does not exist" >&2
	exit 2
fi

rsync -a $GOLD_COPY/ $CLIENT_HOME/
