@echo off
setlocal

REM   The database host for "intranet" currently gts11 is maintained in this file ( not in Code )
rem 	if you change to gts11 SB03 ( for testing ) don't forget to put it back to gts11... 

REM *** UNX EOD PROCESS ***
REM retrieves eod detail file from unx, uploads into db, emails status report to be run daily @ 16:35 or whenever...


REM *** VAR SETUP ***
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sDate /t REG_SZ /d - /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sShortDate /t REG_SZ /d yyyy-MM-dd /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sTimeFormat /t REG_SZ /d "HH:mm:ss" /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v iTime /t REG_SZ /d 1 /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v iTLZero /t REG_SZ /d 1 /f


set DATESTRING=%date:~0,4%%date:~5,2%%date:~8,2%
set TIMESTRING=%time:~0,2%%time:~3,2%%time:~6,2%
if "%time:~0,1%"==" " set timestring=0%timestring:~1,5%
set STATUSFILE=unx_eod_status_%DATESTRING%_%TIMESTRING%.txt
set SCRIPTFILE=unx_eod_ftpscript.txt
set FTPSERVER=partners.unx.com
set USERNAME=guzman
set PASSWORD=1unchb0x



echo CD..
rem cd /d T:\
cd /d f:\apps\pts\GtsUtils\unx_eod\UNX		
echo UNX EOD PROCESS BEGINNING >> %STATUSFILE%
echo %DATESTRING%T%TIMESTRING% >> %STATUSFILE%


REM *** RETRIEVE FILE FROM UNX FTP ***
echo step 1 - retrieving file from ftp >> %STATUSFILE%

del /q %SCRIPTFILE%
echo user %USERNAME% %PASSWORD%	>> %SCRIPTFILE%
echo hash			>> %SCRIPTFILE%
echo get GuzmanProdExecs%DATESTRING%.csv		>> %SCRIPTFILE%
echo quit			>> %SCRIPTFILE%


rem -------------------
rem  Loop Start - If don't have file... come back here... try ftp again..., again, again
rem -------------------
:COMEHERE2
echo After COMEHERE2... sleep 3
sleep 3
rem -------------------
rem -------------------



:do_ftp
echo before ftp...
sleep 60
ftp -n -s:%SCRIPTFILE% %FTPSERVER%



rem -------------
rem -------------
rem -------------
echo if-not-exist file before... keep uncommented next 7 lines ... unless testing 
echo      GuzmanProdExecs%DATESTRING%.csv 
ls -l GuzmanProdExecs%DATESTRING%.csv 
if not exist  GuzmanProdExecs%DATESTRING%.csv  echo No Existing File GuzmanProdExecs%DATESTRING%.csv %TIME%   > CheckTest2.out
if not exist  GuzmanProdExecs%DATESTRING%.csv  goto :COMEHERE2 
rem -------------------
rem  Loop End - If don't have file... go back ... try ftp again..., again, again
rem -------------------

if     exist  GuzmanProdExecs%DATESTRING%.csv  echo  File found GuzmanProdExecs%DATESTRING%.csv %TIME%       > CheckTest3.out
if     exist  GuzmanProdExecs%DATESTRING%.csv  touch                       GuzmanProdExecs%DATESTRING%.csv   > CheckTest4.out
echo if-not-exist file after...is here...
echo sleep 30
sleep 30
rem ---- Tester COMEHERE2 ... keep commented when not testing ...
rem ----   Tester COMEHERE2 ... keep commented when not testing ...
rem echo          GuzmanProdExecs20110810.csv 
rem ls -l         GuzmanProdExecs20110810.csv 
rem if not exist  GuzmanProdExecs20110810.csv  echo No Existing File GuzmanProdExecs20110810.csv %TIME%   > CheckTest2.tst.out
rem if not exist  GuzmanProdExecs20110810.csv  goto :COMEHERE2 
rem -------------
rem -------------
rem -------------


echo do If Exist statusfile sleep 15...
sleep 15
IF EXIST GuzmanProdExecs%DATESTRING%.csv ECHO file GuzmanProdExecs%DATESTRING%.csv exists, success! >> %STATUSFILE%


REM *** INPUT FILE INTO INTRANET DB ***
echo step 2 - performing DB insert >> %STATUSFILE%



rem --------------------------------------------
rem --------------------------------------------
rem ... Actual 
echo Running Database Update...  uncomm single java line after testing...
rem    Running Database Update... java -Xmn Yg allow (1/4),   -Xms initial allow , -Xmx max allow, 
rem	           java -cp .;./sqljdbc.jar;./mail.jar;./tools.jar -jar UnxEodCsvRead.jar  GuzmanProdExecs%DATESTRING%.csv   gts11 -0   >> UNXEODreport%DATESTRING%.out  rem old...
     java -Xmn128m -Xms750m -Xmx750m -cp .;./sqljdbc.jar;./mail.jar;./tools.jar -jar UnxEodCsvRead.jar  GuzmanProdExecs%DATESTRING%.csv   gts11 -0   >> UNXEODreport%DATESTRING%.%TIMESTRING%.out 
rem ...
rem  ... Test Huge day test... comment when not in test...
rem       java -Xmn128m -Xms750m -Xmx750m -cp .;./sqljdbc.jar;./mail.jar;./tools.jar -jar UnxEodCsvRead.jar GuzmanProdExecs20110810.csv   cgitdevft01 -1   >> UNXEODreport.test.out 
echo Ran Database Update...


rem  java -cp .;./sqljdbc.jar;./mail.jar;./tools.jar -jar UnxEodCsvRead.jar  GuzmanProdExecs%DATESTRING%.csv   cgitdevft01  -0   >> UNXEODreport%DATESTRING%.out 
rem ... real run...
rem --------------------------------------------
rem --------------------------------------------


rem ... prod entries ... keep next 4 lines keep uncommented when not testing
echo UNXEODreport%DATESTRING%.%TIMESTRING%.out 
ls -l GuzmanProdExecs%DATESTRING%.csv 
copy /y GuzmanProdExecs%DATESTRING%.csv \\server19\\f$\\trading\\GuzmanProdExecs%DATESTRING%.%TIMESTRING%.csv
copy /y %STATUSFILE%   					\\server19\\f$\\trading\\%STATUSFILE% 
copy /y UNXEODreport%DATESTRING%.%TIMESTRING%.out    \\server19\\f$\\trading\\UNXEODreport%DATESTRING%.%TIMESTRING%.out 


rem
rem    testers... keep commented... when not testing...
rem echo UNXEODreport%DATESTRING%.out 
rem copy /y GuzmanProdExecs%DATESTRING%.csv \\server19\\f$\\trading\\GuzmanProdExecs%DATESTRING%.%TIMESTRING%.csv
rem copy /y %STATUSFILE%   					\\server19\\f$\\trading\\%STATUSFILE%.%TIMESTRING%  
rem copy /y UNXEODreport%DATESTRING%.out    \\server19\\f$\\trading\\%UNXEODreport.%DATESTRING%.out 


REM *** EMAIL STATUS REPORT ***
echo step 3 - emailing status report >> %STATUSFILE%
rem M:\systems\scripts\bmail -s enterprisealerts.corp.guzman.com -t systems@guzman.com -f unx_eod_noreply@guzman.com -h -a "UNX EOD STATUS %DATESTRING% %TIMESTRING%" -c -m %STATUSFILE%

touch   CheckTest5.out
copy /y CheckTest2.out    				\\server19\\f$\\trading\\
copy /y CheckTest3.out    				\\server19\\f$\\trading\\
copy /y CheckTest4.out    				\\server19\\f$\\trading\\
copy /y CheckTest5.out    				\\server19\\f$\\trading\\

rem pause