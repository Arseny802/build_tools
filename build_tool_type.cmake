include_guard()

if(NOT "${BUILD_TOOL_TYPE_NAME}" STREQUAL "")
  return()
endif(NOT "${BUILD_TOOL_TYPE_NAME}" STREQUAL "") 
message(STATUS "Build tool type name is not specified")

string(FIND "${CMAKE_TOOLCHAIN_FILE}" "conan_toolchain.cmake" UsedConanToolchain REVERSE)
if (UsedConanToolchain EQUAL -1)
  message(STATUS "CMAKE_TOOLCHAIN_FILE: ${CMAKE_TOOLCHAIN_FILE}")
  message(WARNING "No conan toolchain provided - injection aborted")
  return()
endif(UsedConanToolchain EQUAL -1) 

message(STATUS "Conan toolchain is provided - creating build tool type name")

if (NOT "${CMAKE_BINARY_DIR}" STREQUAL "")
  if (UNIX AND NOT APPLE)
      set(profiles
        "lin_gcc_x64_deb"
        "lin_gcc_x64_rel"
        "lin_gcc_x86_deb"
        "lin_gcc_x86_rel"
      )
  elseif (APPLE)
      set(profiles "unsupported")
  else ()
      set(profiles
        "win_gcc_x64_deb"
        "win_gcc_x64_rel"
        "win_gcc_x86_deb"
        "win_gcc_x86_rel"

        "win_clang_x64_deb"
        "win_clang_x64_rel"

        "win_msvc_x64_deb_st"
        "win_msvc_x64_rel_st"
        "win_msvc_x64_deb_dyn"
        "win_msvc_x64_rel_dyn"
        "win_msvc_x86_deb_st"
        "win_msvc_x86_rel_st"
        "win_msvc_x86_deb_dyn"
        "win_msvc_x86_rel_dyn"
      )
  endif (UNIX AND NOT APPLE)

  foreach(profile ${profiles})
    string(FIND "${CMAKE_BINARY_DIR}" "${profile}" profileFound)
    if (NOT profileFound EQUAL -1)
      set(BUILD_TOOL_TYPE_NAME "${profile}")
      message(STATUS 
        "Found build tool type name '${BUILD_TOOL_TYPE_NAME}' "
        "in binary directory:\n${CMAKE_BINARY_DIR}")
      return()
    endif (NOT profileFound EQUAL -1)
  endforeach()
else()
  message(WARNING "Binary directory is not provided")
endif (NOT "${CMAKE_BINARY_DIR}" STREQUAL "")

if(UNIX AND NOT APPLE)
  set(BUILD_TOOL_TYPE_NAME "lin")
elseif(APPLE)
  set(BUILD_TOOL_TYPE_NAME "mac")
else()
  set(BUILD_TOOL_TYPE_NAME "win")
endif(UNIX AND NOT APPLE)

if (NOT "${CMAKE_CXX_COMPILER_ID}" STREQUAL "")
  if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    string(APPEND BUILD_TOOL_TYPE_NAME "_gcc")
  elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    string(APPEND BUILD_TOOL_TYPE_NAME "_clang")
  elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    string(APPEND BUILD_TOOL_TYPE_NAME "_msvc")
  else()
    message(WARNING "Unknown compiler id: ${CMAKE_CXX_COMPILER_ID}")
  endif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
else()
  message(STATUS "CMAKE_GENERATOR: ${CMAKE_GENERATOR}")
  string(FIND "${CMAKE_GENERATOR}" "Visual Studio" IsVisualStudio)
  
  if ("${CMAKE_GENERATOR}" STREQUAL "Unix Makefiles")
    string(APPEND BUILD_TOOL_TYPE_NAME "_gcc")
  elseif (NOT IsVisualStudio EQUAL -1)
    string(APPEND BUILD_TOOL_TYPE_NAME "_msvc")
  else()
    message(STATUS "IsVisualStudio: ${IsVisualStudio}")
    string(APPEND BUILD_TOOL_TYPE_NAME "_clang")
  endif ("${CMAKE_GENERATOR}" STREQUAL "Unix Makefiles")
endif (NOT "${CMAKE_CXX_COMPILER_ID}" STREQUAL "")

cmake_host_system_information(RESULT IS_64BIT QUERY IS_64BIT)
if (IS_64BIT)
  string(APPEND BUILD_TOOL_TYPE_NAME "_x64")
else ()
  string(APPEND BUILD_TOOL_TYPE_NAME "_x86")
endif (IS_64BIT)

if ("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
  string(APPEND BUILD_TOOL_TYPE_NAME "_deb")
elseif ("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
  string(APPEND BUILD_TOOL_TYPE_NAME "_rel")
endif("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
