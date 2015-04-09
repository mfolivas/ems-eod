#!/bin/sh
######################################################################
# Pass parameters for the FTP (HOST, USER, PASSWORD)
# and the name of the file and the location to store it
######################################################################

die () {
    echo >&5 "$@"
    exit 1
}

[ "$#" -ge 1 ] || die "Need all five parameters fpt host, ftp user, ftp pass, file, and location of storing it, $# provided"

FTP_HOST=$1
FTP_USER=$2
FTP_PASSWD=$3
FILE_NAME=$4
PROCESSIONG_LOCATION=$5

echo "Moving to the processing location"
cd $PROCESSIONG_LOCATION
echo "Ready to start executing ftp in location `pwd`"

echo "Starting the ftp fetching with the following parameters $FTP_HOST using user: $FTP_USER and fetching file $FILE_NAME"

ftp -n $FTP_HOST << END_SCRIPT
quote USER $FTP_USER
quote PASS $FTP_PASSWD
get $FILE_NAME
quit
END_SCRIPT

if [ -f $FILE_NAME]
then
	echo "FTP worked"
else
	echo "FTP did not work"
fi
echo "Finished the fpt transaction"
