#!/bin/bash

#log file for results
exec &> >(tee "ResultAgentChecks.txt")



echo
echo "Pre-requisites cheker for Linux / MacOS"
echo 

#check user logged
userLogged=$(whoami)

echo "if you receive any request for password from now until script finishes, it is possible that you pre-requisites are not correct"
echo
echo "logged in as user:  $userLogged"


#displaying the Linux release

echo 
echo "OS details found:" 
cat /etc/*release 
echo 

#To check for a list of commands that the user is allowed to run:


sudo -l 

echo

# Some systems seem to have both python and python3, handling both scenarios.

# all python and python3 commands required


python3PathCheck=$(which python3 2> /dev/null)

python3CommandCheck=$(python3 -V 2> /dev/null)



pythonPathCheck=$(which python 2> /dev/null)

#this one specifically needs a different way as python command sends it to stderr...

pythonCommandCheck=$(which -a python 2> /dev/null)

pythonVersionCheck=`python -V 2>&1 /dev/null`





echo "Checking for python commands:"
#python checks (valid for python & python2)


if [ "$pythonCommandCheck" = "" ];

then
echo "python command is not found"

else

echo "python command is found and reports: " "$pythonVersionCheck"


#exporting all python paths to the log file only, incase maybe there is an extra path causing an issue? some builds seem to report multiple secondary paths

echo "all paths found for which -a python command:" 
which -a python

	#if python command is found, verify required path matches installed

	if [ "$pythonPathCheck" = "/usr/bin/python" ];

	then
	echo "python path is correct: $pythonPathCheck" 
	echo "Checked for sqlite3 module in the python installation, error will only appear bellow if not found" 
	python -c "import sqlite3" 2>&1

	else
	echo "python default path does not seem correct, paths found: " 

	which -a python 

	fi


fi


echo

echo "Checking for python3 commands:" 


#python3 checks (only valid for python3)

if [ "$python3CommandCheck" = "" ];

then

echo "python3 command is not found" 


else

echo "python3 command is found and reports:" "$python3CommandCheck" 

#exporting all python3 paths to the log file only, incase maybe there is an extra path causing an issue? some builds seem to report multiple secondary paths

echo "all paths found for which -a python3 command:" 

which -a python3 

	if [ "$python3PathCheck" = "/usr/bin/python3" ];

	then

	echo "python3 path is correct: $python3PathCheck" 

	echo "Checked for sqlite3 module in the python3 installation, error will only appear bellow if not found" 
        python3 -c "import sqlite3" 2>&1 

	echo "Checked for lib2to3 module in the python3 installation, error will only appear bellow if not found" 
	python3 -c "from lib2to3.main import main" 2>&1 

	else
	echo "python3 default path does not seem correct, paths found: " 

	which -a python3 

	fi



fi



#Might need to add a way to reset the terminal to avoid false positives for sudo no credentials requested
#example, if they had already typed the sudo creds for a different command under the same session, they will
#most likely be cached.

echo 
folderName="testDir"$(date +"%T")

echo "Testing folder creation with sudo, should not request any credentials" 

sudo mkdir /opt/"$folderName" 


if [ -d "/opt/""$folderName" ];

then

echo "Temporary test folder was created successfuly" 

sudo rm -r /opt/$folderName 

echo "Temporary test folder was deleted as part of script cleanup" 


else

echo "Folder does not seem to exist. Please doublecheck /opt/ path" 

fi



echo 
echo "checking for net-tools package" 



#Currently not in use for the installation, just reporting on net-tools status.
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
	#echo "Proceeding with get-update and installation." 
	#sleep 2
	#removing the auto installations of net-tools for now
	#sudo apt-get update 
	#sudo apt-get install net-tools 
	echo "installation of net-tools is required"
	#checkPackageNetTools Result

fi






## TO ADD RESULTS OF SCRIPT AS A SUMMARY BLOCK#




#END OF SCRIPT CONFIRMATION

echo 
echo "Script ended, if you had to type any sudo credentials during the execution of this script there is an issue with the configuration" 
echo "please notify and provide $logFileName to support located at the current working directory ( $(pwd) )" 
echo

