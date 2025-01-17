#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
from builder_cmake_common import BuilderCmakeCommon

# cpack_run.bat
"""
@echo off

cd bin

echo Packing for Win32
cd Win32
cpack --config CPackConfig.cmake
cpack --config CPackSourceConfig.cmake
cd ..

echo Packing for x64
cd x64
cpack --config CPackConfig.cmake
cpack --config CPackSourceConfig.cmake
cd ..

echo Packing for unix
cd unix
cpack --config CPackConfig.cmake
cpack --config CPackSourceConfig.cmake
cd ..
"""

# project_hook.cmake
"""
function GetProjectName() {
  build_type_name=$1
  cmake -DCMAKE_PROJECT_INCLUDE=$build_tools_dir/project_hook.cmake $project_path/cmake_build/$build_type_name \
    | grep -m1 "build_tools_project_hook: Project name is" | grep -oE '[^ ]+$'
}
"""

class BuilderCpack(BuilderCmakeCommon):

  def __init__(self, project_root_path: str):
    super().__init__(project_root_path)
    self.cmake_files_common_directory = ""

  def install(self, profile_path: str, additiona_args: dict|None = None) -> bool:
    profile_name = profile_path.split("/")[-1]
    
    current_cmake_directory = os.path.join(self.project_root_path, self.cmake_files_common_directory, profile_name)
    command = f"cmake --install {current_cmake_directory}"
    command += f" 1>{self.build_logs_folder}/install/{profile_name}.log 2>&1"
    
    return self._run_cmd(command, profile_name, "cmake install")
  
  def pack(self, profile_path: str, additiona_args: dict|None = None) -> bool:
    profile_name = profile_path.split("/")[-1]
    
    current_cmake_directory = os.path.join(self.project_root_path, self.cmake_files_common_directory, profile_name)
    command = f"cpack --config {current_cmake_directory}/CPackConfig.cmake"
    command += f" 1>{self.build_logs_folder}/pack/{profile_name}.log 2>&1"
    
    if not self._run_cmd(command, profile_name, "cpack stage 1"):
      return False
    
    command = f"cpack --config {current_cmake_directory}/CPackSourceConfig.cmake"
    command += f" 1>{self.build_logs_folder}/pack/{profile_name}.log 2>&1"
    
    return self._run_cmd(command, profile_name, "cpack stage 2")
