@echo off
set ARGS=-DLWS_WITHOUT_TEST_SERVER:BOOL="1" -DLWS_IPV6:BOOL="0" -DLWS_WITHOUT_TEST_SERVER_EXTPOLL:BOOL="1" -DLWS_WITHOUT_TEST_FRAGGLE:BOOL="1" -DLWS_WITH_SSL:BOOL="0" -DLWS_WITHOUT_TEST_CLIENT:BOOL="1" -DCMAKE_CONFIGURATION_TYPES:STRING="Debug;Release;MinSizeRel;RelWithDebInfo" -DLWS_WITHOUT_TEST_PING:BOOL="1" -DLWS_WITHOUT_TESTAPPS:BOOL="1" 

mkdir bin
cd bin
mkdir UWP
cd UWP
mkdir arm
mkdir win32
cd arm
cmake -G"Visual Studio 14 2015 ARM" -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0 %ARGS% ../../../
cd ..\
cd win32
cmake -G"Visual Studio 14 2015" -DCMAKE_SYSTEM_NAME=WindowsStore -DCMAKE_SYSTEM_VERSION=10.0  %ARGS%  ../../../
cd ..\..\..\

set FOUND_VC=0

if defined VS140COMNTOOLS (
    set VSTOOLS="%VS140COMNTOOLS%"
    set VC_VER=140
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
echo. * Building libwebsockets for uwp..
echo. */
echo.


call %VSVARS%
if %FOUND_VC%==1 (
msbuild  bin\UWP\arm\libwebsockets.sln /p:Configuration="MinSizeRel"  /p:Platform="ARM"
msbuild  bin\UWP\win32\libwebsockets.sln /p:Configuration="MinSizeRel"  /p:Platform="Win32"
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