import os

class BuilderCommon:
  profiles_windows = [
    "conan_profiles/windows/win_gcc_x64_deb",
    "conan_profiles/windows/win_gcc_x64_rel",
    "conan_profiles/windows/win_gcc_x86_deb",
    "conan_profiles/windows/win_gcc_x86_rel",
    "conan_profiles/windows/win_msvc_x64_deb_st",
    "conan_profiles/windows/win_msvc_x64_rel_st",
    "conan_profiles/windows/win_msvc_x64_deb_dyn",
    "conan_profiles/windows/win_msvc_x64_rel_dyn",
    "conan_profiles/windows/win_msvc_x86_rel_st",
  ]
  profiles_windows_cross = [
    # TODO: Crossbuild linux profiles are missing
    # "conan_profiles/windows/lin_gcc_x64_deb",
    # "conan_profiles/windows/lin_gcc_x64_rel",
  ]
  profiles_windows_all = profiles_windows + profiles_windows_cross
  profiles_windows_default = [profiles_windows[0]]
  
  profiles_linux = [
    "conan_profiles/linux/lin_gcc_x64_deb",
    "conan_profiles/linux/lin_gcc_x64_rel",
    "conan_profiles/linux/lin_gcc_x86_deb",
    "conan_profiles/linux/lin_gcc_x86_rel",
  ]
  profiles_linux_cross = [
    # TODO: Crossbuild windows profiles are missing
    # "conan_profiles/linux/win_gcc_x64_deb",
    # "conan_profiles/linux/win_gcc_x64_rel",
  ]
  profiles_linux_all = profiles_linux + profiles_linux_cross
  profiles_linux_default = [profiles_linux[0]]

  def __init__(self, project_root_path: str):
    self.root_path = os.path.dirname(os.path.realpath(__file__))
    self.project_root_path = project_root_path
    self.cmake_build_folder = self.project_root_path + "/cmake_build"
    self.build_logs_folder = self.cmake_build_folder + "/.logs"
    self.bin_folder = self.project_root_path + "/bin"
  
  def generate_folders(self, profiles_list: list, reset: bool = False):
    basic_folders = [
      self.cmake_build_folder,
      self.build_logs_folder,
      self.build_logs_folder + "/conan",
      self.build_logs_folder + "/cmake",
      self.build_logs_folder + "/build",
      self.build_logs_folder + "/package",
      self.bin_folder,
      self.bin_folder + "/packages",
    ]
    for folder in basic_folders:
      if reset and os.path.exists(profile):
        os.rmdir(profile)
      if not os.path.exists(folder):
        os.makedirs(folder, exist_ok=True)
        
    for profile in profiles_list:
      if reset and os.path.exists(profile):
        os.rmdir(profile)
        
      profile_bin_folder = os.path.join(self.bin_folder, profile)
      if not os.path.exists(profile_bin_folder):
        os.makedirs(profile_bin_folder, exist_ok=True)

    return
  
  def _do_for_all(self, func, list: list, additiona_args: dict = None, function_desc: str|None = None):
    success_counter = 0
    for profile in list:
      success_counter += func(profile, additiona_args)
    
    if function_desc:
      print(f"{function_desc} finished succesfully for {success_counter}/{len(list)} profiles.")
      
  def _run_cmd(self, command: str, profile_name: str, cmd_name: str = "operation") -> bool:
    print(f"Running cmake install for profile {profile_name}... ", end='', flush=True)
    return_code =os.system(command)
    if return_code != 0:
      print(f"FAIL, code: {return_code}")
      return False

    print("OK")
    return True
  