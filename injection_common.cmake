include_guard()
set(VENDOR "Arseny802")

message(STATUS "-- -- -- -- -- -- -- -- -- -- -- -- -- -- --")
message(STATUS "BUILD_TOOL_TYPE_NAME: ${BUILD_TOOL_TYPE_NAME}")

set(BUILD_ARCHITECTURE "NOT_DEFINED")
if(${BUILD_TOOL_TYPE_NAME} MATCHES "^.*x86.*$")
  message(STATUS "Detected x86 architecture")
  set(BUILD_ARCHITECTURE "x86")
elseif(${BUILD_TOOL_TYPE_NAME} MATCHES "^.*x64.*$")
  message(STATUS "Detected x64 architecture")
  set(BUILD_ARCHITECTURE "x64")
endif()

option(ENABLE_TESTS_BUILD "Enable test target to build" ON)
option(ENABLE_TESTS_RUN "Enable test target to run" ON)

if(BUILD_ARCHITECTURE STREQUAL "NOT_DEFINED")
  message(STATUS "Unknown project type - Single Directory for all not set.")
  return()
else()
  set(CMAKE_BINARY_DIR "${PROJECT_SOURCE_DIR}/_build/bin/${BUILD_TOOL_TYPE_NAME}" CACHE PATH "Install prefix" FORCE)
  set(CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}/_build/bin_install/${BUILD_TOOL_TYPE_NAME}" CACHE PATH "Install prefix" FORCE)
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
  set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
  set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
  set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR} CACHE PATH "Single Directory for all")
endif()

if (ENABLE_TESTS_BUILD)
  enable_testing()
else()
  set(ENABLE_TESTS_RUN OFF CACHE BOOL "Enable test target to build")
endif (ENABLE_TESTS_BUILD)

message("Generator: ${CMAKE_GENERATOR}")
message("Build tool: ${CMAKE_BUILD_TOOL}")
message("Build type: ${CMAKE_BUILD_TYPE}")
message("Build arch: ${BUILD_ARCHITECTURE}")
message("Build directory: ${CMAKE_BINARY_DIR}")
message("Linker falgs: ${CMAKE_LINKER_FLAGS}")
message("Tests build: ${ENABLE_TESTS_BUILD}")
message("Tests run: ${ENABLE_TESTS_RUN}")

cmake_policy(SET CMP0048 NEW)  # manages VERSION variables
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  message(STATUS "GCC detected, adding compile flags")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pipe -pedantic -Wall -Wextra -Wcast-align -Wcast-qual")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wchar-subscripts -Wformat-nonliteral -Wmissing-declarations")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wpointer-arith -Wredundant-decls -Wundef -Wwrite-strings")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unknown-pragmas -pthread")
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "Clang") # building with clang
  message(STATUS "Clang detected, adding compile flags")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DCMAKE_EXPORT_COMPILE_COMMANDS=ON")
  #execute_process(
  #  COMMAND ${CMAKE_COMMAND} -E create_symlink
  #          ${PROJECT_SOURCE_DIR}/_build/${BUILD_TOOL_TYPE_NAME}/compile_commands.json
  #          ${CMAKE_CURRENT_SOURCE_DIR}/compile_commands.json
  #)
elseif (CMAKE_CXX_COMPILER_ID STREQUAL "MSVC") # building on visual c++
  cmake_policy(SET CMP0091 NEW)  # allows select the MSVC runtime library (MT, MD, etc)
  add_compile_options("$<$<C_COMPILER_ID:MSVC>:/utf-8>")
  add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/utf-8>")
  add_definitions("/EHsc")
endif (CMAKE_CXX_COMPILER_ID STREQUAL "GNU")

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  message(STATUS "Build type is debug - setting compile arg \"-D DEBUG\".")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DDEBUG")
  if (CMAKE_COMPILER_IS_GNUCXX)
    execute_process(
      COMMAND ${CMAKE_COMMAND} -E create_symlink
              ${PROJECT_SOURCE_DIR}/_build/${BUILD_TOOL_TYPE_NAME}/compile_commands.json
              ${CMAKE_CURRENT_SOURCE_DIR}/compile_commands.json
    )
  endif (CMAKE_COMPILER_IS_GNUCXX)
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "Release" AND "${BUILD_ARCHITECTURE}" STREQUAL "x64")
  message(STATUS "Build type is relese - setting compile arg \"-D RELEASE\".")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DRELEASE")
endif("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")

set(BUILD_SHARED_LIBS OFF)

if (ENABLE_TESTS_BUILD)
  enable_testing()
endif (ENABLE_TESTS_BUILD)

include(InstallRequiredSystemLibraries)
message(STATUS "-- -- -- -- -- -- -- -- -- -- -- -- -- -- --")
