import os
import time

class BuilderCommon:
  profiles_windows: list[str] = [
    "conan_profiles/windows/win_gcc_x64_deb",
    "conan_profiles/windows/win_gcc_x64_rel",
    "conan_profiles/windows/win_gcc_x86_deb",
    "conan_profiles/windows/win_gcc_x86_rel",

    "conan_profiles/windows/win_msvc_x64_deb_st",
    "conan_profiles/windows/win_msvc_x64_rel_st",
    "conan_profiles/windows/win_msvc_x64_deb_dyn",
    "conan_profiles/windows/win_msvc_x64_rel_dyn",
    "conan_profiles/windows/win_msvc_x86_deb_st",
    "conan_profiles/windows/win_msvc_x86_rel_st",
    "conan_profiles/windows/win_msvc_x86_deb_dyn",
    "conan_profiles/windows/win_msvc_x86_rel_dyn",
  ]
  profiles_windows_cross: list[str] = [
    # TODO: Crossbuild linux profiles are missing
    "conan_profiles/windows/lin_gcc_x64_deb",
    "conan_profiles/windows/lin_gcc_x64_rel",
    "conan_profiles/windows/lin_gcc_x86_deb",
    "conan_profiles/windows/lin_gcc_x86_rel",
  ]
  profiles_windows_all: list[str] = profiles_windows + profiles_windows_cross
  profiles_windows_default: list[str] = [profiles_windows[0]]
  
  profiles_linux: list[str] = [
    "conan_profiles/linux/lin_gcc_x64_deb",
    "conan_profiles/linux/lin_gcc_x64_rel",
    "conan_profiles/linux/lin_gcc_x86_deb",
    "conan_profiles/linux/lin_gcc_x86_rel",
  ]
  profiles_linux_cross: list[str] = [
    # TODO: Crossbuild windows profiles are missing
    # "conan_profiles/linux/win_gcc_x64_deb",
    # "conan_profiles/linux/win_gcc_x64_rel",
  ]
  profiles_linux_all = profiles_linux + profiles_linux_cross
  profiles_linux_default = [profiles_linux[0]]

  def __init__(self, project_root_path: str):
    self.root_path = os.path.dirname(os.path.realpath(__file__))
    self.project_root_path = project_root_path
    self.cmake_build_folder = f"{self.project_root_path}/_build"
    self.build_logs_folder = f"{self.cmake_build_folder}/_logs"
    self.bin_folder = f"{self.project_root_path}/_build/bin"
    self.bin_install_folder = f"{self.project_root_path}/_build/bin_install"
    self.bin_packages_folder = f"{self.project_root_path}/_build/bin_packages"
  
  def generate_folders(self, profiles_list: list, reset: bool = False):
    basic_folders = [
      self.cmake_build_folder,
      self.build_logs_folder,
      f"{self.build_logs_folder}/conan",
      f"{self.build_logs_folder}/cmake",
      f"{self.build_logs_folder}/build",
      f"{self.build_logs_folder}/install",
      f"{self.build_logs_folder}/package",
      self.bin_folder,
      self.bin_install_folder,
      self.bin_packages_folder,
    ]
    for folder in basic_folders:
      if reset and os.path.exists(folder):
        os.rmdir(folder)
      if not os.path.exists(folder):
        os.makedirs(folder, exist_ok=True)

    for profile_path in profiles_list:
      profile_name = profile_path.split("/")[-1]

      profile_cmake_folder = os.path.join(self.cmake_build_folder, profile_name)
      if reset and os.path.exists(profile_cmake_folder):
        os.rmdir(profile_cmake_folder)
      if not os.path.exists(profile_cmake_folder):
        os.makedirs(profile_cmake_folder, exist_ok=True)

      profile_bin_folder = os.path.join(self.bin_folder, profile_name)
      if reset and os.path.exists(profile_bin_folder):
        os.rmdir(profile_bin_folder)
      if not os.path.exists(profile_bin_folder):
        os.makedirs(profile_bin_folder, exist_ok=True)

      profile_bin_install_folder = os.path.join(self.bin_install_folder, profile_name)
      if reset and os.path.exists(profile_bin_install_folder):
        os.rmdir(profile_bin_install_folder)
      if not os.path.exists(profile_bin_install_folder):
        os.makedirs(profile_bin_install_folder, exist_ok=True)

    return
  
  def _do_for_all(self, func, list: list, additiona_args: dict|None = None, function_desc: str|None = None):
    print()
    
    start = time.time()
    success_counter = sum(func(profile, additiona_args) for profile in list)
    end = time.time()

    if function_desc:
      print(f"{function_desc} finished succesfully for {success_counter}/{len(list)} profiles in %.3f sec." % (end - start))
      
  def _run_cmd(self, command: str, profile_name: str, cmd_name: str = "operation") -> bool:
    print(f"Running {cmd_name} for profile {profile_name}... ", end='', flush=True)
    
    start = time.time()
    return_code =os.system(command)
    end = time.time()
    if return_code != 0:
      print(f"FAIL, code: {return_code}. Elapsed %.3f sec" % (end - start))
      return False

    print("OK. Elapsed %.3f sec" % (end - start))
    return True
  