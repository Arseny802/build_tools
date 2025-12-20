#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
from builder_conan_common import BuilderConanCommon

class BuilderConanWindows(BuilderConanCommon):

  def __init__(self, project_root_path: str):
    super().__init__(project_root_path, "win")

  def install(self, use_all_profiles: bool):
    profiles = self.profiles_windows if use_all_profiles else self.profiles_windows_default
    self.generate_folders(profiles)
    self._do_for_all(self._install_profile, profiles, {}, "Conan install")
    
    if use_all_profiles and self._BUILD_CROSSCOMPILING:
      self._do_for_all(self._install_cross_profile, self.profiles_windows_cross, {}, "Conan install crossprofile")

  def __remove_msys2(self) -> str:
    full_path = os.environ["PATH"]
    full_path_before = full_path
    pathes = full_path.split(";")
    for path in pathes:
      if "msys" not in path:
        continue
      full_path = full_path.replace(f"{path};", "")
    os.environ["PATH"] = full_path
    return full_path_before

  def _install_profile(self, profile_path: str, additiona_args: dict|None = None) -> bool:
    if "msvc" in profile_path:  # MSVC conflicts with msys
      path_before = self.__remove_msys2()
      result = super()._install_profile(profile_path, additiona_args)
      os.environ["PATH"] = path_before
      return result
    else:
      return super()._install_profile(profile_path, additiona_args)
