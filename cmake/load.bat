@ECHO OFF
setlocal ENABLEDELAYEDEXPANSION

set build_tools_dir=%0\..
set project_path=%1
set cmake_exe="C:\Program Files\CMake\bin\cmake.exe"


if not defined project_path (
	echo Error: no arguments passed!
	exit
)

:find_proj_root_loop
if exist %project_path%\CMakeLists.txt (
  echo Using direcory '%project_path%'...
) else (
	if not exist %project_path%\.. (
		echo Error: project root directory cannot be found!
		echo Note: invalid direcrtory '%project_path%'.
		exit
	)
  set project_path=%project_path%\..
  goto find_proj_root_loop
)

cd %project_path%

if not exist %project_path%\cmake_build mkdir %project_path%\cmake_build



set cmake_generator="Visual Studio 17 2022"
set TOOLCHAIN_FILE_DEFAULT=build/generators/conan_toolchain.cmake


rem set toolchain_file=%project_path%\%TOOLCHAIN_FILE_DEFAULT%
rem if exist %TOOLCHAIN_FILE_DEFAULT% (
rem   echo Toolchain file found at '%TOOLCHAIN_FILE_DEFAULT%'.
rem   set cmake_exe=%cmake_exe% -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE_DEFAULT%
rem ) else (
rem   echo Toolchain file NOT found at '%TOOLCHAIN_FILE_DEFAULT%'.
rem )


if not exist %project_path%\cmake_build\release_win_msvc_x64_dyn mkdir %project_path%\cmake_build\release_win_msvc_x64_dyn
cd cmake_build\release_win_msvc_x64_dyn

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="Release" -DCMAKE_BUILD_TYPE=Release -DBUILD_TOOL_TYPE_NAME=release_win_msvc_x64_dyn ^
  -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE_DEFAULT% -G %cmake_generator% ../..
cd ..\..

echo ###################################################################################################

if not exist %project_path%\cmake_build\release_win_msvc_x64_st mkdir %project_path%\cmake_build\release_win_msvc_x64_st
cd cmake_build\release_win_msvc_x64_st

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="Release" -DCMAKE_BUILD_TYPE=Release -DBUILD_TOOL_TYPE_NAME=release_win_msvc_x64_st ^
  -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE_DEFAULT% -G %cmake_generator% ../..
cd ..\..

echo ###################################################################################################

if not exist %project_path%\cmake_build\release_win_msvc_x86_st mkdir %project_path%\cmake_build\release_win_msvc_x86_st
cd cmake_build\release_win_msvc_x86_st

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="Release" -DCMAKE_BUILD_TYPE=Release -DBUILD_TOOL_TYPE_NAME=release_win_msvc_x86_st ^
  -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE_DEFAULT% -G %cmake_generator% ../..
cd ..\..

echo ###################################################################################################


if not exist %project_path%\cmake_build\debug_win_msvc_x64_st mkdir %project_path%\cmake_build\debug_win_msvc_x64_st
cd cmake_build\debug_win_msvc_x64_st

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="Debug" -DCMAKE_BUILD_TYPE=Debug -DBUILD_TOOL_TYPE_NAME=debug_win_msvc_x64_st ^
  -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE_DEFAULT% -G %cmake_generator% ../..
cd ..\..

echo ###################################################################################################

if not exist %project_path%\cmake_build\debug_win_msvc_x64_dyn mkdir %project_path%\cmake_build\debug_win_msvc_x64_dyn
cd cmake_build\debug_win_msvc_x64_dyn

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="Debug" -DCMAKE_BUILD_TYPE=Debug -DBUILD_TOOL_TYPE_NAME=debug_win_msvc_x64_dyn ^
  -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE_DEFAULT% -G %cmake_generator% ../..
cd ..\..

echo ###################################################################################################




set cmake_generator="MinGW Makefiles"
set TOOLCHAIN_FILE_DEFAULT=build/Debug/generators/conan_toolchain.cmake
rem sset cmake_exe=%cmake_exe% -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE_DEFAULT%
rem set cmake_exe=%cmake_exe% -DCMAKE_CXX_COMPILER=gcc
rem set cmake_exe=%cmake_exe% -DCMAKE_MAKE_PROGRAM=make

echo ###################################################################################################

if not exist %project_path%\cmake_build\debug_win_gcc_x86 mkdir %project_path%\cmake_build\debug_win_gcc_x86
cd cmake_build\debug_win_gcc_x86

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="Debug" -DCMAKE_BUILD_TYPE=Debug -DBUILD_TOOL_TYPE_NAME=debug_win_gcc_x86 ^
  -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE_DEFAULT% -DCMAKE_CXX_COMPILER=C:/msys64/mingw32/bin/g++.exe -DCMAKE_MAKE_PROGRAM=make -G %cmake_generator% ../..
cd ..\..

echo ###################################################################################################

if not exist %project_path%\cmake_build\debug_win_gcc_x64 mkdir %project_path%\cmake_build\debug_win_gcc_x64
cd cmake_build\debug_win_gcc_x64

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="Debug" -DCMAKE_BUILD_TYPE=Debug -DBUILD_TOOL_TYPE_NAME=debug_win_gcc_x64 ^
  -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE_DEFAULT% -G %cmake_generator% ../..
cd ..\..


set TOOLCHAIN_FILE_DEFAULT=build/Release/generators/conan_toolchain.cmake

echo ###################################################################################################

if not exist %project_path%\cmake_build\release_win_gcc_x64 mkdir %project_path%\cmake_build\release_win_gcc_x64
cd cmake_build\release_win_gcc_x64

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="Release" -DCMAKE_BUILD_TYPE=Release -DBUILD_TOOL_TYPE_NAME=release_win_gcc_x64 ^
  -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE_DEFAULT% -G %cmake_generator% ../..
cd ..\..

echo ###################################################################################################

if not exist %project_path%\cmake_build\release_win_gcc_x86 mkdir %project_path%\cmake_build\release_win_gcc_x86
cd cmake_build\release_win_gcc_x86

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="Release" -DCMAKE_BUILD_TYPE=Release -DBUILD_TOOL_TYPE_NAME=release_win_gcc_x86 ^
  -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE_DEFAULT% -DCMAKE_CXX_COMPILER=C:/msys64/mingw32/bin/g++.exe -DCMAKE_MAKE_PROGRAM=make -G %cmake_generator% ../..
cd ..\..


rem ##############################
rem ###### Prepare Folders  ######
rem ##############################

if not exist %project_path%\bin mkdir %project_path%\bin
rem if not exist %project_path%\bin\debug mkdir %project_path%\bin\debug
rem if not exist %project_path%\bin\release mkdir %project_path%\bin\release

if not exist %project_path%\bin\debug_win_gcc_x64 mkdir %project_path%\bin\debug_win_gcc_x64
if not exist %project_path%\bin\debug_win_gcc_x86 mkdir %project_path%\bin\debug_win_gcc_x86
if not exist %project_path%\bin\release_win_gcc_x64 mkdir %project_path%\bin\release_win_gcc_x64
if not exist %project_path%\bin\release_win_gcc_x86 mkdir %project_path%\bin\release_win_gcc_x86

if not exist %project_path%\bin\release_win_msvc_x86_st mkdir %project_path%\bin\release_win_msvc_x86_st
if not exist %project_path%\bin\release_win_msvc_x64_st mkdir %project_path%\bin\release_win_msvc_x64_st
if not exist %project_path%\bin\release_win_msvc_x64_dyn mkdir %project_path%\bin\release_win_msvc_x64_dyn
if not exist %project_path%\bin\debug_win_msvc_x64_st mkdir %project_path%\bin\debug_win_msvc_x64_st
if not exist %project_path%\bin\debug_win_msvc_x64_dyn mkdir %project_path%\bin\debug_win_msvc_x64_dyn

if %errorlevel% neq 0 exit /b %errorlevel%
