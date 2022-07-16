#!/bin/bash

###     Title:          Website Integrity Script
###     Date:           16 July 2022
###     Author:         CJ Glawson
###     Version:        1.0.0

# Set the path of the files that are being checked

FILES="/var/www/html/*";

# Create a variable for the path to the file containing the NEW hashes

varPath="/var/log/wwwHash";

# Create a variable for the path to the file containing the OLD hashes

tmpPath="/tmp/wwwHash";

# If previous file does exist, move it to temp

if [[ -f $varPath ]];
        then mv $varPath $tmpPath;
fi

# Create NEW file for varPath

touch $varPath;

# Write the NEW hashes to the NEW file

for f in $FILES ;
        do if [[ ! -d $f ]]
                then md5sum -t $f >> $varPath;
        fi ;
done;

# This compares the hashes to see if there are ANY differences

if [[ $(diff "$varPath" "$tmpPath" | wc -c) -lt 2 ]];
then echo "The files in the WWW/html folder have not changed.";
else
        echo "The Files in the WWW/html folder have changed."
        echo "The following are the files that have changed:"
        #Output which files have changed
        diff $varPath $tmpPath;
fi
