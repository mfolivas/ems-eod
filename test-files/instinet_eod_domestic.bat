@echo off
setlocal

REM *** EOD PROCESS ***
REM retrieves eod detail file, uploads into db, to be run daily after the close

REM *** VAR SETUP ***
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sDate /t REG_SZ /d - /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sShortDate /t REG_SZ /d yyyy-MM-dd /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v sTimeFormat /t REG_SZ /d "HH:mm:ss" /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v iTime /t REG_SZ /d 1 /f
reg add "HKEY_CURRENT_USER\Control Panel\International" /v iTLZero /t REG_SZ /d 1 /f

set DATESTRING=%date:~0,4%%date:~5,2%%date:~8,2%
set TIMESTRING=%time:~0,2%%time:~3,2%%time:~6,2%
REM if "%time:~0,1%"==" " set timestring=0%timestring:~1,5%
set LOGFILE=\\fileserver01\trading\eod_process.log
set SCRIPTFILE=eod_ftpscript.txt
set FTPSERVER=iftp.instinet.com
set USERNAME=Guzmanftp
set PASSWORD=Nam2!!0321
set FILENAME=ClientEODTradeDetail_Guzman_US_%DATESTRING%.csv

cd /d f:\trading

echo [%DATESTRING% %TIMESTRING%] *** instinet eod process beginning *** >> %LOGFILE%

echo creating ftp script >> %LOGFILE%
del /q %SCRIPTFILE%
echo user %USERNAME% %PASSWORD%	>> %SCRIPTFILE%
echo lcd f:\trading >> %SCRIPTFILE%
echo cd /pub/eod/ >> %SCRIPTFILE%
echo hash			>> %SCRIPTFILE%
echo get %FILENAME%		>> %SCRIPTFILE%
echo quit			>> %SCRIPTFILE%

echo attempting to download %FILENAME% >> %LOGFILE%

:getfilefromftp
echo.  [%TIME%] running ftp process >> %LOGFILE%
ftp -n -s:%SCRIPTFILE% %FTPSERVER%

if exist %FILENAME% (
    echo.  [%TIME%] eod file found! >> %LOGFILE%
) else (
    echo.  [%TIME%] eod file not found, will sleep for 60 sec and try again... >> %LOGFILE%
    timeout /t 60
    goto :getfilefromftp
)

del /q %SCRIPTFILE%

echo finished ftp portion, about to do java db insert >> %LOGFILE%

cd /d f:\apps\pts\GtsUtils\ems_eod

set version=ems-eod-1.18.jar
set PATH=f:\apps\utils\jdk1.7.0_17_32bit\bin

java -Xms1g -Xmx1g -jar dist\%version% %FILENAME%

echo process finished. >> %LOGFILE%
