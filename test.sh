#!/bin/bash


OUTPUT=$(python3 -V)
echo "$OUTPUT"





pythonCommandCheck=$(python3 -V 2> /dev/null)

if [ "$pythonCommandCheck" = "" ];

then
echo "python command is not found" 

else
echo "python command is found and reports:" "$pythonCommandCheck" 

fi





#MULTILINE=$(python \
 #  -1)
#echo "${MULTILINE}"
