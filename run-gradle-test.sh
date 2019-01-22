#!/bin/bash

# Make sure Xvfb is running in background with screen ID 1.
export DISPLAY=:1

# Fix Chrome process hang.
export DBUS_SESSION_BUS_ADDRESS=/dev/null

trap 'kill -9 $GRADLE_PID' TERM

gradle --no-daemon --continue clean runCucumberParallel allureReport -PforkCount=4 -Penvironment=qa-sg -Ptags=@OperatorV2 &

export GRADLE_PID=$!
echo "[BAMBOO_INFO] Gradle PID: ${GRADLE_PID}"
wait

pushd build/reports/allure-report
zip -r "${bamboo.build.working.directory}/build/reports/allure-report/allure-report.zip" .
popd
