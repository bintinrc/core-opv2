#! /bin/sh

# make sure Xvfb is running in background with screen id 1
export DISPLAY=:1

/opt/gradle clean cucumberPrep -Penvironment=qa -Ptags=@selenium

