#!/bin/bash
# Script to add a user to import gateway
if [ $(id -u) -eq 0 ]; then
	read -p "Enter username (ex. joedalton for Joe Dalton): " username
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		sudo adduser $username --disabled-password
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi
