# Default compile options and definitions for GCC

set(PROJECT_DEFAULT_COMPILE_OPTIONS -Wall -Wextra -pedantic)
set(PROJECT_COMPILE_OPTION_WARNING_AS_ERROR -Werror)
set(PROJECT_DEFAULT_COMPILE_DEFINITIONS)

function(_compilers_set_system_include_directories)
    set(options)
    set(one_value_args TARGET_NAME)
    set(multi_value_args
        SYSTEM_INTERFACE_INCLUDE_DIRECTORIES
        SYSTEM_PUBLIC_INCLUDE_DIRECTORIES
        SYSTEM_PRIVATE_INCLUDE_DIRECTORIES
    )

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    _check_unparsed_arguments("ARGUMENTS")


    get_target_property(_target_type ${ARGUMENTS_TARGET_NAME} TYPE)

    if(${_target_type} STREQUAL "INTERFACE_LIBRARY")
        target_include_directories(${ARGUMENTS_TARGET_NAME}
            SYSTEM
            INTERFACE ${ARGUMENTS_SYSTEM_INTERFACE_INCLUDE_DIRECTORIES}
        )
    else()
        target_include_directories(${ARGUMENTS_TARGET_NAME}
            SYSTEM
            INTERFACE ${ARGUMENTS_SYSTEM_INTERFACE_INCLUDE_DIRECTORIES}
            PUBLIC ${ARGUMENTS_SYSTEM_PUBLIC_INCLUDE_DIRECTORIES}
            PRIVATE ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}
        )
    endif()
endfunction()
