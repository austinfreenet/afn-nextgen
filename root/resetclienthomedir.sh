#!/bin/bash

GOLD_COPY=/home/gold/user
OVERLAY=/home/tmp
CLIENT_HOME=/home/user

if ! [ -e "$GOLD_COPY" ]; then
	echo "error: gold copy $GOLD_COPY does not exist" >&2
	exit 2
fi

if ! [ -e "$OVERLAY" ]; then
	echo "error: overlay dir $OVERLAY does not exist" >&2
	exit 2
fi

if ! [ -e "$CLIENT_HOME" ]; then
	echo "error: client home dir $CLIENT_HOME does not exist" >&2
	exit 2
fi

if mount | grep $CLIENT_HOME | grep aufs; then
	umount $CLIENT_HOME
fi
find $OVERLAY/ -mindepth 1 -delete
mount -t aufs -o br=$OVERLAY=rw:$GOLD_COPY=ro none $CLIENT_HOME
