#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
from builder_common import BuilderCommon

class BuilderConanCommon(BuilderCommon):

  def __init__(self, project_root_path: str):
    super().__init__(project_root_path)
  
  def _install_profile(self, profile_path: str, additiona_args: dict = None) -> bool:
    profile_name = profile_path.split("/")[-1]
    
    command = f"conan install {self.project_root_path} --output-folder=\"{self.cmake_build_folder}/{profile_name}\""
    command += f" --build=missing -pr:h {profile_path} -pr:b {profile_path} --name={profile_name}"
    command += f" 1>{self.build_logs_folder}/conan/{profile_name}.log 2>&1"
   
    return self._run_cmd(command, profile_name, "conan install")
