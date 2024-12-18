#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
from builder_common import BuilderCommon

class BuilderCmakeCommon(BuilderCommon):
  
  _GENERATOR_KEY = "cmake_generator"

  def __init__(self, project_root_path: str):
    super().__init__(project_root_path)
 
  def _load(self, profile_path: str, additiona_args: dict = None) -> bool:
    profile_name = profile_path.split("/")[-1]
    
    if "x86" in profile_name and ("x64" not in profile_name and "x86_64" not in profile_name):
      bitnes = "86"
    elif ("x64" in profile_name or "x86_64" in profile_name) and "x86" not in profile_name:
      bitnes = "64"
    else:
      bitnes = "64"
      
    if "msvc" in profile_name:
      additiona_args[self._GENERATOR_KEY] = "Visual Studio 17 2022"
    
    configuration_type = self.__get_configuration_type(profile_name)
    current_cmake_directory = os.path.join(self.cmake_build_folder, profile_name)
    cmake_toolchain_file_path = self.__find_conan_toolchain(current_cmake_directory)
    
    command = f"cmake {self.project_root_path}"
    command += f" -B \"{current_cmake_directory}\""
    command += f" -G \"{additiona_args[self._GENERATOR_KEY]}\""
    command += f" -DCMAKE_CONFIGURATION_TYPES={configuration_type}"
    command += f" -DCMAKE_BUILD_TYPE={configuration_type}"
    command += f" -DBUILD_TOOL_TYPE_NAME={profile_name}"
    command += f" -DCMAKE_TOOLCHAIN_FILE={cmake_toolchain_file_path}"
    command += f" -DCMAKE_PROJECT_INCLUDE={self.root_path}/injection_common.cmake"
    command += f" 1>{self.build_logs_folder}/cmake/{profile_name}.log 2>&1"
   
    return self._run_cmd(command, profile_name, "cmake load")
  
  def _build(self, profile_path: str, additiona_args: dict = None) -> bool:
    profile_name = profile_path.split("/")[-1]
    
    current_cmake_directory = os.path.join(self.cmake_build_folder, profile_name)
    command = f"cmake --build {current_cmake_directory}"
    command += f" --config {self.__get_configuration_type(profile_name)}"
    command += f" --parallel 24"
    command += f" 1>{self.build_logs_folder}/build/{profile_name}.log 2>&1"
    
    return self._run_cmd(command, profile_name, "cmake build")

  def _install(self, profile_path: str, additiona_args: dict = None) -> bool:
    profile_name = profile_path.split("/")[-1]
    
    current_cmake_directory = os.path.join(self.cmake_build_folder, profile_name)
    command = f"cmake --install {current_cmake_directory}"
    command += f" 1>{self.build_logs_folder}/install/{profile_name}.log 2>&1"
    
    return self._run_cmd(command, profile_name, "cmake install")
  
  def __find_conan_toolchain(self, path):
    name = "conan_toolchain.cmake"
    for root, dirs, files in os.walk(path):
        if name in files:
            return os.path.join(root, name)
    return None
  
  def __get_configuration_type(self, profile_name):
    if "deb" in profile_name and "rel" not in profile_name:
      return "Debug"
    elif "rel" in profile_name and "deb" not in profile_name:
      return "Release"
    else:
      return "Debug"