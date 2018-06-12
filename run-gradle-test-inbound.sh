#!/bin/bash

# make sure Xvfb is running in background with screen id 1
export DISPLAY=:1

# fix chrome process hang
export DBUS_SESSION_BUS_ADDRESS=/dev/null

gradle --no-daemon clean runCucumberParallel -PforkCount=4 -Penvironment=qa -Ptags=@Inbound
