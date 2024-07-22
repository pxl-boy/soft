@echo off
setlocal enabledelayedexpansion

:menu
cls
echo _________________________________________________________________
echo.
echo  Activation Methods:
echo.
echo [1]    HWID            | Windows        | Permanent
echo [2]    Ohook           | Office         | Permanent
echo [3]    KMS38           | Windows        | Year 2038
echo [4]    Online KMS      | Windows / Office | 180 Days
echo _________________________________________________________________
echo [5] Activation Status
echo [6] Troubleshoot
echo [7] Extras
echo [8] Help
echo [0] Exit
echo.
echo Enter a menu option in the Keyboard [1,2,3,4,5,6,7,8,0] :

:: Automatically select option 1 if no input
set choice=1

:: Uncomment the next two lines to enable user input
:: set /p choice=
:: if "%choice%"=="" set choice=1

if "%choice%"=="1" goto hwid
if "%choice%"=="2" goto ohook
if "%choice%"=="3" goto kms38
if "%choice%"=="4" goto onlinekms
if "%choice%"=="5" goto status
if "%choice%"=="6" goto troubleshoot
if "%choice%"=="7" goto extras
if "%choice%"=="8" goto help
if "%choice%"=="0" goto exit

:hwid
echo HWID Activation selected
:: Place your HWID activation code here
goto end

:ohook
echo Ohook Activation selected
:: Place your Ohook activation code here
goto end

:kms38
echo KMS38 Activation selected
:: Place your KMS38 activation code here
goto end

:onlinekms
echo Online KMS Activation selected
:: Place your Online KMS activation code here
goto end

:status
echo Activation Status selected
:: Place your Activation Status code here
goto end

:troubleshoot
echo Troubleshoot selected
:: Place your Troubleshoot code here
goto end

:extras
echo Extras selected
:: Place your Extras code here
goto end

:help
echo Help selected
:: Place your Help code here
goto end

:exit
echo Exiting...
goto end

:end
pause
