#!/bin/bash

TIMEOUT=$1
if [ -z "$TIMEOUT" ]; then
	echo "error: you must supply a timeout value" >&2
	exit 1
fi
countdowndialog.sh $TIMEOUT 'Are you still there?' 'Automatically logging out in $i seconds.  Move the mouse to keep working.' &
DIALOG_PID=$!
echo "debug: dialog PID: $DIALOG_PID" >&2

IDLETIME=0
PREVIOUS_IDLETIME=0
while [ $IDLETIME -ge $PREVIOUS_IDLETIME ] && pgrep -f countdowndialog | grep "^$DIALOG_PID\$" > /dev/null; do
	PREVIOUS_IDLETIME=$IDLETIME
	sleep 0.25
	IDLETIME=$(xprintidle)
done
if pgrep -f countdowndialog | grep "^$DIALOG_PID\$" > /dev/null; then
	echo "info: killing dialog" >&2
	pkill -P $DIALOG_PID
	kill $DIALOG_PID
	exit 2
else
	exit 0
fi
