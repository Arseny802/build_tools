# Default compile options and definitions for MSVC

set(PROJECT_DEFAULT_COMPILE_OPTIONS /W3 /bigobj)
set(PROJECT_COMPILE_OPTION_WARNING_AS_ERROR /WX)
set(PROJECT_DEFAULT_COMPILE_DEFINITIONS
    _WIN32_WINNT=0x601 _CRT_SECURE_NO_WARNINGS NOMINMAX)

if(NOT CMAKE_MSVC_RUNTIME_LIBRARY)
    if(CONAN_LINK_RUNTIME)
      if(CONAN_LINK_RUNTIME STREQUAL "/MT")
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded")
      elseif(CONAN_LINK_RUNTIME STREQUAL "/MD")
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDLL")
      elseif(CONAN_LINK_RUNTIME STREQUAL "/MTd")
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDebug")
      elseif(CONAN_LINK_RUNTIME STREQUAL "/MDd")
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreadedDebugDLL")
      endif()
    else()
        set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    endif()
endif()

set(PROJECT_MSVC_RUNTIME_LIBRARY_PROPERTY MSVC_RUNTIME_LIBRARY ${CMAKE_MSVC_RUNTIME_LIBRARY})

if(DEFINED MSVC_STATIC_RUNTIME)
    message(FATAL_ERROR "Option `MSVC_STATIC_RUNTIME` is not supported anymore. "
                        "Use standard `CMAKE_MSVC_RUNTIME_LIBRARY` instead.")
endif()

function(_prepare_compile_options _target_name _include_list _result)
    foreach(include_dir ${${_include_list}})
        # skip expressions with empty string due to we get /external:I with no path and msvc just skipped next flags.
        # also skip expressions like $<INSTALL_INTERFACE:include> and $<BUILD_INTERFACE.*>

        if((${include_dir} MATCHES "^\\$<INSTALL_INTERFACE.*>")
            OR (${include_dir} MATCHES "^\\$<BUILD_INTERFACE.*>")
            OR (${include_dir} STREQUAL "")
            OR (${include_dir} MATCHES "\\$<CONFIG:.+>:>")
         )
            continue()
        elseif(${include_dir} MATCHES "\\$<CONFIG:(.+)>:(.+)>")
            # CMAKE_MATCH_1 - a build CONFIG
            # CMAKE_MATCH_2 - include dir

            if(${CMAKE_MATCH_2} STREQUAL "")
                continue()
            endif()

            # paths like $<$<CONFIG:Debug>:/path/to/third-party/include>
            # become $<$<CONFIG:Debug>:/external:I/path/to/third-party/include>

            list(APPEND _system_include_command
                 "$<$<CONFIG:${CMAKE_MATCH_1}>:${CMAKE_INCLUDE_SYSTEM_FLAG_CXX}${CMAKE_MATCH_2}>")
        else()
            list(APPEND _system_include_command "${CMAKE_INCLUDE_SYSTEM_FLAG_CXX}${include_dir}")
        endif()
    endforeach()

    set(${_result} ${_system_include_command} PARENT_SCOPE)
endfunction()

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

    if(NOT CMAKE_INCLUDE_SYSTEM_FLAG_CXX)
        set(CMAKE_INCLUDE_SYSTEM_FLAG_CXX /external:I)
    endif()

    target_compile_options(${ARGUMENTS_TARGET_NAME} INTERFACE ${CXX_SYSTEM_INCLUDE_CONFIGURATION_FLAG})

    _prepare_compile_options(
        ${ARGUMENTS_TARGET_NAME} ARGUMENTS_SYSTEM_INTERFACE_INCLUDE_DIRECTORIES _interface_compile_options)
    _prepare_compile_options(
        ${ARGUMENTS_TARGET_NAME} ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES   _private_compile_options)
    _prepare_compile_options(
        ${ARGUMENTS_TARGET_NAME} ARGUMENTS_SYSTEM_PUBLIC_INCLUDE_DIRECTORIES    _public_compile_options)

    set(_external_options /experimental:external /external:W0)

    get_target_property(_target_type ${ARGUMENTS_TARGET_NAME} TYPE)
    if(${_target_type} STREQUAL "INTERFACE_LIBRARY")
        target_compile_options(${ARGUMENTS_TARGET_NAME}
            INTERFACE ${_external_options} ${_interface_compile_options}
        )
    else()
        target_compile_options(${ARGUMENTS_TARGET_NAME}
            INTERFACE ${_external_options} ${_interface_compile_options}
            PUBLIC    ${_external_options} ${_public_compile_options}
            PRIVATE   ${_external_options} ${_private_compile_options}
        )
    endif()
endfunction()

function(_compilers_install_specific_files _target)
    get_target_property(_pdb_output_directory ${_target} COMPILE_PDB_OUTPUT_DIRECTORY)
    if(_pdb_output_directory)
        install(FILES ${_pdb_output_directory}/${_target}.pdb DESTINATION ${CMAKE_INSTALL_LIBDIR} OPTIONAL)
    endif()
endfunction()
