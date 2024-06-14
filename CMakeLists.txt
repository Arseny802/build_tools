include_guard(GLOBAL)


#### BASE ####
cmake_minimum_required(VERSION 3.17)  # because of CMAKE_CURRENT_FUNCTION_LIST_DIR

cmake_policy(SET CMP0048 NEW)  # manages VERSION variables
cmake_policy(SET CMP0091 NEW)  # allows select the MSVC runtime library (MT, MD, etc)


#### VARIABLES ####
option(CMAKE_TOOLS_DEBUG_MODE OFF "enable debug messages")

if(CMAKE_TOOLS_DEBUG_MODE)
    set(LOGLEVEL STATUS)
else()
    set(LOGLEVEL VERBOSE)
endif()

set(CMAKE_TOOLS_PATH .)
set(CMAKE_VERSION_TEMPLATE_PATH version.rc.in)


#### PLATFORMS ####
if(APPLE)
    include(platforms/mac)
elseif(UNIX)
    include(platforms/linux)
elseif(WIN32)
    include(platforms/windows)
endif()


#### FUNCTIONS ####
include(CMakePackageConfigHelpers)
include(CMakeParseArguments)
include(dependency_manager/conan)
include(functions/PrivateFunctions)
include(functions/PublicFunctions)
include(compilers.cmake)

enable_testing()

_inject_custom_code()
