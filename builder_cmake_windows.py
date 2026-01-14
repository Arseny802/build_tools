#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
from builder_cmake_common import BuilderCmakeCommon

class BuilderCmakeWindows(BuilderCmakeCommon):
  
  def __init__(self, project_root_path: str):
    super().__init__(project_root_path)
    self.cmake_load_arguments = {
      self._GENERATOR_KEY: "Visual Studio 17 2022",
      self._GENERATOR_KEY_MSVC: "Visual Studio 17 2022",
      self._GENERATOR_KEY_GCC: "Unix Makefiles",
    }
  
  def load(self, use_all_profiles: bool):
    profiles = self.profiles_windows if use_all_profiles else self.profiles_windows_default
    self.generate_folders(profiles)
    self._do_for_all(self._load, profiles, self.cmake_load_arguments, "Cmake load")
    
    if use_all_profiles and self._BUILD_CROSSCOMPILING:
      self._do_for_all(self._load, self.profiles_windows_cross, {}, "Conan load crossprofile")
  
  def build(self, use_all_profiles: bool):
    profiles = self.profiles_windows if use_all_profiles else self.profiles_windows_default
    self.generate_folders(profiles)
    self._do_for_all(self._build, profiles, {}, "Cmake build")
    
    if use_all_profiles and self._BUILD_CROSSCOMPILING:
      self._do_for_all(self._build, self.profiles_windows_cross, {}, "Conan build crossprofile")

  def install(self, use_all_profiles: bool):
    profiles = self.profiles_windows if use_all_profiles else self.profiles_windows_default
    self.generate_folders(profiles)
    self._do_for_all(self._install, profiles, {}, "Cmake install")
    
    if use_all_profiles and self._BUILD_CROSSCOMPILING:
      self._do_for_all(self._install, self.profiles_windows_cross, {}, "Conan install crossprofile")

  def _load(self, profile_path: str, additional_args: dict|None = None) -> bool:
    if "msvc" in profile_path:  # MSVC conflicts with msys
      path_before = self._remove_msys2()
      result = super()._load(profile_path, additional_args)
      os.environ["PATH"] = path_before
      return result
    else:
      return super()._load(profile_path, additional_args)

  def _build(self, profile_path: str, additional_args: dict|None = None) -> bool:
    if "msvc" in profile_path:  # MSVC conflicts with msys
      path_before = self._remove_msys2()
      result = super()._build(profile_path, additional_args)
      os.environ["PATH"] = path_before
      return result
    else:
      return super()._build(profile_path, additional_args)
