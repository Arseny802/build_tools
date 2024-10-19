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

if not exist %project_path%\cmake_build\.logs mkdir %project_path%\cmake_build\.logs
if not exist %project_path%\cmake_build\.logs\build mkdir %project_path%\cmake_build\.logs\build

rem echo ###########################################################################################
if not exist %project_path%\cmake_build\debug_win_msvc_x64_dyn (
	echo Error: cmake_build\debug_win_msvc_x64_dyn directory not exists!
) else (
  cd cmake_build\debug_win_msvc_x64_dyn
  echo|set /p="Running build for profile debug_win_msvc_x64_dyn... "
  %cmake_exe% --build .  --config Debug --parallel 24 ^
    1>..\.logs\build\debug_win_msvc_x64_dyn.log 2>..\.logs\build\debug_win_msvc_x64_dyn_err.log
  SET BUILD_ERRORLEVEL=!ERRORLEVEL!
  if "!BUILD_ERRORLEVEL!"=="0" (
    echo OK
  ) else (
    echo FAIL, code: %errorlevel%
  )
  cd ..\..
)

rem echo ###########################################################################################
if not exist %project_path%\cmake_build\debug_win_msvc_x64_st (
	echo Error: cmake_build\debug_win_msvc_x64_st directory not exists!
) else (
  cd cmake_build\debug_win_msvc_x64_st
  echo|set /p="Running build for profile debug_win_msvc_x64_st... "
  %cmake_exe% --build .  --config Debug --parallel 24 ^
    1>..\.logs\build\debug_win_msvc_x64_st.log 2>..\.logs\build\debug_win_msvc_x64_st_err.log
  SET BUILD_ERRORLEVEL=!ERRORLEVEL!
  if "!BUILD_ERRORLEVEL!"=="0" (
    echo OK
  ) else (
    echo FAIL, code: %errorlevel%
  )
  cd ..\..
)

rem echo ###########################################################################################
if not exist %project_path%\cmake_build\release_win_msvc_x64_dyn (
	echo Error: cmake_build\release_win_msvc_x64_dyn directory not exists!
) else (
  cd cmake_build\release_win_msvc_x64_dyn
  echo|set /p="Running build for profile release_win_msvc_x64_dyn... "
  %cmake_exe% --build .  --config Release --parallel 24 ^
    1>..\.logs\build\release_win_msvc_x64_dyn.log 2>..\.logs\build\release_win_msvc_x64_dyn_err.log
  SET BUILD_ERRORLEVEL=!ERRORLEVEL!
  if "!BUILD_ERRORLEVEL!"=="0" (
    echo OK
  ) else (
    echo FAIL, code: %errorlevel%
  )
  cd ..\..
)

rem echo ###########################################################################################
if not exist %project_path%\cmake_build\release_win_msvc_x64_st (
	echo Error: cmake_build\release_win_msvc_x64_st directory not exists!
) else (
  cd cmake_build\release_win_msvc_x64_st
  echo|set /p="Running build for profile release_win_msvc_x64_st... "
  %cmake_exe% --build .  --config Release --parallel 24 ^
    1>..\.logs\build\release_win_msvc_x64_st.log 2>..\.logs\build\release_win_msvc_x64_st_err.log
  SET BUILD_ERRORLEVEL=!ERRORLEVEL!
  if "!BUILD_ERRORLEVEL!"=="0" (
    echo OK
  ) else (
    echo FAIL, code: %errorlevel%
  )
  cd ..\..
)

rem echo ###########################################################################################
if not exist %project_path%\cmake_build\release_win_msvc_x86_st (
	echo Error: cmake_build\release_win_msvc_x86_st directory not exists!
) else (
  cd cmake_build\release_win_msvc_x86_st
  echo|set /p="Running build for profile release_win_msvc_x86_st... "
  %cmake_exe% --build .  --config Release --parallel 24 ^
    1>..\.logs\build\release_win_msvc_x86_st.log 2>..\.logs\build\release_win_msvc_x86_st_err.log
  SET BUILD_ERRORLEVEL=!ERRORLEVEL!
  if "!BUILD_ERRORLEVEL!"=="0" (
    echo OK
  ) else (
    echo FAIL, code: %errorlevel%
  )
  cd ..\..
)

rem GCC compiler
set CC=C:/msys64/mingw64/bin/gcc.exe
set CXX=C:/msys64/mingw64/bin/gcc.exe

rem echo ###########################################################################################
if not exist %project_path%\cmake_build\debug_win_gcc_x64 (
	echo Error: cmake_build\debug_win_gcc_x64 directory not exists!
) else (
  cd cmake_build\debug_win_gcc_x64
  echo|set /p="Running build for profile debug_win_gcc_x64... "
  %cmake_exe% --build .  --config Debug --parallel 24 ^
    1>..\.logs\build\debug_win_gcc_x64.log 2>..\.logs\build\debug_win_gcc_x64_err.log
  SET BUILD_ERRORLEVEL=!ERRORLEVEL!
  if "!BUILD_ERRORLEVEL!"=="0" (
    echo OK
  ) else (
    echo FAIL, code: %errorlevel%
  )
  cd ..\..
)

rem echo ###########################################################################################

if not exist %project_path%\cmake_build\release_win_gcc_x64 (
	echo Error: cmake_build\release_win_gcc_x64 directory not exists!
) else (
  cd cmake_build\release_win_gcc_x64
  echo|set /p="Running build for profile release_win_gcc_x64... "
  %cmake_exe% --build .  --config Release --parallel 24 ^
    1>..\.logs\build\release_win_gcc_x64.log 2>..\.logs\build\release_win_gcc_x64_err.log
  SET BUILD_ERRORLEVEL=!ERRORLEVEL!
  if "!BUILD_ERRORLEVEL!"=="0" (
    echo OK
  ) else (
    echo FAIL, code: %errorlevel%
  )
  cd ..\..
)

rem GCC compiler
set CC=C:/msys64/mingw32/bin/gcc.exe
set CXX=C:/msys64/mingw32/bin/gcc.exe

rem echo ###########################################################################################

if not exist %project_path%\cmake_build\debug_win_gcc_x86 (
	echo Error: cmake_build\debug_win_gcc_x86 directory not exists!
) else (
  cd cmake_build\debug_win_gcc_x86
  echo|set /p="Running build for profile debug_win_gcc_x86... "
  %cmake_exe% --build .  --config Release --parallel 24 ^
    1>..\.logs\build\debug_win_gcc_x86.log 2>..\.logs\build\debug_win_gcc_x86_err.log
  SET BUILD_ERRORLEVEL=!ERRORLEVEL!
  if "!BUILD_ERRORLEVEL!"=="0" (
    echo OK
  ) else (
    echo FAIL, code: %errorlevel%
  )
  cd ..\..
)

rem echo ###########################################################################################

if not exist %project_path%\cmake_build\release_win_gcc_x86 (
	echo Error: cmake_build\release_win_gcc_x86 directory not exists!
) else (
  cd cmake_build\release_win_gcc_x86
  echo|set /p="Running build for profile release_win_gcc_x86... "
  %cmake_exe% --build .  --config Release --parallel 24 ^
    1>..\.logs\build\release_win_gcc_x86.log 2>..\.logs\build\release_win_gcc_x86_err.log
  SET BUILD_ERRORLEVEL=!ERRORLEVEL!
  if "!BUILD_ERRORLEVEL!"=="0" (
    echo OK
  ) else (
    echo FAIL, code: %errorlevel%
  )
  cd ..\..
)

if %errorlevel% neq 0 exit /b %errorlevel%
