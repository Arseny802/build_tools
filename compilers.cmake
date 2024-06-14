# Detect compilers and set compile options and definitions

include_guard(GLOBAL)

if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
    include(compilers/gcc)
elseif("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
    include(compilers/msvc)
else()
    message(FATAL_ERROR "Not supported compiler")
endif()

set(PROJECT_DEFAULT_COMPILE_FEATURES
    cxx_std_17
)
