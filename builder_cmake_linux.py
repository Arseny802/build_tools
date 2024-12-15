#!/usr/bin/python
# -*- coding: utf-8 -*-

from builder_cmake_common import BuilderCmakeCommon

class BuilderCmakeLinux(BuilderCmakeCommon):
  
  def __init__(self, project_root_path: str):
    super().__init__(project_root_path)
    cmake_load_arguments = {
      self._GENERATOR_KEY: "Unix Makefiles"
    }
  
  def load(self, use_all_profiles: bool):
    profiles = self.profiles_linux_all if use_all_profiles else self.profiles_linux_default
    self.generate_folders(profiles)
    self._do_for_all(self._load, profiles, self.cmake_load_arguments, "Cmake load")
  
  def build(self, use_all_profiles: bool):
    profiles = self.profiles_linux_all if use_all_profiles else self.profiles_linux_default
    self.generate_folders(profiles)
    self._do_for_all(self._build, profiles, {}, "Cmake build")

  def install(self, use_all_profiles: bool):
    profiles = self.profiles_linux_all if use_all_profiles else self.profiles_linux_default
    self.generate_folders(profiles)
    self._do_for_all(self._install, profiles, {}, "Cmake install")
