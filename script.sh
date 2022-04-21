#
#!/bin/bash

echo "Pre-requisites cheker for Linux / MacOS"

#log file for results


logFileName="resultsLinuxCheck.txt"
#check user logged
userLogged=$(whoami)

echo "if you receive any request for password from now until script finishes, it is possible that you pre-requisites are not correct"

echo "logged in as user:  $userLogged" | tee $logFileName


#displaying the Linux release


cat /etc/*release | tee -a $logFileName  >/dev/null 2>&1


#To check for a list of commands that the user is allowed to run:


sudo -l | tee -a $logFileName 



# Some systems seem to have both python and python3, handling both scenarios.

# all python and python3 commands required


python3PathCheck=$(which python3 2> /dev/null)

python3CommandCheck=$(python3 -V 2> /dev/null)



pythonPathCheck=$(which python3 2> /dev/null)

pythonCommandCheck=$(python -V 2> /dev/null)



#Checking if required lib2to3 module is available in the python3 installation. 


echo "Checking for python and python3 commands:"


#python checks (valid for python & python2)


if [ "$pythonCommandCheck" = "" ];

then
echo "python command is not found" | tee -a $logFileName



else "python command is found and reports: ""$pythonCommandCheck" | tee -a $logFileName


#exporting all python paths to the log file only, incase maybe there is an extra path causing an issue? some builds seem to report multiple secondary paths

echo "all paths found for which -a python command:" | tee -a $logFileName  >/dev/null 2>&1

which -a python | tee -a $logFileName  >/dev/null 2>&1

	#if python command is found, verify required path matches installed

	if [ "$pythonPathCheck" = "/usr/bin/python" ];

	then

	echo "python path is correct: $pythonPathCheck" | tee -a $logFileName


	else echo "python default path does not seem correct, paths found: " | tee -a $logFileName

	which -a python | tee -a $logFileName

	fi


fi



#python3 checks (only valid for python3)

if [ "$python3CommandCheck" = "" ];

then

echo "python3 command is not found" | tee -a $logFileName


else

echo "python3 command is found and reports:" "$python3CommandCheck" | tee -a $logFileName

#exporting all python3 paths to the log file only, incase maybe there is an extra path causing an issue? some builds seem to report multiple secondary paths

echo "all paths found for which -a python3 command:" | tee -a $logFileName  >/dev/null 2>&1

which -a python3 | tee -a $logFileName  >/dev/null 2>&1

	if [ "$python3PathCheck" = "/usr/bin/python3" ];

	then

	echo "python3 path is correct: $python3PathCheck" | tee -a $logFileName

	echo "Checked for lib2to3 module in the python3 installation, if missing, error will appear bellow..." | tee -a $logFileName
	python3 -c "from lib2to3.main import main" 2>&1 | tee -a $logFileName

	else echo "python3 default path does not seem correct, paths found: " | tee -a $logFileName

	which -a python3 | tee -a $logFileName

	fi



fi



#Might need to add a way to reset the terminal to avoid false positives for sudo no credentials requested
#example, if they had already typed the sudo creds for a different command under the same session, they will
#most likely be cached.


folderName="testDir"$(date +"%T")

echo "Testing folder creation with sudo, should not request any credentials" | tee -a $logFileName 

sudo mkdir /opt/"$folderName" | tee -a $logFileName


if [ -d "/opt/""$folderName" ];

then

echo "Temporary test folder was created successfuly" | tee -a $logFileName 

sudo rm -r /opt/$folderName | tee -a $logFileName

echo "Temporary test folder was deleted as part of script cleanup" | tee -a $logFileName


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
	#echo "Proceeding with get-update and installation." | tee -a $logFileName
	#sleep 2
	#removing the auto installations of net-tools for now
	#sudo apt-get update | tee -a $logFileName
	#sudo apt-get install net-tools | tee -a $logFileName
	echo "installation of net-tools required"
	#checkPackageNetTools Result

fi






## TO ADD RESULTS OF SCRIPT AS A SUMMARY BLOCK#




#END OF SCRIPT CONFIRMATION


echo "Script ended, if you had to type any sudo credentials during the execution of this script there is an issue with the configuration" 
echo "please notify and provide $logFileName to support located at the current working directory ( $(pwd) )" | tee -a $logFileName
