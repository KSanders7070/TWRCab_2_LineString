@echo off
setlocal enabledelayedexpansion

rem Navigate to the directory where the batch file is located
cd /d "%~dp0"

set testMode=T
if /i "!testMode!"=="T" (
	set bcg=20
	set filters=20
	set "style=solid"
	set thickness=1
	set args=!bcg! !filters! !style! !thickness!
	set "inputDir=C:\Users\ksand\OneDrive\Desktop\PROJFOLDER\TWRCab_2_LineString\original cab files"
	set "outputDir=C:\Users\ksand\OneDrive\Desktop\PROJFOLDER\TWRCab_2_LineString\converted files"
	goto testStart
)

echo.
echo.
echo Running System Checks...
echo.
echo.

rem Check if TWRCab_2_LineString.py exists in the same directory as the .bat file
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

rem Check if PowerShell is installed
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

:QueryDefaults

cls

rem Prompt user for optional ERAM Defaults to be added

echo                     -------------------
echo                      CRC ERAM DEFAULTS
echo                     -------------------
echo.
echo      Do you want to add LineDefaults to the converted files
echo      so that they may be displayed in a CRC-ERAM window?
echo      -BCG, FILTERS, STYLE, and THICKNESS
echo.
echo        Note: The values entered will be applied
echo              to every exported file.
echo.
echo.
echo.
set /p AddDefaults=Type Y or N and press Enter: 
	if /i "!AddDefaults!"=="Y" goto AddDefaults
	if /i "!AddDefaults!"=="N" goto SelectDirectories
	goto QueryDefaults

:AddDefaults

:inputBCG

cls

echo.
echo ERAM BRIGHTNESS CONTROL GROUP "BCG"
echo.
set /p bcg=Type a value between 1 and 40 to be assigned to the BCG and press Enter: 

if "!bcg!"=="" goto inputBCG
for /f "delims=0123456789" %%a in ("!bcg!") do goto inputBCG
if "!bcg!" lss "1" goto inputBCG
if "!bcg!" gtr "40" goto inputBCG

:inputFilters

cls

echo.
echo.
echo VALUES SET SO FAR...
echo.
echo      BCG = "!bcg!"
echo.
echo.
echo.
echo.
echo ERAM FILTERS
echo.
echo Type a list of filters values between 1 and 40 separated
echo by commas, if more than one. Spaces are optional.
echo.
echo      Example 1: 4
echo      Example 2: 1, 2, 8, 13, 32
echo      Example 3: 1,2,8,13,32
echo.
set /p filters=Type a list of filters values between 1 and 40 as instructed above, then press Enter: 

rem Remove spaces
set filters=!filters: =!

rem Check if variable is blank
if "!filters!"=="" goto inputFilters

rem Parse through the filters string, delimited by commas
for %%i in (!filters!) do (
    rem Check if the value contains only numbers
    for /f "delims=0123456789" %%j in ("%%i") do goto inputFilters

    rem Check if the value is within the valid range
    if "%%i" lss "1" (
        goto inputFilters
    ) else if "%%i" gtr "40" (
        goto inputFilters
    )
)

:inputStyle

cls

echo.
echo.
echo VALUES SET SO FAR...
echo.
echo      BCG = "!bcg!"
echo      FILTERS = "!filters!"
echo.
echo.
echo.
echo.
echo LINE STYLE
echo.
echo      S    - solid
echo      SD   - shortDashed
echo      LD   - longDashed
echo      LDSH - longDashShortDash
echo.
set /p styleCode=Type the letter combination associated with your desired style and press Enter: 

if "!styleCode!"=="" goto inputStyle
if /i "!styleCode!"=="S" set "style=solid" & goto inputThickness
if /i "!styleCode!"=="SD" set "style=shortDashed" & goto inputThickness
if /i "!styleCode!"=="LD" set "style=longDashed" & goto inputThickness
if /i "!styleCode!"=="LDSH" set "style=longDashShortDash" & goto inputThickness
goto inputStyle

:inputThickness

cls

echo.
echo.
echo VALUES SET SO FAR...
echo.
echo      BCG = "!bcg!"
echo      FILTERS = "!filters!"
echo      STYLE = "!style!"
echo.
echo.
echo.
echo.
echo LINE THICKNESS
echo.
set /p thickness=Type a thickness value between 1 and 3 and press Enter: 

if "!thickness!"=="" goto inputThickness
for /f "delims=0123456789" %%a in ("!thickness!") do goto inputThickness
if "!thickness!" lss "1" goto inputThickness
if "!thickness!" gtr "3" goto inputThickness

rem Set args
if defined bcg (
    set args=!bcg! !filters! !style! !thickness!
) else (
    set args=
)

:SelectDirectories

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

:testStart

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
    python TWRCab_2_LineString.py "%%f" "%outputDir%\!fileName!.geojson" %args%
    echo           --- done
    echo.
)

echo.
echo.
echo.
echo                         ------
echo                          DONE
echo                         ------
echo.
echo Conversion script complete and converted files saved here:
echo %outputDir%
echo.
echo Please check above for any errors that may have been encountered.
echo.
echo Press any key to exit...
pause>nul
