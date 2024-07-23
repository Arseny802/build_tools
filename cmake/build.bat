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

echo Project path is '%project_path%'
if not exist %project_path% (
	echo Error: project_path directory not exists!
	exit
)

cd %project_path%

if not exist %project_path%\cmake_build (
	echo Error: cmake_build directory not exists!
	exit
)

echo ###########################################################################################
if not exist %project_path%\cmake_build\debug_win_msvc_x64_dyn (
	echo Error: cmake_build\debug_win_msvc_x64_dyn directory not exists!
) else (
  cd cmake_build\debug_win_msvc_x64_dyn
  %cmake_exe% --build .  --config Debug --parallel 24
  cd ..\..
)

echo ###########################################################################################
if not exist %project_path%\cmake_build\debug_win_msvc_x64_st (
	echo Error: cmake_build\debug_win_msvc_x64_st directory not exists!
) else (
  cd cmake_build\debug_win_msvc_x64_st
  %cmake_exe% --build .  --config Debug --parallel 24
  cd ..\..
)

echo ###########################################################################################
if not exist %project_path%\cmake_build\release_win_msvc_x64_dyn (
	echo Error: cmake_build\release_win_msvc_x64_dyn directory not exists!
) else (
  cd cmake_build\release_win_msvc_x64_dyn
  %cmake_exe% --build .  --config Release --parallel 24
  cd ..\..
)

echo ###########################################################################################
if not exist %project_path%\cmake_build\release_win_msvc_x64_st (
	echo Error: cmake_build\release_win_msvc_x64_st directory not exists!
) else (
  cd cmake_build\release_win_msvc_x64_st
  %cmake_exe% --build .  --config Release --parallel 24
  cd ..\..
)

echo ###########################################################################################
if not exist %project_path%\cmake_build\release_win_msvc_x86_st (
	echo Error: cmake_build\release_win_msvc_x86_st directory not exists!
) else (
  cd cmake_build\release_win_msvc_x86_st
  %cmake_exe% --build .  --config Release --parallel 24
  cd ..\..
)

rem GCC compiler
set CC=C:/msys64/mingw64/bin/gcc.exe
set CXX=C:/msys64/mingw64/bin/gcc.exe

echo ###########################################################################################
if not exist %project_path%\cmake_build\debug_win_gcc_x64 (
	echo Error: cmake_build\debug_win_gcc_x64 directory not exists!
) else (
  cd cmake_build\debug_win_gcc_x64
  %cmake_exe% --build .  --config Debug --parallel 24
  cd ..\..
)

echo ###########################################################################################

if not exist %project_path%\cmake_build\release_win_gcc_x64 (
	echo Error: cmake_build\release_win_gcc_x64 directory not exists!
) else (
  cd cmake_build\release_win_gcc_x64
  %cmake_exe% --build .  --config Release --parallel 24
  cd ..\..
)

rem GCC compiler
set CC=C:/msys64/mingw32/bin/gcc.exe
set CXX=C:/msys64/mingw32/bin/gcc.exe

echo ###########################################################################################

if not exist %project_path%\cmake_build\debug_win_gcc_x86 (
	echo Error: cmake_build\debug_win_gcc_x86 directory not exists!
) else (
  cd cmake_build\debug_win_gcc_x86
  %cmake_exe% --build .  --config Release --parallel 24
  cd ..\..
)

echo ###########################################################################################

if not exist %project_path%\cmake_build\release_win_gcc_x86 (
	echo Error: cmake_build\release_win_gcc_x86 directory not exists!
) else (
  cd cmake_build\release_win_gcc_x86
  %cmake_exe% --build .  --config Release --parallel 24
  cd ..\..
)

if %errorlevel% neq 0 exit /b %errorlevel%
