#!/bin/bash

TIMEOUT=$1
if [ -z "$TIMEOUT" ]; then
	echo "please supply a timeout value" >&2
	exit 1
fi

TITLE=$2
[ -z "$TITLE" ] && TITLE="Progress"

TEXT=$3
[ -z "$TEXT" ] && TEXT='Doing something in $i seconds'

# Force Zenity Status message box to always be on top.
sleep 1 && wmctrl -r "$TITLE" -b add,above &

(
	for i in $(seq $TIMEOUT -1 1); do
		echo $i $TIMEOUT | awk '{printf("%.0f\n",(($2-$1)/$2)*100)}'
		echo "# $(eval echo "$TEXT")"
		sleep 1
	done
) |
zenity --progress \
--title="$TITLE" \
--percentage=0 \
--auto-close \
--auto-kill
