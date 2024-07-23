@ECHO OFF

set build_tools_dir=%0\..
set project_path=%1
set cmake_exe="C:\Program Files\CMake\bin\cmake.exe"

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
if not exist %project_path%\cmake_build\debug (
	echo Error: cmake_build\debug directory not exists!
	exit
)
cd cmake_build\debug

%cmake_exe% --build . 


rem Временно для проверки работоспособности
cd ..\..

if not exist %project_path%\cmake_build\release (
	echo Error: cmake_build\debug directory not exists!
	exit
)
cd cmake_build\release

%cmake_exe% --build .  --config Release

if not exist %project_path%\bin\debug" mkdir %project_path%\bin\debug
if not exist %project_path%\bin\release" mkdir %project_path%\bin\release
