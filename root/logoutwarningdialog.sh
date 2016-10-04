#!/bin/bash

TIMEOUT=$1
countdowndialog.sh $TIMEOUT 'Are you still there?' 'Automatically logging out in $i seconds.  Move the mouse to keep working.' &
DIALOG_PID=$!
echo "dialog PID: $DIALOG_PID" >&2

IDLETIME=0
PREVIOUS_IDLETIME=0
while [ $IDLETIME -ge $PREVIOUS_IDLETIME ]; do
	PREVIOUS_IDLETIME=$IDLETIME
	IDLETIME=$(xprintidle)
	sleep 0.250
done
echo "killing dialog" >&2
pkill -P $DIALOG_PID
kill $DIALOG_PID
