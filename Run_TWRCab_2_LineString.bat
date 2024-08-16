@echo off
setlocal enabledelayedexpansion

:: Navigate to the directory where the batch file is located
cd /d "%~dp0"

echo.
echo.
echo Running System Checks...
echo.
echo.

:: Check if TWRCab_2_LineString.py exists in the same directory as the .bat file
if not exist "%~dp0TWRCab_2_LineString.py" (
    cls
    echo.
    echo.
    echo                            ---------
    echo                             WARNING
    echo                            ---------
    echo.
    echo "TWRCab_2_LineString.py" is not in the same directory as this .bat file
	echo.
	echo Please download/move TWRCab_2_LineString.py to this directory and restart
	echo this batch file:
	echo %~dp0
	echo.
	echo.
	echo Press any key to exit...
    pause>nul
    exit /b
)

:: Check if PowerShell is installed
powershell -command "exit" >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo.
    echo.
    echo                            ---------
    echo                             WARNING
    echo                            ---------
    echo.
    echo PowerShell is not installed or not available in the PATH.
	echo This script requires PowerShell to function properly.
	echo.
    echo Press any key to launch the website to download it from and install it.
    echo.
    echo Once complete, launch this batch file again.
    pause>nul
    start https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell
    exit /b
)

rem Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo.
    echo.
    echo                            ---------
    echo                             WARNING
    echo                            ---------
    echo.
    echo Python is required to run this script and I could not find it.
    echo Press any key to launch the website to download it from and install it.
    echo.
    echo Be sure to install it to "PATH" when prompted.
    echo.
    echo Once complete, launch this batch file again.
    pause>nul
    start https://www.python.org/downloads/
    exit /b
)

rem Check if Shapely and GeoJSON libraries are installed
python -c "import shapely, geojson" >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo                            ---------
    echo                             WARNING
    echo                            ---------
    echo.
    echo The required Python libraries "Shapely and GeoJSON" are not installed.
    echo.
    echo Press any key to install these libraries or close this window to exit...
    pause>nul
	
	echo.
	echo.
	echo Installing Shapely and Geojson libraries, please wait...
	echo.
	echo.
    
    python -m pip install shapely geojson
    
    if %errorlevel% neq 0 (
        echo.
        echo                            ---------
        echo                             WARNING
        echo                            ---------
        echo.
        echo     ... Errors with installation detected.
        echo.
        echo     Please read the errors above and attempt to resolve them
        echo     prior to launching this batch file again.
        echo.
        echo Press any key to exit...
        pause>nul
        exit /b
    )

    rem Recheck if the libraries were installed successfully
    python -c "import shapely, geojson" >nul 2>&1
    if %errorlevel% neq 0 (
        echo.
        echo                            ---------
        echo                             WARNING
        echo                            ---------
        echo.
        echo     ... Libraries still not detected after installation.
        echo         Please check the installation logs above.
        echo.
        echo Press any key to exit...
        pause>nul
        exit /b
    )
)

rem Ask user to select the input directory

cls

echo.
echo.
echo             ------------------------
echo              SELECT INPUT DIRECTORY
echo             ------------------------
echo.
echo Please select the input directory containing all the CRC
echo TWR-CAB .geojson files you want converted.
echo.
echo This script will convert ALL .geojson files contained within
echo your selected directory.

set inputDir=
for /f "tokens=*" %%i in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.FolderBrowserDialog; $f.Description = 'Select the input directory'; if($f.ShowDialog() -eq 'OK'){Write-Host $f.SelectedPath}"') do set inputDir=%%i
if not defined inputDir (
    echo ERROR... No input directory selected. Exiting.
    exit /b
)

cls

rem Ask user to select the output directory

cls

echo.
echo.
echo             -------------------------
echo              SELECT OUTPUT DIRECTORY
echo             -------------------------
echo.
echo Please select the output directory where all converted CRC
echo TWR-CAB .geojson files will be stored.

set outputDir=
for /f "tokens=*" %%i in ('powershell -command "Add-Type -AssemblyName System.Windows.Forms; $f = New-Object System.Windows.Forms.FolderBrowserDialog; $f.Description = 'Select the output directory'; if($f.ShowDialog() -eq 'OK'){Write-Host $f.SelectedPath}"') do set outputDir=%%i
if not defined outputDir (
    echo No output directory selected. Exiting.
    exit /b
)

cls

echo.
echo.
echo             ------------
echo              CONVERTING
echo             ------------
echo.

rem Process all .geojson files in the input directory
for %%f in ("%inputDir%\*.geojson") do (
    set fileName=%%~nf
    echo !fileName!
    python TWRCab_2_LineString.py "%%f" "%outputDir%\!fileName!.geojson"
    echo           --- converted
    echo.
)

echo Conversion complete and saved here:
echo %outputDir%
echo.
echo.
echo.
echo Press any key to exit...
pause>nul
