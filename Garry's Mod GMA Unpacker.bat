@echo off
setlocal enabledelayedexpansion

:: Set the user's GMod folder
echo Enter your GMod folder path:
set /p folder=

cls

:: Set the addons and gmad.exe paths
set "addons=%folder%\garrysmod\addons"
set "gmad_exe=%folder%\bin\gmad.exe"

:: Create the Manual-Adding Files folder
set "folder2=%addons%\Manual-Adding Files"
if not exist "%folder2%" md "%folder2%"

:: Count total .gma files
set totalFiles=0
for %%x in ("%addons%\*.gma") do set /a totalFiles+=1

:: Check if there are any .gma files
if %totalFiles%==0 (
    echo No .gma files found in the specified directory.
    pause
    exit
)

:: Initialize file counter
set /a fileCount=0

:: Process each .gma file
for %%G in ("%addons%\*.gma") do (
    set "gma_file=%%~nxG"
    set "gma_size=%%~zG"

    :: Convert size to KB and GB
    set /a gma_size_kb=gma_size/1024
    set /a gma_size_gb=gma_size_kb/1024/1024

    :: Check if size is greater than or equal to 1 GB
    if !gma_size_gb! geq 1 (
        set "display_size=!gma_size_gb! GB"
    ) else (
        set "display_size=!gma_size_kb! KB"
    )

    set "extracted_folder=%addons%\%%~nG"

    :: Extract the .gma file
    "%gmad_exe%" extract -file "%%G" -out "!extracted_folder!" >nul 2>&1

    :: Move the extracted files to folder2 and remove the extracted folder
    xcopy /s /i /y "!extracted_folder!" "!folder2!" >nul 2>&1
    rd /s /q "!extracted_folder!"

    :: Update and display progress
    set /a fileCount+=1
    set /a percent=fileCount*100/totalFiles

    cls

    :: Display file information and progress
    echo !display_size! - !gma_file!
    echo Progress: !percent!%%
)

cls

:: Create README.txt
(echo Thank you for using my script!) > "%folder2%\README.txt"
(echo With this completion, you now have the choice of moving these to your GarrysMod\garrysmod, OR you can use the embedded .bat script!) >> "%folder2%\README.txt"
(echo If you are doing it manually, make sure to delete this folder once you are finished.) >> "%folder2%\README.txt"

echo @echo off >> "%folder2%\AutoMover.bat"
echo setlocal enabledelayedexpansion >> "%folder2%\AutoMover.bat"
echo set "currentDir=%%cd%%" >> "%folder2%\AutoMover.bat"
echo set "gmodDir=%%currentDir%%\..\..\..\garrysmod" >> "%folder2%\AutoMover.bat"
echo for /D %%%%i in ("%%currentDir%%\*") do ( >> "%folder2%\AutoMover.bat"
echo     set "folderName=%%%%~nxi" >> "%folder2%\AutoMover.bat"
echo     xcopy /s /i /y "%%%%i" "%%gmodDir%%\!folderName!" >nul 2^>^&1 >> "%folder2%\AutoMover.bat"
echo ) >> "%folder2%\AutoMover.bat"
echo echo Operation complete. >> "%folder2%\AutoMover.bat"
echo pause >> "%folder2%\AutoMover.bat"


cls
echo Finished.
start "" "%folder2%"
pause
