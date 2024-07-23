@ECHO OFF

rem export CC=gcc
rem export CXX=g++

set build_tools_dir=%0\..
set project_path=%1
set cmake_exe="C:\Program Files\CMake\bin\cmake.exe"
set cmake_generator="Visual Studio 17 2022"
rem set cmake_generator="Ninja"
rem set TOOLCHAIN_FILE_DEFAULT=build/Release/generators/conan_toolchain.cmake
set TOOLCHAIN_FILE_DEFAULT=build/generators/conan_toolchain.cmake


cd %project_path%

if not exist %project_path%\cmake_build mkdir %project_path%\cmake_build
if not exist %project_path%\cmake_build\debug mkdir %project_path%\cmake_build\debug

cd cmake_build\debug

rem set toolchain_file=%project_path%\%TOOLCHAIN_FILE_DEFAULT%
if exist %TOOLCHAIN_FILE_DEFAULT% (
  echo Toolchain file found at '%TOOLCHAIN_FILE_DEFAULT%'.
  set cmake_exe=%cmake_exe% -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_FILE_DEFAULT%
) else (
  echo Toolchain file NOT found at '%TOOLCHAIN_FILE_DEFAULT%'.
)

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="Debug" -DCMAKE_BUILD_TYPE=Debug -G %cmake_generator% ../..


rem Временно для проверки работоспособности
cd ..\..

if not exist %project_path%\cmake_build\release mkdir %project_path%\cmake_build\release

cd cmake_build\release

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="Release" -DCMAKE_BUILD_TYPE=Release -G %cmake_generator% ../..