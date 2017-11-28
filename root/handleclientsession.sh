#!/bin/bash

# put our directory in the PATH
PATH=$(dirname $(realpath $0)):$PATH

export VMNAME="Windows 10"
export CLIENTUSER="client"

# shutdown any existing client session
if isclientsessionrunning.sh; then
	logoutclient.sh
fi

while true; do
	echo "resetting client homedir"
	resetclienthomedir.sh
	echo "starting client session"
	startclientsession.sh
	echo "waiting for client to start"
	waitforclienttostart.sh
	echo "monitoring user idle time"
	monitoruseridletime.sh -t 300 -w 60
	echo "logging out client"
	logoutclient.sh
done
