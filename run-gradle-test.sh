#! /bin/sh

# make sure Xvfb is running in background with screen id 1
export DISPLAY=:1

# fix chrome process hang
export DBUS_SESSION_BUS_ADDRESS=/dev/null

trap 'kill -9 $OPV2_GRADLE_PID' TERM

gradle --no-daemon clean runCucumberParallel -PforkCount=4 -Penvironment=qa -Ptags=@OperatorV2 &

export OPV2_GRADLE_PID=$!
echo "[BAMBOO_INFO] OPV2 Gradle PID: ${OPV2_GRADLE_PID}"
wait
