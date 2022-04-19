#!/bin/bash

echo "Pre-requisites enabler"

#for later,
#user=$(whoami)



##TO ADD CHECKER FOR DETARMINING PYTHON 2 or PYTHON3 (different commands are used for each calling each version)

python3PathCheck=$(which python3)


if [ "$python3PathCheck" = "/usr/bin/python3" ];

then

echo "python path is correct"


else echo "python default path does not seem correct, paths found: "

which -a python3 

fi



#might need to add a way to reset the terminal to avoid false positives for sudo no credentials requested
#example, if they had already typed the sudo creds for a different command under the same session, they will
#most likely be cached.


folderName="test"$(date +"%T")

echo "Testing folder creation with sudo, should not request any credentials"

sudo mkdir /opt/"$folderName"


if [ -d "/opt/""$folderName" ];

then

echo "Folder was created successfuly"

else

echo "Folder does not seem to exist. Please doublecheck /opt/ path"

fi









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
	#sleep 2
	sudo apt-get update
	sudo apt-get install net-tools
	echo "##### RESULTS #####"
	checkPackageNetTools Result

fi


