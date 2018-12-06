#!/bin/bash
# Script to add a user to import gateway
        read -p "Enter username (ex. joedalton for Joe Dalton): " username
        egrep "^$username" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
                echo "$username exists!"
                exit 1
        else
                sudo adduser $username --disabled-password
		sudo su - $username -c "umask 022 ; mkdir .ssh ; cd .ssh; touch authorised_keys id_rsa.pub onestack.pem config"
                [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"

        fi
