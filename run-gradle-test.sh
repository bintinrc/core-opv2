#! /bin/sh

# make sure Xvfb is running in background with screen id 1
export DISPLAY=:1

# fix chrome process hang
export DBUS_SESSION_BUS_ADDRESS=/dev/null

/opt/gradle --no-daemon clean runCucumber -Penvironment=qa -Ptags=@Sample
