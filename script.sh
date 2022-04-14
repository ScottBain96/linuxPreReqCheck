#!/bin/bash

echo "Pre-requisites enabler"

#for later
#user=$(whoami)


echo "checking for net-tools package"

#Function that will check the installed package Net-tools. Using a function to re-check if the install was successfull.

function checkPackageNetTools () {    


checkNetPkgs=$(sudo dpkg-query -l | grep -c "net-tools")

local  __resultvar=$1

if [ "$checkNetPkgs" = "1" ];

        then
               local myresult='1'
                echo "Net-tools package is confirmed installed"

        else

               local myresult='0'
               echo "Net-Tools is not installed"


fi

    eval $__resultvar="'$myresult'"
}


##calling function result

checkPackageNetTools Result


if [ "$Result" = "1" ];

then

	echo "Net-tools package is already installed, skipping..."

else
	echo "Proceeding with get-update and installation."
	sleep 2
	sudo apt-get update
	sudo apt-get install net-tools
	echo "##### RESULTS #####"
	checkPackageNetTools Result

fi


