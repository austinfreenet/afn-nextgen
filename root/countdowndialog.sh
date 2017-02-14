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
--no-cancel \
--auto-kill \
--window-icon=question 2>&1 | grep -v "mapped without a transient parent"

# Note: you can ignore this warning:
# Gtk-Message: GtkDialog mapped without a transient parent. This is discouraged.  killing dialog
# It's related to: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=785691
