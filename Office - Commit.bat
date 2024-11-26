@echo off

REM Get the current directory where the batch file is located
set "currentDir=%~dp0"

REM Get the computer's name
set "computerName=%COMPUTERNAME%"

REM Change directory to the current directory
cd /d "%currentDir%"

REM Check if there are any changes to commit
git diff-index --quiet HEAD || (
    REM Add all changes to the staging area, excluding package-lock.json and package.json
    git add --all :/
    git reset -- package-lock.json
    git reset -- package.json

    REM Commit changes with a generic message
    git commit -m "Automatic commit from %computerName%"

    REM Push changes to the remote repository
    git push origin main
)

REM Perform a pull operation (even if there were no changes to commit)
git pull origin main

REM Check if the pull was successful
if %errorlevel% == 0 (
    REM Show a success message for pull (and commit, if applicable)
    if %errorlevel% == 1 (
        REM Only pull was successful
        powershell -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Pull successful.', 'Success', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)"
    ) else (
        REM Commit, pull, and push were successful
        powershell -WindowStyle Hidden -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('Commit, pull, and push successful.', 'Success', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)"
    )
) else (
    REM Show an error message for pull
    echo Error during pull operation.
)

REM Exit the batch file
exit
