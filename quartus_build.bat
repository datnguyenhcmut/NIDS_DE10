@echo off
REM Quartus synthesis script for DE10-Standard

set QUARTUS_PATH=C:\intelFPGA\18.1\quartus\bin64

cd quartus_project

echo ====================================
echo Quartus Synthesis for DE10-Standard
echo ====================================

echo.
echo [1/4] Analysis and Elaboration...
"%QUARTUS_PATH%\quartus_map.exe" nids --analysis_and_elaboration

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Analysis failed!
    pause
    exit /b 1
)

echo.
echo [2/4] Full Synthesis and Mapping...
"%QUARTUS_PATH%\quartus_map.exe" nids

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Synthesis failed!
    pause
    exit /b 1
)

echo.
echo [3/4] Fitter (Place and Route)...
"%QUARTUS_PATH%\quartus_fit.exe" nids

if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Fitting failed!
    pause
    exit /b 1
)

echo.
echo [4/4] Timing Analysis...
"%QUARTUS_PATH%\quartus_sta.exe" nids

echo.
echo ====================================
echo Synthesis Complete!
echo ====================================
echo.
echo Check reports:
echo   quartus_project/output_files/nids.fit.summary
echo   quartus_project/output_files/nids.sta.rpt
echo.
pause
