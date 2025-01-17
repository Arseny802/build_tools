#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
from builder_conan_common import BuilderConanCommon

class BuilderConanLinux(BuilderConanCommon):

  def __init__(self, project_root_path: str):
    super().__init__(project_root_path, "lin")

  def install(self, use_all_profiles: bool):
    profiles = self.profiles_linux_all if use_all_profiles else self.profiles_linux_default
    self.generate_folders(profiles)
    self._do_for_all(self._install_profile, profiles, {}, "Conan install")
    
    if use_all_profiles and self._BUILD_CROSSCOMPILING:
      self._do_for_all(self._install_cross_profile, self.profiles_windows_cross, {}, "Conan install crossprofile")
    