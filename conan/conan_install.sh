#!/bin/bash

conan_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
project_path=$1
logs_path=$project_path/cmake_build/.logs/conan

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

	for entry in "$conan_dir"/.profiles/lin/*; do
		configuration_name=$(basename ${entry})
		if [ ! -d "$project_path/cmake_build/$configuration_name" ]; then
			mkdir $project_path/cmake_build/$configuration_name
		fi
		if [ ! -d "$project_path/bin/$configuration_name" ]; then
			mkdir $project_path/bin/$configuration_name
		fi
	done
}


# Installs the conan dependencies for a given profile.
#
# This function takes the following argument:
# - profile: the name of the build configuration profile.
#
# The function runs `conan install` with the specified profile for both
# host and build contexts, storing the output in the corresponding 
# cmake_build directory. It logs the standard output and error to separate
# files in the logs directory. If the command succeeds, it prints "OK".
# If it fails, it prints "FAIL" along with the return code.
function ConanInstallProfile() {
	profile=$1
	printf "Running conan install for profile $profile... "
	conan install $project_path --output-folder="$project_path/cmake_build/$profile" --build=missing \
  	-pr:h $conan_dir/.profiles/lin/$profile -pr:b $conan_dir/.profiles/lin/$profile --name=$profile \
  	1>$logs_path/${profile}_1.log 2>$logs_path/${profile}_2.log

  return_code=$?
	if [[ $return_code -eq 0 ]]; then
  	echo OK
	else
  	echo FAIL, code: $return_code
	fi
}

GenerateFolders
for entry in "$conan_dir"/.profiles/lin/*; do
	configuration_name=$(basename ${entry})
  ConanInstallProfile $configuration_name
done
