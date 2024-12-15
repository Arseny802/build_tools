#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
from builder_conan_common import BuilderConanCommon

class BuilderConanWindows(BuilderConanCommon):

  def __init__(self, project_root_path: str):
    super().__init__(project_root_path)

  def install(self, use_all_profiles: bool):
    profiles = self.profiles_windows_all if use_all_profiles else self.profiles_windows_default
    self.generate_folders(profiles)
    self._do_for_all(self._install_profile, profiles, {}, "Conan install")
