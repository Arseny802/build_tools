#!/bin/bash

build_tools_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
project_path=$1
logs_path=$project_path/cmake_build/.logs/build

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

# Runs cmake build for a given profile.
#
# It assumes that $project_path/cmake_build/$profile directory exists and
# contains CMakeCache.txt file.
#
# The function runs cmake with the following options:
# - --build .
# - --config Debug
# - --parallel 24
#
# Output is redirected to $logs_path/$profile_1.log and
# $logs_path/$profile_2.log.
#
# It returns 0 if build is successful, and non-zero otherwise.
function cmake_build_profile() {
  profile=$1

	printf "Running cmake load for profile $profile... "
	if [ ! -d "$project_path/cmake_build/$profile" ]; then
	  echo Error: $project_path/cmake_build/$profile directory not exists!
    return [n]
	fi
  cd $project_path/cmake_build/$profile

  cmake --build .  --config Debug --parallel 24 \
    1>$logs_path/${profile}_1.log 2>$logs_path/${profile}_2.log
  return_code=$?
	if [[ $return_code -eq 0 ]]; then
  	echo OK
	else
  	echo FAIL, code: $return_code
	fi

  cd ../..
}

GenerateFolders
for entry in "$build_tools_dir"/conan/.profiles/lin/*; do
	configuration_name=$(basename ${entry})
  cmake_build_profile $configuration_name
done

