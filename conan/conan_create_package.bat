@ECHO OFF
setlocal enabledelayedexpansion

rem ##############################
rem ###### Setup Variables  ######
rem ##############################

set conan_dir=%0\..
set arg1=%1
set arg2=%2
set project_path=%arg1%
set package_version=%arg2%
set logs_path=%project_path%\.create_package_logs
shift
shift

if not defined project_path (
	echo Error: no arguments passed!
	exit
)

if defined project_path (
  set version=--version "%package_version%"
  echo Using package vesrion: '%package_version%'.
) else (
  set version=
  echo Using no package vesrion.
)

if exist %project_path%\ (
  echo Conan create package in '%project_path%'.
  echo Check logs at '%logs_path%'.
) else (
  echo Directory '%arg1%' not exists - argument error.
  exit
)

if not exist %logs_path% mkdir %logs_path%


rem ###########################
rem ###### WINDOWS build ######
rem ###########################

echo|set /p="Running conan create for profile release_win_msvc_x86_st... "
conan create %project_path% %version% -pr:h %conan_dir%\.profiles\win\win_msvc_x86_rel_st -pr:b %conan_dir%\.profiles\win\win_msvc_x86_rel_st ^
  1>%logs_path%\release_win_msvc_x86_st.log 2>%logs_path%\release_win_msvc_x86_st_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

echo|set /p="Running conan create for profile release_win_msvc_x64_st... "
conan create %project_path% %version% -pr:h %conan_dir%\.profiles\win\win_msvc_x64_rel_st -pr:b %conan_dir%\.profiles\win\win_msvc_x64_rel_st ^
  1>%logs_path%\release_win_msvc_x64_st.log 2>%logs_path%\release_win_msvc_x64_st_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

echo|set /p="Running conan create for profile release_win_msvc_x64_dyn... "
conan create %project_path% %version% -pr:h %conan_dir%\.profiles\win\win_msvc_x64_rel_dyn -pr:b %conan_dir%\.profiles\win\win_msvc_x64_rel_dyn ^
  1>%logs_path%\release_win_msvc_x64_dyn.log 2>%logs_path%\release_win_msvc_x64_dyn_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

echo|set /p="Running conan create for profile debug_win_msvc_x64_st... "
conan create %project_path% %version% -pr:h %conan_dir%\.profiles\win\win_msvc_x64_deb_st -pr:b %conan_dir%\.profiles\win\win_msvc_x64_deb_st ^
  1>%logs_path%\debug_win_msvc_x64_st.log 2>%logs_path%\debug_win_msvc_x64_st_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

echo|set /p="Running conan create for profile debug_win_msvc_x64_dyn... "
conan create %project_path% %version% -pr:h %conan_dir%\.profiles\win\win_msvc_x64_deb_dyn -pr:b %conan_dir%\.profiles\win\win_msvc_x64_deb_dyn ^
  1>%logs_path%\debug_win_msvc_x64_dyn.log 2>%logs_path%\debug_win_msvc_x64_dyn_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################



echo|set /p="Running conan create for profile debug_win_gcc_x64... "
conan create %project_path% %version% -pr:h %conan_dir%\.profiles\win\win_gcc_x64_deb -pr:b %conan_dir%\.profiles\win\win_gcc_x64_deb ^
  1>%logs_path%\debug_win_gcc_x64.log 2>%logs_path%\debug_win_gcc_x64_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

echo|set /p="Running conan create for profile release_win_gcc_x64... "
conan create %project_path% %version% -pr:h %conan_dir%\.profiles\win\win_gcc_x64_rel -pr:b %conan_dir%\.profiles\win\win_gcc_x64_rel ^
  1>%logs_path%\release_win_gcc_x64.log 2>%logs_path%\release_win_gcc_x64_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

set CC_prev=%CC%
set CXX_prev=%CXX%
set CC=C:/msys64/mingw32/bin/gcc.exe
set CXX=C:/msys64/mingw32/bin/g++.exe

rem Using win_to_win_gcc_x64_deb instead of win_to_win_gcc_x64_deb because of -Werror in conan build. External project may fail.
echo|set /p="Running conan create for profile debug_win_gcc_x86... "
conan create %project_path% %version% -pr:h %conan_dir%\.profiles\win\win_gcc_x86_deb -pr:b %conan_dir%\.profiles\win\win_gcc_x86_deb ^
  1>%logs_path%\debug_win_gcc_x86.log 2>%logs_path%\debug_win_gcc_x86_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

echo|set /p="Running conan create for profile release_win_gcc_x86... "
conan create %project_path% %version% -pr:h %conan_dir%\.profiles\win\win_gcc_x86_rel -pr:b %conan_dir%\.profiles\win\win_gcc_x86_rel ^
  1>%logs_path%\release_win_gcc_x86.log 2>%logs_path%\release_win_gcc_x86_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

set CC=%CC_prev%
set CXX=%CXX_prev%

rem conan install %project_path% --output-folder="%project_path%/cmake_build/release_win_gcc_x64" --build=missing -pr:b win_to_win_gcc_x64
rem conan install %project_path% --output-folder="%project_path%/cmake_build/release_win_clang_x86" --build=missing -pr:b win_to_win_clang_x86
rem conan install %project_path% --output-folder="%project_path%/cmake_build/release_win_clang_x64" --build=missing -pr:b win_to_win_clang_x64


rem ##########################
rem ###### LINUX build  ######
rem ##########################

rem conan install %project_path% --output-folder="%project_path%/cmake_build/release_lin_gcc_x86" --build=missing -pr:b win_to_lin_gcc_x86
rem conan install %project_path% --output-folder="%project_path%/cmake_build/release_lin_gcc_x64" --build=missing -pr:b win_to_lin_gcc_x64
rem conan install %project_path% --output-folder="%project_path%/cmake_build/release_lin_clang_x86" --build=missing -pr:b win_to_lin_clang_x86
rem conan install %project_path% --output-folder="%project_path%/cmake_build/release_lin_clang_x64" --build=missing -pr:b win_to_lin_clang_x64

if %errorlevel% neq 0 exit /b %errorlevel%
