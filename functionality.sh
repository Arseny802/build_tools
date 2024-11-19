#!/bin/bash

maintainer="Arseny802 arseny802@yandex.ru"
maintainer_url=https://github.com/arseny802

# Generate folders for build configurations and binaries
# This function will create the following folders under $project_path:
# - cmake_build
# - cmake_build/.logs
# - bin
# - packages
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
	if [ ! -d "$project_path/cmake_build/.logs/conan" ]; then 
		mkdir $project_path/cmake_build/.logs/conan
	fi
	if [ ! -d "$project_path/cmake_build/.logs/cmake" ]; then 
		mkdir $project_path/cmake_build/.logs/cmake
	fi
	if [ ! -d "$project_path/cmake_build/.logs/build" ]; then 
		mkdir $project_path/cmake_build/.logs/build
	fi
	if [ ! -d "$project_path/cmake_build/.logs/package" ]; then 
		mkdir $project_path/cmake_build/.logs/package
	fi
	if [ ! -d "$project_path/packages" ]; then
		mkdir $project_path/packages
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

function GetProjectName() {
  build_type_name=$1
  cmake -DCMAKE_PROJECT_INCLUDE=$build_tools_dir/project_hook.cmake $project_path/cmake_build/$build_type_name \
    | grep -m1 "build_tools_project_hook: Project name is" | grep -oE '[^ ]+$'
}

function GetProjectVersion() {
  build_type_name=$1
  cmake -DCMAKE_PROJECT_INCLUDE=$build_tools_dir/project_hook.cmake $project_path/cmake_build/$build_type_name \
    | grep -m1 "build_tools_project_hook: Project version is" | grep -oE '[^ ]+$'
}
