#!/bin/sh
###################################
# Start application so that it uploads
# all the international files
###################################

##############################################
##### CONFIGURATION OF HOMES DIRECTORIES #####
##############################################
JAVA_HOME=/usr
GROOVY_HOME=/opt/groovy

export SVN_EDITOR=vi
export PATH USER LOGNAmE MAIL HOSTNAME HISTSIZE INPUTRC JAVA_HOME GROOVY_HOME
export PATH=$JAVA_HOME:$GROOVY_HOME/bin:$PATH

TRADE_DATE=$1 #The tradedate has to be in the format: yyyymmdd. For example, 20120412
MAIN_DIRECTORY=/opt/eod_ems/
MAIN_APPLICATION=src/com/guzman/unx/eod/main/EodServiceMain.groovy
cd $MAIN_DIRECTORY

echo "--------------------------------------------------------------------------------------"
echo "--------------------------------`date`-----------------------------"
echo "-------------------START UPLOAD INTTERNATIOANAL Process ---------------------------"
echo "--------------------------------------------------------------------------------------"

groovy -cp src $MAIN_APPLICATION MANUAL $TRADE_DATE
echo "--------------------------------------------------------------------------------------"
echo "-----------------------------`date`-----------------------------"
echo "-------------------FINISHED UPLOAD INTTERNATIOANAL Process ---------------------------"
echo "--------------------------------------------------------------------------------------"


