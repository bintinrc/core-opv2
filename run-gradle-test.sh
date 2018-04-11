#! /bin/sh

# make sure Xvfb is running in background with screen id 1
export DISPLAY=:1

# fix chrome process hang
export DBUS_SESSION_BUS_ADDRESS=/dev/null

_term() {
  echo "Caught SIGTERM signal!"
  kill -TERM "$child" 2>/dev/null
}

trap _term SIGTERM

echo "Doing some initial work...";
gradle --no-daemon clean runCucumberParallel -PforkCount=4 -Penvironment=qa -Ptags=@OperatorV2 &

child=$!
wait "$child"