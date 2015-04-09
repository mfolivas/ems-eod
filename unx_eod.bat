@echo off
setlocal

REM *** UNX EOD PROCESS ***
REM retrieves eod detail file from unx, uploads into db, emails status report to be run daily after the close

REM *** VAR SETUP ***
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sDate /t REG_SZ /d - /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sShortDate /t REG_SZ /d yyyy-MM-dd /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sTimeFormat /t REG_SZ /d "HH:mm:ss" /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v iTime /t REG_SZ /d 1 /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v iTLZero /t REG_SZ /d 1 /f

set DATESTRING=%date:~0,4%%date:~5,2%%date:~8,2%
set TIMESTRING=%time:~0,2%%time:~3,2%%time:~6,2%
if "%time:~0,1%"==" " set timestring=0%timestring:~1,5%
set LOGFILE=unx_eod_log.txt
set SCRIPTFILE=unx_eod_ftpscript.txt
set FTPSERVER=partners.unx.com
set USERNAME=guzman
set PASSWORD=1unchb0x

REM *** BEGIN MAIN ***
cd /d f:\trading
echo ********************************* >> %LOGFILE%
echo *** UNX EOD PROCESS BEGINNING *** >> %LOGFILE%
echo %DATESTRING%T%TIMESTRING% >> %LOGFILE%

echo creating ftp script >> %LOGFILE%
del /q %SCRIPTFILE%
echo user %USERNAME% %PASSWORD%	>> %SCRIPTFILE%
echo hash			>> %SCRIPTFILE%
echo get GuzmanProdExecs%DATESTRING%.csv		>> %SCRIPTFILE%
echo quit			>> %SCRIPTFILE%

echo attempting to download GuzmanProdExecs%DATESTRING%.csv >> %LOGFILE%

:getfilefromftp
ftp -n -s:%SCRIPTFILE% %FTPSERVER%


if exist GuzmanProdExecs%DATESTRING%.csv (
    echo.   %TIME% eod file found! >> %LOGFILE%
) else (
    echo.   %TIME% eod file not found, will sleep for 60 sec and try again... >> %LOGFILE%
    sleep 60
    goto :getfilefromftp
)

del /q %SCRIPTFILE%

echo finished ftp portion, about to do java db insert >> %LOGFILE%


cd /d f:\apps\pts\GtsUtils\unx_eod\UNX

@echo off
set version=unx-eod-1.1.jar
set PATH=f:\apps\utils\jdk1.6.0_14\bin
clear
echo *********************************
echo ********** WELCOME ***************
echo * Running UNX EOD version: "%version%" *
java -version
echo **********************************

java -jar dist\%version%
echo process finised
