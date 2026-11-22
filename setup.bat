@echo off
setlocal

REM ===========================================================================
REM  HolidaysFuncLibDemo - one-time setup (DataFlex 26)
REM
REM  The libraries the demo uses - HolidaysFuncLib, RDCToolsLib, DFAbout,
REM  vWin32fh, RDCFlexTron and Data Access's Web UI FlexTron - are NOT stored
REM  in this repository. HolidaysFuncLibDemo.sws names them as dependencies,
REM  and DataFlex's package manager installs them: into DfPkg\, and the web
REM  files into AppHtml\ and Bitmaps\. This script asks it to do that
REM  ("df-cli config"), then protects your local database (skip-local-data.cmd).
REM
REM  Re-run it any time - after a pull that moves a library version, say.
REM ===========================================================================

cd /d "%~dp0"

echo.
echo === HolidaysFuncLibDemo setup ===
echo Working folder: %CD%
echo.

REM DataFlex 26's command-line tool: from the registry, else the default folder, else the PATH.
set "DFCLI="
for /f "tokens=2,*" %%A in ('reg query "HKLM\SOFTWARE\Data Access Worldwide\DataFlex\26.0\Defaults" /v VDFRootDir 2^>nul ^| find "VDFRootDir"') do set "DFROOT=%%B"
if defined DFROOT if exist "%DFROOT%Bin64\df-cli.exe" set "DFCLI=%DFROOT%Bin64\df-cli.exe"
if not defined DFCLI if exist "%ProgramFiles%\DataFlex 26.0\Bin64\df-cli.exe" set "DFCLI=%ProgramFiles%\DataFlex 26.0\Bin64\df-cli.exe"
if not defined DFCLI for /f "delims=" %%P in ('where df-cli 2^>nul') do if not defined DFCLI set "DFCLI=%%P"

if not defined DFCLI (
    echo [ERROR] DataFlex 26 was not found ^(df-cli.exe^).
    echo         The demo needs DataFlex 26. Install it, then run setup.bat again.
    echo.
    pause
    exit /b 1
)

echo Installing the libraries the workspace names ^(df-cli config^)...
"%DFCLI%" config HolidaysFuncLibDemo.sws
if errorlevel 1 (
    echo.
    echo [ERROR] df-cli could not install the libraries - see the messages above.
    echo         Check your internet connection, then run setup.bat again.
    echo.
    pause
    exit /b 1
)

echo.
if exist "%~dp0skip-local-data.cmd" (
    echo Protecting your local Data\ database from accidental commits...
    call "%~dp0skip-local-data.cmd"
) else (
    echo [NOTE] skip-local-data.cmd not found - skipping local DB protection.
)

echo.
echo === Setup complete ===
echo.
echo Open HolidaysFuncLibDemo.sws in DataFlex Studio 26, then compile and run
echo HolidaysFuncLibTest.src.
echo.
pause
exit /b 0
