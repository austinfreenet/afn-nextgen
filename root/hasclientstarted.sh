#!/bin/bash

pgrep -f "VirtualBox --startvm $VMNAME" > /dev/null && \
sudo -u $CLIENTUSER VBoxManage showvminfo "$VMNAME" | grep State | grep "running\|paused" > /dev/null
