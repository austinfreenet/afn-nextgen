#!/bin/bash

export VMNAME="Windows 7"
export CLIENTUSER="user"

# shutdown any existing client session
if isclientsessionrunning.sh; then
	logoutclient.sh
	sleep 10
fi

while true; do
	echo "resetting client homedir"
	resetclienthomedir.sh
	echo "starting client session"
	startclientsession.sh
	sleep 10 # todo replace with something more robust
	echo "waiting for client to start"
	waitforclienttostart.sh
	echo "monitoring user idle time"
	monitoruseridletime.sh -t 300 -w 60
	echo "logging out client"
	logoutclient.sh
	sleep 10
done
