#!/usr/bin/env bash

#	Assing permission to this file: ex. chmod +x install.sh 
#	Run as ./install.sh

FOLDER=$1
FILE=$2


echo "# Connecting to ADB server" 
if adb devices | grep -q COMMAND_FAILED ; then
	echo "# Can not connect to adb server"
	exit 1;
fi

adb devices

echo "# Accessing to $FOLDER folder" 
if cd $FOLDER | grep -q COMMAND_FAILED ; then
	echo "# Can not access to $FOLDER"
	exit 1;
fi

cd $FOLDER

echo "# Installing $FILE" 
if adb install $FILE | grep -q COMMAND_FAILED ; then
	echo "# Can not install $FILE"
	exit 1;
fi

adb install $FILE

echo "# Restarting ABD server"
if adb kill-server | grep -q COMMAND_FAILED ; then
	echo "# Can not restart adb server"
	exit 1;
fi

adb kill-server

echo "Done!"