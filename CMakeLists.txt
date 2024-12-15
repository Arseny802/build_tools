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



enable_testing()
