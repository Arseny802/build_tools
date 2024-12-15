import os
import argparse

if os.name == 'nt':
    from builder_conan_windows import BuilderConanWindows as BuilderConan
    from builder_cmake_windows import BuilderCmakeWindows as BuilderCmake
    AVAILABLE_PROFILES = BuilderConan.profiles_windows_all
elif os.name == 'posix':
    from builder_conan_linux import BuilderConanLinux as BuilderConan
    from builder_cmake_linux import BuilderCmakeLinux as BuilderCmake
    AVAILABLE_PROFILES = BuilderConan.profiles_linux_all
else:
    raise Exception("Unsupported OS")

class Builder:
    def __init__(self, project_root_path: str):
        self.builder_conan = BuilderConan(project_root_path)
        self.builder_cmake = BuilderCmake(project_root_path)
            
    def run(self, args: argparse.Namespace):
        use_all_profiles = args.all
        if args.deps:
            self.run_conan(use_all_profiles)
        if args.cmake:
            self.run_cmake(use_all_profiles)
        if args.build:
            self.run_build(use_all_profiles)
        if args.install:
            self.run_install(use_all_profiles)
            
    def run_conan(self, use_all_profiles: bool = True):
        self.builder_conan.install(use_all_profiles)
        
    def run_cmake(self, use_all_profiles: bool = True):
        self.builder_cmake.load(use_all_profiles)
        
    def run_build(self, use_all_profiles: bool = True):
        self.builder_cmake.build(use_all_profiles)
        
    def run_install(self, use_all_profiles: bool = True):
        self.builder_cmake.install(use_all_profiles)
    

class Runner:
    def __init__(self):
        self.parser = argparse.ArgumentParser(
            prog='cpp_builder',
            description='C++ project builder',
            epilog='Text at the bottom of help')
        self.parser.add_argument('project_path', help='Path to the project')
        self.parser.add_argument('-a', '--all', default=True, action='store_true')
        self.parser.add_argument('-d', '--deps', default=False, action='store_true')
        self.parser.add_argument('-c', '--cmake', default=False, action='store_true')
        self.parser.add_argument('-b', '--build', default=False, action='store_true')
        self.parser.add_argument('-i', '--install', default=False, action='store_true')
        if len(AVAILABLE_PROFILES) > 0:
            self.parser.add_argument('--profile', required=False, choices=AVAILABLE_PROFILES)

    def parse_args(self) -> argparse.Namespace:
        return self.parser.parse_args()

    def main(self):
        try:
            args = self.parse_args()
        except Exception as e:
            print(e)
            self.parser.print_help()
        else:
            Builder(args.project_path).run(args)

if __name__ == "__main__":
    Runner().main()
