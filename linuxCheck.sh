#!/bin/bash

#Removed log file functionality as was missing any user input requests (example, if user was requested to add sudo creds).
#log file for results
#exec &> >(tee "ResultAgentChecks.txt")


#forget sudo password (incase it has been already provided before this command).
#The point of this script is that the password should not be requested for any command

sudo -K


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



# Some systems seem to have both python and python3, handling both scenarios.

# all python and python3 commands required


python3PathCheck=$(which -a python3 | grep /usr/bin/python3 2> /dev/null)

python3CommandCheck=$(python3 -V 2> /dev/null)



pythonPathCheck=$(which -a python | grep /usr/bin/python 2> /dev/null)

#this one specifically needs a different way as python command sends it to stderr...

pythonCommandCheck=$(which -a python 2> /dev/null)

pythonVersionCheck=`python -V 2>&1 /dev/null`

#Specific scenario for no python command, but python2 exists.

python2CommandCheck=$(which -a python2 2> /dev/null)


#to add version checks for python to make sure they meet minimum required version e,g 2.6+ for python



echo "Checking for python commands:"
#python checks (valid for python & python2)


if [ "$pythonCommandCheck" = "" ];

then

	echo "python command is not found."

	if [ "$python2CommandCheck" != "" ];
	then
		echo "python2 is found but it is NOT configured correctly (must be accessible by running command python)"
	fi

	echo "Please note, for ITOM versions under 5006-1, you must have python command configured to point to python or python2 version"

else

	echo "python command is found and reports: " "$pythonVersionCheck"


	#exporting all paths

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
echo "please note, python3 is only valid for ITOM 5006-1 or higher"

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


echo

#folder with unique name
folderName="testDir"$(date +"%T")


echo "Testing folder creation with sudo, should not request any credentials" 

sudo -K

sudo mkdir /opt/"$folderName"


if [ -d "/opt/""$folderName" ];

then

	echo "Temporary test folder was created successfuly" 

	sudo rm -r /opt/$folderName 

	echo "Temporary test folder was deleted as part of script cleanup" 


else

	echo "Folder does not seem to exist. Please doublecheck /opt/ path" 

fi

#To check for a list of commands that the user is allowed to run:

echo
echo "Listing all available commands (this one doesn't matter if it fails to access)"
echo
sudo -l


#determining what type of package manager is available

testDPKG=$(dpkg --version 2> /dev/null)
testYUM=$(yum --version 2> /dev/null)
commandToUse=""



if [ "$testDPKG" == "" ];
then
	echo "dpkg is not available in this set up"
	if [ "$testYUM" == "" ];
	then
		echo "could not find either yum or dpkg"
	else
		echo "YUM is available in this set up"
		commandToUse="yum"
	fi

else

	commandToUse="dpkg"
	echo
	echo "DPKG is available in the set up"

fi


echo
echo "checking for net-tools package"



if [ "$commandToUse" = "dpkg" ];
then
	checkNetPkgs=$(sudo dpkg-query -l | grep -c "net-tools")

	if [ "$checkNetPkgs" = "1" ];
        then
        	echo "Net-tools package is confirmed installed"
	else
		echo "Net-tools package is not installed"
	fi

elif [ "$commandToUse" = "yum" ];
then
	checkNetPkgs=$(sudo yum list installed | grep net-tools)
	if [ "$checkNetPkgs" = "" ];
        then
        	echo "Net-tools package is not installed"
        else
        	echo "Net-tools package is installed"
        fi

else
	echo "Not found any valid way to verify net-tools package, please confirm manually"

fi



echo 
echo "Script completed, if you had to type any sudo credentials during the execution of this script, you most likely have issues with pre-requisite command permissions" 
echo "please provide the results of the script to support" 
echo

