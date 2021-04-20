@echo off
c:\lazarus9_26_2\fpc\2.2.2\bin\i386-win32\windres.exe --include c:\lazarus9_26_2\fpc\2.2.2\bin\i386-win32\ -O res -o "C:\Documents and Settings\tabcsnag\FeederProgik\FeederStatistic\FeederStatistic.res" FeederStatistic.rc --preprocessor=c:\lazarus9_26_2\fpc\2.2.2\bin\i386-win32\cpp.exe
if errorlevel 1 goto linkend
SET THEFILE=C:\Documents and Settings\tabcsnag\FeederProgik\FeederStatistic\FeederStatistic.exe
echo Linking %THEFILE%
c:\lazarus9_26_2\fpc\2.2.2\bin\i386-win32\ld.exe -b pe-i386 -m i386pe  --gc-sections   --subsystem windows --entry=_WinMainCRTStartup    -o "C:\Documents and Settings\tabcsnag\FeederProgik\FeederStatistic\FeederStatistic.exe" "C:\Documents and Settings\tabcsnag\FeederProgik\FeederStatistic\link.res"
if errorlevel 1 goto linkend
c:\lazarus9_26_2\fpc\2.2.2\bin\i386-win32\postw32.exe --subsystem gui --input "C:\Documents and Settings\tabcsnag\FeederProgik\FeederStatistic\FeederStatistic.exe" --stack 262144
if errorlevel 1 goto linkend
goto end
:asmend
echo An error occured while assembling %THEFILE%
goto end
:linkend
echo An error occured while linking %THEFILE%
:end
