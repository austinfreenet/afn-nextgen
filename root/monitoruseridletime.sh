#!/bin/bash

while [ $# -gt 0 ]; do
	case $1 in
		-t | --timeout )
			shift
			TIMEOUT=$1
		;;
		-w | --warntime )
			shift
			WARNTIME=$1
		;;
	esac
	shift
done

if [ -z "$TIMEOUT" ]; then
	TIMEOUT=600
fi
if [ -z "$WARNTIME" ]; then
	WARNTIME=60
fi

IDLEBEFOREWARN=$(($TIMEOUT - $WARNTIME))
if [ $IDLEBEFOREWARN -lt 0 ]; then
	echo "error: timeout needs to be greater or equal to warntime" >&2
	exit 1
fi
while true; do
	if [ $(($(xprintidle) / 1000)) -gt $IDLEBEFOREWARN ]; then
		if logoutwarningdialog.sh $WARNTIME; then
			# we should logout
			echo "logout!"
		fi
	fi
	sleep 1
done
