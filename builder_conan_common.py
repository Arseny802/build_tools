#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
from builder_common import BuilderCommon

class BuilderConanCommon(BuilderCommon):
  
  _TARGET_PROFILE_PATH_KEY = "target_profile_path"

  def __init__(self, project_root_path: str, current_system_prefix: str = ""):
    super().__init__(project_root_path)
    self.current_system_prefix = current_system_prefix
  
  def _install_profile(self, profile_path: str, additiona_args: dict|None = None) -> bool:
    profile_name = profile_path.split("/")[-1]

    if additiona_args is not None and self._TARGET_PROFILE_PATH_KEY in additiona_args.keys():
      profile_target_path = profile_path
      profile_target_name = profile_target_path.split("/")[-1]
    else:
      profile_target_name = profile_name

    command = f"conan install {self.project_root_path} --output-folder=\"{self.cmake_build_folder}/{profile_name}\""
    command += f" --build=missing -pr:h {profile_path} -pr:b {profile_path} --name={profile_name}"
    command += f" 1>{self.build_logs_folder}/conan/{profile_name}.log 2>&1"

    return self._run_cmd(command, profile_name, "conan install")
  
  def _install_cross_profile(self, profile_target_path: str, additiona_args: dict|None = None):
    if not self.current_system_prefix:
      return False
    
    profile_target_name: str = profile_target_path.split("/")[-1]
    profile_host_name = profile_target_name.replace(profile_target_name[:3], self.current_system_prefix)

    return next(
      (self.__install_cross_profile(profile_host_path, profile_target_path, additiona_args)
       for profile_host_path in self.profiles_windows
       if profile_host_path.endswith(profile_host_name)),
      False,
    )
  
  def __install_cross_profile(self, profile_current_path: str, profile_target_path: str, additiona_args: dict|None = None) -> bool:
    profile_current_name = profile_current_path.split("/")[-1]
    profile_target_name = profile_target_path.split("/")[-1]
    
    command = f"conan install {self.project_root_path} --output-folder=\"{self.cmake_build_folder}/{profile_target_name}\""
    command += f" --build=missing -pr:h {profile_target_path} -pr:b {profile_current_path} --name={profile_target_name}"
    command += f" 1>{self.build_logs_folder}/conan/{profile_target_name}.log 2>&1"
   
    return self._run_cmd(command, profile_target_name, "conan install")
