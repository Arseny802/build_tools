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
if not exist %project_path%\cmake_build\.logs mkdir %project_path%\cmake_build\.logs
if not exist %project_path%\cmake_build\.logs\cmake mkdir %project_path%\cmake_build\.logs\cmake


set TOOLCHAIN_FILE=conan_toolchain.cmake


set cmake_generator="Visual Studio 17 2022"

call :cmake_load_profile release_win_msvc_x64_dyn Release
call :cmake_load_profile release_win_msvc_x64_st Release
call :cmake_load_profile release_win_msvc_x86_st Release
call :cmake_load_profile debug_win_msvc_x64_st Debug
call :cmake_load_profile debug_win_msvc_x64_dyn Debug

call :cmake_load_profile2 debug_win_gcc_x86 "MinGW Makefiles" Debug 32
call :cmake_load_profile2 debug_win_gcc_x64 "MinGW Makefiles" Debug 64
call :cmake_load_profile2 release_win_gcc_x64 "MinGW Makefiles" Release 64
call :cmake_load_profile2 release_win_gcc_x86 "MinGW Makefiles" Release 32


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


goto:eof
rem Functions start here


rem configuration_type - Debug, Release
:cmake_load_profile <build_type_name> <configuration_type>
set build_type_name=%1
set configuration_type=%2

echo|set /p="Running cmake load for profile %build_type_name%... "

if not exist %project_path%\cmake_build\%build_type_name% mkdir %project_path%\cmake_build\%build_type_name%
cd cmake_build\%build_type_name%
FOR /F "tokens=* USEBACKQ" %%F IN (`where /r build %TOOLCHAIN_FILE%`) DO (
  SET cmkae_toolchain_file_path=%%F
)

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="%configuration_type%" -DCMAKE_BUILD_TYPE=%configuration_type% -DBUILD_TOOL_TYPE_NAME=%build_type_name% ^
  -DCMAKE_TOOLCHAIN_FILE=%cmkae_toolchain_file_path% -G %cmake_generator% ../.. ^
  1>..\.logs\cmake\%build_type_name%_1.log 2>..\.logs\cmake\%build_type_name%_2.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
cd ..\..
goto:eof

rem configuration_type - Debug, Release
rem configuration_type - 64, 32
:cmake_load_profile2 <build_type_name> <cmake_generator> <configuration_type> <bitnes>
set build_type_name=%1
set cmake_generator=%2
set configuration_type=%3
set bitnes=%4

echo|set /p="Running cmake load for profile %build_type_name%... "

if not exist %project_path%\cmake_build\%build_type_name% mkdir %project_path%\cmake_build\%build_type_name%
cd cmake_build\%build_type_name%
FOR /F "tokens=* USEBACKQ" %%F IN (`where /r build %TOOLCHAIN_FILE%`) DO (
  SET cmkae_toolchain_file_path=%%F
)

%cmake_exe% -DCMAKE_CONFIGURATION_TYPES="%configuration_type%" -DCMAKE_BUILD_TYPE=%configuration_type% -DBUILD_TOOL_TYPE_NAME=%build_type_name% ^
  -DCMAKE_TOOLCHAIN_FILE=%cmkae_toolchain_file_path% -DCMAKE_CXX_COMPILER=C:/msys64/mingw%bitnes%/bin/g++.exe -DCMAKE_MAKE_PROGRAM=make -G %cmake_generator% ../.. ^
  1>..\.logs\cmake\%build_type_name%_1.log 2>..\.logs\cmake\%build_type_name%_2.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
cd ..\..


goto:eof
