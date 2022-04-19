#!/bin/bash

echo "Pre-requisites cheker for Linux / MacOS"

#log file for results


logFileName="logPreReq-"$(date +"%T")".txt"

#check user logged
userLogged=$(whoami)


echo "logged in as user:  $userLogged" | tee $logFileName


#displaying the Linux release


cat /etc/*release | tee -a $logFileName


#To check for a list of commands that the user is allowed to run:


sudo -l | tee -a $logFileName 



##TO ADD CHECKER FOR DETARMINING PYTHON 2 or PYTHON3 (different commands are used for each calling each version)

python3PathCheck=$(which python3)


if [ "$python3PathCheck" = "/usr/bin/python3" ];

then

echo "python path is correct: $python3PathCheck" | tee -a $logFileName 


else echo "python default path does not seem correct, paths found: " | tee -a $logFileName 

which -a python3 | tee -a $logFileName

fi



#might need to add a way to reset the terminal to avoid false positives for sudo no credentials requested
#example, if they had already typed the sudo creds for a different command under the same session, they will
#most likely be cached.


folderName="testDir"$(date +"%T")

echo "Testing folder creation with sudo, should not request any credentials" | tee -a $logFileName 

sudo mkdir /opt/"$folderName" | tee -a $logFileName


if [ -d "/opt/""$folderName" ];

then

echo "Folder was created successfuly" | tee -a $logFileName 

else

echo "Folder does not seem to exist. Please doublecheck /opt/ path" | tee -a $logFileName

fi









echo "checking for net-tools package" | tee -a $logFileName
 


#Function that will check the installed package Net-tools. Using a function to re-check if the install was successfull.

function checkPackageNetTools () {

checkNetPkgs=$(sudo dpkg-query -l | grep -c "net-tools")

local  __resultvar=$1

if [ "$checkNetPkgs" = "1" ];

        then
               local myresult='1'
                echo "Net-tools package is confirmed installed" | tee -a $logFileName

        else

               local myresult='0'
               echo "Net-Tools is not installed" | tee -a $logFileName


fi

    eval $__resultvar="'$myresult'"
}


##calling function result

checkPackageNetTools Result


if [ "$Result" = "1" ];

then

	echo "Net-tools package is already installed, skipping..." | tee -a $logFileName

else
	echo "Proceeding with get-update and installation." | tee -a $logFileName
	#sleep 2
	sudo apt-get update | tee -a $logFileName
	sudo apt-get install net-tools | tee -a $logFileName
	echo "##### RESULTS #####"
	checkPackageNetTools Result

fi


#END OF SCRIPT CONFIRMATION


echo "Script ended, please provide results to support" | tee -a $logFileName
