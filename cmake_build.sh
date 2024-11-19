#!/bin/bash

build_tools_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
project_path=$1
logs_path=$project_path/cmake_build/.logs/build

./functionality.sh $project_path

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

	printf "Running cmake build for profile $profile... "
	if [ ! -d "$project_path/cmake_build/$profile" ]; then
	  echo Error: $project_path/cmake_build/$profile directory not exists!
    return [n]
	fi

  cmake --build $project_path/cmake_build/$profile  --config Debug --parallel 24 \
    1>$logs_path/${profile}_1.log 2>$logs_path/${profile}_2.log
  return_code=$?
	if [[ $return_code -eq 0 ]]; then
  	echo OK
	else
  	echo FAIL, code: $return_code
	fi
}

GenerateFolders
for entry in "$build_tools_dir"/conan/.profiles/lin/*; do
	configuration_name=$(basename ${entry})
  cmake_build_profile $configuration_name
done

