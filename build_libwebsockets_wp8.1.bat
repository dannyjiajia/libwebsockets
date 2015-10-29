@echo off
set ARGS=-DLWS_WITHOUT_TEST_SERVER:BOOL="1" -DLWS_IPV6:BOOL="0" -DLWS_WITHOUT_TEST_SERVER_EXTPOLL:BOOL="1" -DLWS_WITHOUT_TEST_FRAGGLE:BOOL="1" -DLWS_WITH_SSL:BOOL="0" -DLWS_WITHOUT_TEST_CLIENT:BOOL="1" -DCMAKE_CONFIGURATION_TYPES:STRING="Debug;Release;MinSizeRel;RelWithDebInfo" -DLWS_WITHOUT_TEST_PING:BOOL="1" -DLWS_WITHOUT_TESTAPPS:BOOL="1" 

mkdir bin
cd bin
mkdir WindowsPhone_8.1
cd WindowsPhone_8.1
mkdir arm
mkdir win32
cd arm
cmake -G"Visual Studio 12 2013 ARM" -DCMAKE_SYSTEM_NAME=WindowsPhone -DCMAKE_SYSTEM_VERSION=8.1 %ARGS% ../../../
cd ..\
cd win32
cmake -G"Visual Studio 12 2013" -DCMAKE_SYSTEM_NAME=WindowsPhone -DCMAKE_SYSTEM_VERSION=8.1  %ARGS%  ../../../
cd ..\..\..\

echo./*
echo. * Check VC++ environment...
echo. */
echo.

set FOUND_VC=0

if defined VS120COMNTOOLS (
    set VSTOOLS="%VS120COMNTOOLS%"
    set VC_VER=120
    set FOUND_VC=1
) 

set VSTOOLS=%VSTOOLS:"=%
set "VSTOOLS=%VSTOOLS:\=/%"

set VSVARS="%VSTOOLS%vsvars32.bat"

if not defined VSVARS (
    echo Can't find VC2013 installed!
    goto ERROR
)


echo./*
echo. * Building libwebsockets..
echo. */
echo.


call %VSVARS%
if %FOUND_VC%==1 (
msbuild  bin\WindowsPhone_8.1\win32\libwebsockets.sln /p:Configuration="MinSizeRel"  /p:Platform="Win32"
msbuild  bin\WindowsPhone_8.1\arm\libwebsockets.sln /p:Configuration="MinSizeRel"  /p:Platform="ARM"
) else (
    echo Script error.
    goto ERROR
)


goto EOF

:ERROR
pause

:EOF
echo finish!
pause