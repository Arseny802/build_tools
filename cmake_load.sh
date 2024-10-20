#!/bin/bash

build_tools_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
project_path=$1
logs_path=$project_path/cmake_build/.logs/cmake

# Generate folders for build configurations and binaries
# This function will create the following folders under $project_path:
# - cmake_build
# - cmake_build/.logs
# - bin
# - cmake_build/<configuration_name>
# - bin/<configuration_name>
# where <configuration_name> is the name of each build configuration profile
# found in the .profiles/lin folder of this script.
function GenerateFolders() {
	if [ ! -d "$project_path" ]; then
		echo Error: no arguments passed!
		exit 1
	fi

	if [ ! -d "$project_path/cmake_build" ]; then
		mkdir $project_path/cmake_build
	fi
	if [ ! -d "$project_path/cmake_build/.logs" ]; then 
		mkdir $project_path/cmake_build/.logs
	fi
	if [ ! -d "$project_path/bin" ]; then
		mkdir $project_path/bin
	fi
	if [ ! -d "$logs_path" ]; then
		mkdir $logs_path
	fi

	for entry in "$build_tools_dir"/conan/.profiles/lin/*; do
		configuration_name=$(basename ${entry})
		if [ ! -d "$project_path/cmake_build/$configuration_name" ]; then
			mkdir $project_path/cmake_build/$configuration_name
		fi
		if [ ! -d "$project_path/bin/$configuration_name" ]; then
			mkdir $project_path/bin/$configuration_name
		fi
	done
}

# Runs CMake to generate build files for the given profile.
#
# This function takes the following arguments:
# - build_type_name: the name of the build configuration profile
# - cmake_generator: the CMake generator to use (e.g. "Visual Studio 17 2022")
# - configuration_type: the configuration type to use (e.g. "Debug" or "Release")
# - bitnes: the bitness of the build (e.g. "32" or "64")
#
# This function will create the build configuration folder under $project_path/cmake_build
# and generate the build files using the given CMake generator and configuration type.
# The CMake toolchain file will be automatically detected in the user's home directory.
# The output of the CMake command will be redirected to the following log files:
# - $logs_path/${build_type_name}_1.log (stdout)
# - $logs_path/${build_type_name}_2.log (stderr)
# If the CMake command fails, the error code will be printed to the console.
function cmake_load_profile() {
  build_type_name=$1
  cmake_generator="$2"
  configuration_type=$3
  bitnes=$4

	printf "Running cmake load for profile $build_type_name... "
	if [ ! -d "$project_path/cmake_build/$build_type_name" ]; then
		mkdir $project_path/cmake_build/$build_type_name
	fi
  cd $project_path/cmake_build/$build_type_name
  cmake_toolchain_file_path=`find ~+ -type f -name "conan_toolchain.cmake"`

  cmake -DCMAKE_CONFIGURATION_TYPES="$configuration_type" -DCMAKE_BUILD_TYPE=$configuration_type \
    -DBUILD_TOOL_TYPE_NAME=$build_type_name -DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_file_path \
    -DCMAKE_MAKE_PROGRAM=make -G "$cmake_generator" ../.. \
    1>$logs_path/${build_type_name}_1.log 2>$logs_path/${build_type_name}_2.log

  return_code=$?
	if [[ $return_code -eq 0 ]]; then
  	echo OK
	else
  	echo FAIL, code: $return_code
	fi

  cd ../..
}

GenerateFolders
cmake_load_profile lin_gcc_x64_deb "Unix Makefiles" Debug 64
cmake_load_profile lin_gcc_x64_rel "Unix Makefiles" Release 64
cmake_load_profile lin_gcc_x86_deb "Unix Makefiles" Debug 86
cmake_load_profile lin_gcc_x86_rel "Unix Makefiles" Release 86

#for entry in "$conan_dir"/.profiles/lin/*; do
#	configuration_name=$(basename ${entry})
#  ConanInstallProfile $configuration_name
#done