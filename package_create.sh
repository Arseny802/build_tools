#!/bin/bash

build_tools_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
project_path=$1
logs_path=$project_path/cmake_build/.logs/package

. ${build_tools_dir}/functionality.sh $project_path

#last_build=12345
 
if [ ! -f "$project_path/README.md" ]; then
  description="Project ${project_name}, version ${project_version}. Last build ${last_build}."
else
  description=`cat ${project_path}/README.md`
fi

function create_package() {
  build_type_name=$1
  name_postfix=$2
  package_type=$3

  executables=()
  for exe in `find $project_path/bin/$build_type_name -type f -executable`; do
    exe_name=`echo $exe | xargs -L 1 basename`
    if [[ $exe_name == *example ]]; then
      continue
    fi
    if [[ $exe_name == *test] || [$exe_name == *tests ]]; then
      continue
    fi
    echo Passing executable $exe_name to package...
    executables="$executables $exe=$exe_name"
  done

  if (( ${#executables[@]} == 0 )); then
    echo Warning: no executables found for $build_type_name package. Skipping...
    return 1
  fi

  project_name=`GetProjectName $build_type_name`
  project_version=`GetProjectVersion $build_type_name`
  
	printf "Running build package $package_type for profile $build_type_name... "

  #TODO: use last_build number in package name ("$project_version-$last_build" instead of $project_version)
  fpm -s dir -t $package_type --name $project_name$name_postfix --version $project_version \
    --maintainer "$maintainer" --url "$maintainer_url" --description "$description" \
    -p "$project_path/packages/$build_type_name/" $executables \
    1>$logs_path/${build_type_name}_${package_type}_1.log 2>$logs_path/${build_type_name}_${package_type}_2.log
    
  return_code=$?
	if [[ $return_code -eq 0 ]]; then
  	echo OK
	else
  	echo FAIL, code: $return_code
	fi
}

function create_packages() {
  build_type_name=$1
  name_postfix=$2

  rm -rf "${project_path}/packages/${build_type_name}/"
  mkdir "${project_path}/packages/${build_type_name}/"

  create_package $build_type_name "$name_postfix" deb
  create_package $build_type_name "$name_postfix" rpm
  create_package $build_type_name "$name_postfix" pacman
  create_package $build_type_name "$name_postfix" sh
}

GenerateFolders
echo "Creating packages for project $project_name..."
create_packages lin_gcc_x64_deb _debug
create_packages lin_gcc_x64_rel 
create_packages lin_gcc_x86_deb _debug
create_packages lin_gcc_x86_rel 
echo "Done creating packages."