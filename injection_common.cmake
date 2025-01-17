include_guard()
set(VENDOR "Arseny802")

message(STATUS "-- -- -- -- -- -- -- -- -- -- -- -- -- -- --")
message(STATUS "BUILD_TOOL_TYPE_NAME: ${BUILD_TOOL_TYPE_NAME}")
set(CMAKE_BINARY_DIR "${PROJECT_SOURCE_DIR}/_build/bin/${BUILD_TOOL_TYPE_NAME}")
set(CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/_build/bin_install/${BUILD_TOOL_TYPE_NAME}")

SET(BUILD_ARCHITECTURE "NOT_DEFINED")
if(${BUILD_TOOL_TYPE_NAME} MATCHES "^.*x86.*$")
  message(STATUS "Detected x86 architecture")
  SET(BUILD_ARCHITECTURE "x86")
elseif(${BUILD_TOOL_TYPE_NAME} MATCHES "^.*x64.*$")
  message(STATUS "Detected x64 architecture")
  SET(BUILD_ARCHITECTURE "x64")
endif()

message("Generator: ${CMAKE_GENERATOR}")
message("Build tool: ${CMAKE_BUILD_TOOL}")
message("Build type: ${CMAKE_BUILD_TYPE}")
message("Build arch: ${BUILD_ARCHITECTURE}")
message("Build directory: ${CMAKE_BINARY_DIR}")
message("Linker falgs: ${CMAKE_LINKER_FLAGS}")

SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")

cmake_policy(SET CMP0048 NEW)  # manages VERSION variables
cmake_policy(SET CMP0091 NEW)  # allows select the MSVC runtime library (MT, MD, etc)

if (CMAKE_COMPILER_IS_GNUCXX)
  message(STATUS "GCC detected, adding compile flags")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC -pipe -pedantic -Wall -Wextra -Wcast-align -Wcast-qual")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wchar-subscripts -Wformat-nonliteral -Wmissing-declarations")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wpointer-arith -Wredundant-decls -Wundef -Wwrite-strings")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unknown-pragmas -pthread")
elseif (MSVC) # building on visual c++
  add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
  add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
  add_definitions("/EHsc")
endif (CMAKE_COMPILER_IS_GNUCXX)

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  message(STATUS "Build type is debug - setting compile arg \"-D _DEBUG\".")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D _DEBUG")
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
  message(STATUS "Build type is relese - setting compile arg \"-D _RELEASE\".")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D _RELEASE")
endif()

set(BUILD_SHARED_LIBS OFF)
enable_testing()

include(InstallRequiredSystemLibraries)

