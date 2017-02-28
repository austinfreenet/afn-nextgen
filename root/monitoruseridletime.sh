#!/bin/bash

export DISPLAY=:0.0
export XAUTHORITY=/home/$CLIENTUSER/.Xauthority

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
	IDLETIME=$(xprintidle)
	if [ $? -ne 0 ]; then
		echo "get idle time failed"
		echo "we should logout"
		exit 0
	fi
	if [ $(($IDLETIME / 1000)) -gt $IDLEBEFOREWARN ]; then
		sudo -u $CLIENTUSER VBoxManage controlvm "$VMNAME" pause
		if logoutwarningdialog.sh $WARNTIME; then
			echo "we should logout"
			exit 0
		fi
		sudo -u $CLIENTUSER VBoxManage controlvm "$VMNAME" resume
	fi
	sleep 1
done
