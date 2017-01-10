#!/bin/bash

service lightdm status | grep Active: | grep running > /dev/null
