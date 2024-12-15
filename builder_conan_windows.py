#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
from builder_conan_common import BuilderConanCommon

class BuilderConanWindows(BuilderConanCommon):

  def __init__(self, project_root_path: str):
    super().__init__(project_root_path)

  def install(self, use_all_profiles: bool):
    profiles = self.profiles_windows if use_all_profiles else self.profiles_windows_default
    self.generate_folders(profiles)
    self._do_for_all(self._install_profile, profiles, {}, "Conan install")
    
    if use_all_profiles:
      return

    for profile_target_path in self.profiles_windows_cross:
      profile_target_name: str = profile_target_path.split("/")[-1]
      self._install_cross_profile(profile_target_name.replace("lin", "win"), profile_target_path)

  def _install_cross_profile(self, profile_host_name, profile_target_path):
    for profile_host_path in self.profiles_windows:
      if profile_host_path.endswith(profile_host_name):
        self._install_cross_profile(profile_host_path, profile_target_path, "Conan install crossprofile")
        return True

    return False