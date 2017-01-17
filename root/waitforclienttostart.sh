#!/bin/bash

while ! hasclientstarted.sh; do
	sleep 2
done
