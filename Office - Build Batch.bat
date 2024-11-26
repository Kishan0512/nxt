@echo off

REM Get the current directory where the batch file is located
set "currentDir=%~dp0"

cd /d "%currentDir%"

flutter build apk

REM Exit the batch file
exit
