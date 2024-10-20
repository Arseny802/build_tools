@ECHO OFF
setlocal enabledelayedexpansion

rem ##############################
rem ###### Setup Variables  ######
rem ##############################

set conan_dir=%0\..
set arg1=%1
set project_path=%arg1%
set logs_path=%project_path%\cmake_build\.logs\conan
shift

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

if exist %project_path%\ (
  echo Conan installs dependencies of project in '%project_path%'.
  echo Check logs at '%logs_path%'.
) else (
  echo Directory '%arg1%' not exists - argument error.
  exit
)


rem ##############################
rem ###### Prepare Folders  ######
rem ##############################

if not exist %project_path%\cmake_build mkdir %project_path%\cmake_build
if not exist %project_path%\cmake_build\.logs mkdir %project_path%\cmake_build\.logs
if not exist %logs_path% mkdir %logs_path%

if not exist %project_path%\cmake_build\release_win_msvc_x86_st mkdir %project_path%\cmake_build\release_win_msvc_x86_st
if not exist %project_path%\cmake_build\release_win_msvc_x64_st mkdir %project_path%\cmake_build\release_win_msvc_x64_st
if not exist %project_path%\cmake_build\release_win_msvc_x64_dyn mkdir %project_path%\cmake_build\release_win_msvc_x64_dyn
if not exist %project_path%\cmake_build\debug_win_msvc_x64_st mkdir %project_path%\cmake_build\debug_win_msvc_x64_st
if not exist %project_path%\cmake_build\debug_win_msvc_x64_dyn mkdir %project_path%\cmake_build\debug_win_msvc_x64_dyn

if not exist %project_path%\cmake_build\debug_win_gcc_x64 mkdir %projectdebug_win_gcc_x64_path%\cmake_build\debug_win_gcc_x64
if not exist %project_path%\cmake_build\debug_win_gcc_x86 mkdir %project_path%\cmake_build\debug_win_gcc_x86
if not exist %project_path%\cmake_build\release_win_gcc_x64 mkdir %project_path%\cmake_build\release_win_gcc_x64
if not exist %project_path%\cmake_build\release_win_gcc_x86 mkdir %project_path%\cmake_build\release_win_gcc_x86
rem if not exist %project_path%\cmake_build\release_win_clang_x86 mkdir %project_path%\cmake_build\release_win_clang_x86
rem if not exist %project_path%\cmake_build\release_win_clang_x64 mkdir %project_path%\cmake_build\release_win_clang_x64
rem if not exist %project_path%\cmake_build\release_lin_gcc_x86 mkdir %project_path%\cmake_build\release_lin_gcc_x86
rem if not exist %project_path%\cmake_build\release_lin_gcc_x64 mkdir %project_path%\cmake_build\release_lin_gcc_x64
rem if not exist %project_path%\cmake_build\release_lin_clang_x86 mkdir %project_path%\cmake_build\release_lin_clang_x86
rem if not exist %project_path%\cmake_build\release_lin_clang_x64 mkdir %project_path%\cmake_build\release_lin_clang_x64


rem ###########################
rem ###### WINDOWS build ######
rem ###########################

echo|set /p="Running conan install for profile release_win_msvc_x86_st... "
conan install %project_path% --output-folder="%project_path%/cmake_build/release_win_msvc_x86_st" --build=missing ^
  -pr:h %conan_dir%\.profiles\win\win_msvc_x86_rel_st -pr:b %conan_dir%\.profiles\win\win_msvc_x86_rel_st --name=win_msvc_x86_rel_st ^
  1>%logs_path%\release_win_msvc_x86_st.log 2>%logs_path%\release_win_msvc_x86_st_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

echo|set /p="Running conan install for profile release_win_msvc_x64_st... "
conan install %project_path% --output-folder="%project_path%/cmake_build/release_win_msvc_x64_st" --build=missing ^
  -pr:h %conan_dir%\.profiles\win\win_msvc_x64_rel_st -pr:b %conan_dir%\.profiles\win\win_msvc_x64_rel_st --name=win_msvc_x64_rel_st ^
  1>%logs_path%\release_win_msvc_x64_st.log 2>%logs_path%\release_win_msvc_x64_st_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

echo|set /p="Running conan install for profile release_win_msvc_x64_dyn... "
conan install %project_path% --output-folder="%project_path%/cmake_build/release_win_msvc_x64_dyn" --build=missing ^
  -pr:h %conan_dir%\.profiles\win\win_msvc_x64_rel_dyn -pr:b %conan_dir%\.profiles\win\win_msvc_x64_rel_dyn --name=win_msvc_x64_rel_dyn ^
  1>%logs_path%\release_win_msvc_x64_dyn.log 2>%logs_path%\release_win_msvc_x64_dyn_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

echo|set /p="Running conan install for profile debug_win_msvc_x64_st... "
conan install %project_path% --output-folder="%project_path%/cmake_build/debug_win_msvc_x64_st" --build=missing ^
  -pr:h %conan_dir%\.profiles\win\win_msvc_x64_deb_st -pr:b %conan_dir%\.profiles\win\win_msvc_x64_deb_st --name=win_msvc_x64_deb_st ^
  1>%logs_path%\debug_win_msvc_x64_st.log 2>%logs_path%\debug_win_msvc_x64_st_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

echo|set /p="Running conan install for profile debug_win_msvc_x64_dyn... "
conan install %project_path% --output-folder="%project_path%/cmake_build/debug_win_msvc_x64_dyn" --build=missing ^
  -pr:h %conan_dir%\.profiles\win\win_msvc_x64_deb_dyn -pr:b %conan_dir%\.profiles\win\win_msvc_x64_deb_dyn --name=win_msvc_x64_deb_dyn ^
  1>%logs_path%\debug_win_msvc_x64_dyn.log 2>%logs_path%\debug_win_msvc_x64_dyn_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################



echo|set /p="Running conan install for profile debug_win_gcc_x64... "
conan install %project_path% --output-folder="%project_path%/cmake_build/debug_win_gcc_x64" --build=missing ^
  -pr:a %conan_dir%\.profiles\win\win_gcc_x64_deb --name=debug_win_gcc_x64 ^
  1>%logs_path%\debug_win_gcc_x64.log 2>%logs_path%\debug_win_gcc_x64_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

echo|set /p="Running conan install for profile release_win_gcc_x64... "
conan install %project_path% --output-folder="%project_path%/cmake_build/release_win_gcc_x64" --build=missing ^
  -pr:h %conan_dir%\.profiles\win\win_gcc_x64_rel -pr:b %conan_dir%\.profiles\win\win_gcc_x64_rel --name=release_win_gcc_x64 ^
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
echo|set /p="Running conan install for profile debug_win_gcc_x86... "
conan install %project_path% --output-folder="%project_path%/cmake_build/debug_win_gcc_x86" --build=missing  ^
  -pr:h %conan_dir%\.profiles\win\win_gcc_x86_deb -pr:b %conan_dir%\.profiles\win\win_gcc_x86_deb --name=debug_win_gcc_x86 ^
  1>%logs_path%\debug_win_gcc_x86.log 2>%logs_path%\debug_win_gcc_x86_err.log
if %errorlevel% EQU 0 (
  echo OK
) else (
  echo FAIL, code: %errorlevel%
)
rem echo ###################################################################################################

echo|set /p="Running conan install for profile release_win_gcc_x86... "
conan install %project_path% --output-folder="%project_path%/cmake_build/release_win_gcc_x86" --build=missing  ^
  -pr:h %conan_dir%\.profiles\win\win_gcc_x86_rel -pr:b %conan_dir%\.profiles\win\win_gcc_x86_rel --name=release_win_gcc_x86^
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


rem ##############################
rem ###### Prepare Folders  ######
rem ##############################

if not exist %project_path%\bin mkdir %project_path%\bin

if not exist %project_path%\bin\debug_win_gcc_x64 mkdir %project_path%\bin\debug_win_gcc_x64
if not exist %project_path%\bin\debug_win_gcc_x86 mkdir %project_path%\bin\debug_win_gcc_x86
if not exist %project_path%\bin\release_win_gcc_x64 mkdir %project_path%\bin\release_win_gcc_x64
if not exist %project_path%\bin\release_win_gcc_x86 mkdir %project_path%\bin\release_win_gcc_x86

if not exist %project_path%\bin\release_win_msvc_x86_st mkdir %project_path%\bin\release_win_msvc_x86_st
if not exist %project_path%\bin\release_win_msvc_x64_st mkdir %project_path%\bin\release_win_msvc_x64_st
if not exist %project_path%\bin\release_win_msvc_x64_dyn mkdir %project_path%\bin\release_win_msvc_x64_dyn
if not exist %project_path%\bin\debug_win_msvc_x64_st mkdir %project_path%\bin\debug_win_msvc_x64_st
if not exist %project_path%\bin\debug_win_msvc_x64_dyn mkdir %project_path%\bin\debug_win_msvc_x64_dyn

rem if not exist %project_path%\bin\release\win\gcc_x86" mkdir %project_path%\bin\release\win\gcc_x86
rem if not exist %project_path%\bin\release\win\gcc_x64" mkdir %project_path%\bin\release\win\gcc_x64
rem if not exist %project_path%\bin\release\win\clang_x86" mkdir %project_path%\bin\release\win\clang_x86
rem if not exist %project_path%\bin\release\win\clang_x64" mkdir %project_path%\bin\release\win\clang_x64
rem if not exist %project_path%\bin\release\lin\gcc_x86" mkdir %project_path%\bin\release\lin\gcc_x86
rem if not exist %project_path%\bin\release\lin\gcc_x64" mkdir %project_path%\bin\release\lin\gcc_x64
rem if not exist %project_path%\bin\release\lin\clang_x86" mkdir %project_path%\bin\release\lin\clang_x86
rem if not exist %project_path%\bin\release\lin\clang_x64" mkdir %project_path%\bin\release\lin\clang_x64

if %errorlevel% neq 0 exit /b %errorlevel%
