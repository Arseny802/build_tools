# Public API of CMake Tools

function(sysprog_add_library)
    set(options STATIC SHARED MODULE OBJECT INTERFACE DISABLE_WARNING_AS_ERROR_MODE)
    set(one_value_args TARGET_NAME)
    set(multi_value_args
        SOURCE_FILES HEADER_FILES
        PUBLIC_DEFINITIONS PRIVATE_DEFINITIONS INTERFACE_DEFINITIONS

        PUBLIC_LINK_LIBRARIES PRIVATE_LINK_LIBRARIES INTERFACE_LINK_LIBRARIES
        PUBLIC_INCLUDE_DIRECTORIES PRIVATE_INCLUDE_DIRECTORIES INTERFACE_INCLUDE_DIRECTORIES

        SYSTEM_PUBLIC_LINK_LIBRARIES SYSTEM_PRIVATE_LINK_LIBRARIES SYSTEM_INTERFACE_LINK_LIBRARIES
        SYSTEM_PUBLIC_INCLUDE_DIRECTORIES SYSTEM_PRIVATE_INCLUDE_DIRECTORIES SYSTEM_INTERFACE_INCLUDE_DIRECTORIES
    )

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    message(${LOGLEVEL} "sysprog_add_library args:"
        " ${ARGUMENTS_STATIC} ${ARGUMENTS_SHARED} ${ARGUMENTS_MODULE} ${ARGUMENTS_OBJECT} ${ARGUMENTS_INTERFACE} "
        " ${ARGUMENTS_TARGET_NAME} ${ARGUMENTS_SOURCE_FILES} ${ARGUMENTS_HEADER_FILES}"
        " ${ARGUMENTS_PUBLIC_LINK_LIBRARIES} ${ARGUMENTS_PRIVATE_LINK_LIBRARIES}"
        " ${ARGUMENTS_INTERFACE_LINK_LIBRARIES}"
        " ${ARGUMENTS_PUBLIC_DEFINITIONS} ${ARGUMENTS_PRIVATE_DEFINITIONS} ${ARGUMENTS_INTERFACE_DEFINITIONS}"
        " ${ARGUMENTS_PUBLIC_INCLUDE_DIRECTORIES} ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_INTERFACE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_SYSTEM_PUBLIC_LINK_LIBRARIES} ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES}"
        " ${ARGUMENTS_SYSTEM_INTERFACE_LINK_LIBRARIES}"
        " ${ARGUMENTS_SYSTEM_PUBLIC_INCLUDE_DIRECTORIES} ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_SYSTEM_INTERFACE_INCLUDE_DIRECTORIES}"
    )
    _check_unparsed_arguments("ARGUMENTS")

    if(ARGUMENTS_STATIC)
        add_library(${ARGUMENTS_TARGET_NAME} STATIC ${ARGUMENTS_SOURCE_FILES} ${ARGUMENTS_HEADER_FILES})
    elseif(ARGUMENTS_SHARED)
        add_library(${ARGUMENTS_TARGET_NAME} SHARED ${ARGUMENTS_SOURCE_FILES} ${ARGUMENTS_HEADER_FILES})
    elseif(ARGUMENTS_MODULE)
        add_library(${ARGUMENTS_TARGET_NAME} MODULE ${ARGUMENTS_SOURCE_FILES} ${ARGUMENTS_HEADER_FILES})
    elseif(ARGUMENTS_OBJECT)
        add_library(${ARGUMENTS_TARGET_NAME} OBJECT ${ARGUMENTS_SOURCE_FILES} ${ARGUMENTS_HEADER_FILES})
    elseif(ARGUMENTS_INTERFACE)
        add_library(${ARGUMENTS_TARGET_NAME} INTERFACE)
        if(ARGUMENTS_SOURCE_FILES OR ARGUMENTS_HEADER_FILES)
            message(WARNING "Do not pass sources for INTERFACE")
        endif()
    else()
        message(FATAL_ERROR "Pass a library type for ${ARGUMENTS_TARGET_NAME}")
    endif()

    if(ARGUMENTS_DISABLE_WARNING_AS_ERROR_MODE)
        set(_disable_warning_as_error_mode DISABLE_WARNING_AS_ERROR_MODE)
    endif()

    _get_sysprog_targets_settings(
        ${_disable_warning_as_error_mode}
        OUTPUT_COMPILE_FEATURES _compile_features
        OUTPUT_COMPILE_OPTIONS _compile_options
        OUTPUT_COMPILE_DEFINITIONS _compile_definitions
    )

    set(_properties ${SYSPROG_PROJECT_MSVC_RUNTIME_LIBRARY_PROPERTY})

    _append_target_settings(
        TARGET_NAME ${ARGUMENTS_TARGET_NAME}

        PROPERTIES ${_properties}

        PRIVATE_COMPILE_FEATURES ${_compile_features}
        PRIVATE_COMPILE_OPTIONS  ${_compile_options}

        PUBLIC_DEFINITIONS    ${ARGUMENTS_PUBLIC_DEFINITIONS}
        PRIVATE_DEFINITIONS   ${ARGUMENTS_PRIVATE_DEFINITIONS} ${_compile_definitions}
        INTERFACE_DEFINITIONS ${ARGUMENTS_INTERFACE_DEFINITIONS}

        PUBLIC_LINK_LIBRARIES    ${ARGUMENTS_PUBLIC_LINK_LIBRARIES}
        PRIVATE_LINK_LIBRARIES   ${ARGUMENTS_PRIVATE_LINK_LIBRARIES}
        INTERFACE_LINK_LIBRARIES ${ARGUMENTS_INTERFACE_LINK_LIBRARIES}

        PUBLIC_INCLUDE_DIRECTORIES    ${ARGUMENTS_PUBLIC_INCLUDE_DIRECTORIES}
        PRIVATE_INCLUDE_DIRECTORIES   ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES}
        INTERFACE_INCLUDE_DIRECTORIES ${ARGUMENTS_INTERFACE_INCLUDE_DIRECTORIES}

        SYSTEM_PUBLIC_LINK_LIBRARIES    ${ARGUMENTS_SYSTEM_PUBLIC_LINK_LIBRARIES}
        SYSTEM_PRIVATE_LINK_LIBRARIES   ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES}
        SYSTEM_INTERFACE_LINK_LIBRARIES ${ARGUMENTS_SYSTEM_INTERFACE_LINK_LIBRARIES}

        SYSTEM_PUBLIC_INCLUDE_DIRECTORIES    ${ARGUMENTS_SYSTEM_PUBLIC_INCLUDE_DIRECTORIES}
        SYSTEM_PRIVATE_INCLUDE_DIRECTORIES   ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}
        SYSTEM_INTERFACE_INCLUDE_DIRECTORIES ${ARGUMENTS_SYSTEM_INTERFACE_INCLUDE_DIRECTORIES}
    )
endfunction()

function(sysprog_add_executable)
    set(options DISABLE_WARNING_AS_ERROR_MODE)
    set(one_value_args TARGET_NAME)
    set(multi_value_args
        SOURCE_FILES HEADER_FILES
        PUBLIC_DEFINITIONS PRIVATE_DEFINITIONS INTERFACE_DEFINITIONS

        PUBLIC_LINK_LIBRARIES PRIVATE_LINK_LIBRARIES INTERFACE_LINK_LIBRARIES
        PUBLIC_INCLUDE_DIRECTORIES PRIVATE_INCLUDE_DIRECTORIES INTERFACE_INCLUDE_DIRECTORIES

        SYSTEM_PUBLIC_LINK_LIBRARIES SYSTEM_PRIVATE_LINK_LIBRARIES SYSTEM_INTERFACE_LINK_LIBRARIES
        SYSTEM_PUBLIC_INCLUDE_DIRECTORIES SYSTEM_PRIVATE_INCLUDE_DIRECTORIES SYSTEM_INTERFACE_INCLUDE_DIRECTORIES
    )

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    message(${LOGLEVEL} "sysprog_add_executable args:"
        " ${ARGUMENTS_TARGET_NAME} ${ARGUMENTS_SOURCE_FILES} ${ARGUMENTS_HEADER_FILES}"
        " ${ARGUMENTS_PUBLIC_LINK_LIBRARIES} ${ARGUMENTS_PRIVATE_LINK_LIBRARIES}"
        " ${ARGUMENTS_INTERFACE_LINK_LIBRARIES}"
        " ${ARGUMENTS_PUBLIC_DEFINITIONS} ${ARGUMENTS_PRIVATE_DEFINITIONS} ${ARGUMENTS_INTERFACE_DEFINITIONS}"
        " ${ARGUMENTS_PUBLIC_INCLUDE_DIRECTORIES} ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_INTERFACE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_SYSTEM_PUBLIC_LINK_LIBRARIES} ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES}"
        " ${ARGUMENTS_SYSTEM_INTERFACE_LINK_LIBRARIES}"
        " ${ARGUMENTS_SYSTEM_PUBLIC_INCLUDE_DIRECTORIES} ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_SYSTEM_INTERFACE_INCLUDE_DIRECTORIES}"
    )
    _check_unparsed_arguments("ARGUMENTS")

    add_executable(${ARGUMENTS_TARGET_NAME}
        ${ARGUMENTS_SOURCE_FILES}
        ${ARGUMENTS_HEADER_FILES}
    )

    if(ARGUMENTS_DISABLE_WARNING_AS_ERROR_MODE)
        set(_disable_warning_as_error_mode DISABLE_WARNING_AS_ERROR_MODE)
    endif()

    _get_sysprog_targets_settings(
        ${_disable_warning_as_error_mode}
        OUTPUT_COMPILE_FEATURES _compile_features
        OUTPUT_COMPILE_OPTIONS _compile_options
        OUTPUT_COMPILE_DEFINITIONS _compile_definitions
    )

    set(_properties ${SYSPROG_PROJECT_MSVC_RUNTIME_LIBRARY_PROPERTY})

    _append_target_settings(
        TARGET_NAME ${ARGUMENTS_TARGET_NAME}

        PROPERTIES ${_properties}

        PRIVATE_COMPILE_FEATURES ${_compile_features}
        PRIVATE_COMPILE_OPTIONS ${_compile_options}

        PUBLIC_DEFINITIONS
            ${ARGUMENTS_PUBLIC_DEFINITIONS}
        PRIVATE_DEFINITIONS
            ${ARGUMENTS_PRIVATE_DEFINITIONS}
            ${_compile_definitions}

        INTERFACE_DEFINITIONS
            ${ARGUMENTS_INTERFACE_DEFINITIONS}

        PUBLIC_LINK_LIBRARIES
            ${ARGUMENTS_PUBLIC_LINK_LIBRARIES}
        PRIVATE_LINK_LIBRARIES
            ${ARGUMENTS_PRIVATE_LINK_LIBRARIES}
        INTERFACE_LINK_LIBRARIES
            ${ARGUMENTS_INTERFACE_LINK_LIBRARIES}

        PUBLIC_INCLUDE_DIRECTORIES
            ${ARGUMENTS_PUBLIC_INCLUDE_DIRECTORIES}
        PRIVATE_INCLUDE_DIRECTORIES
            ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES}
        INTERFACE_INCLUDE_DIRECTORIES
            ${ARGUMENTS_INTERFACE_INCLUDE_DIRECTORIES}

        SYSTEM_PUBLIC_LINK_LIBRARIES
            ${ARGUMENTS_SYSTEM_PUBLIC_LINK_LIBRARIES}
        SYSTEM_PRIVATE_LINK_LIBRARIES
            ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES}
        SYSTEM_INTERFACE_LINK_LIBRARIES
            ${ARGUMENTS_SYSTEM_INTERFACE_LINK_LIBRARIES}

        SYSTEM_PUBLIC_INCLUDE_DIRECTORIES
            ${ARGUMENTS_SYSTEM_PUBLIC_INCLUDE_DIRECTORIES}
        SYSTEM_PRIVATE_INCLUDE_DIRECTORIES
            ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}
        SYSTEM_INTERFACE_INCLUDE_DIRECTORIES
            ${ARGUMENTS_SYSTEM_INTERFACE_INCLUDE_DIRECTORIES}
    )

    source_group("Sources" FILES ${ARGUMENTS_SOURCE_FILES})
    source_group("Headers" FILES ${ARGUMENTS_HEADER_FILES})
endfunction()

function(add_main_executable)
    set(options DISABLE_WARNING_AS_ERROR_MODE)
    set(one_value_args)
    set(multi_value_args
        SOURCE_FILES HEADER_FILES PROTO_DIRECTORIES_NAMES PROTO_FILES
        DEPENDENCIES
        PUBLIC_DEFINITIONS PRIVATE_DEFINITIONS INTERFACE_DEFINITIONS

        PUBLIC_LINK_LIBRARIES PRIVATE_LINK_LIBRARIES INTERFACE_LINK_LIBRARIES
        PUBLIC_INCLUDE_DIRECTORIES PRIVATE_INCLUDE_DIRECTORIES INTERFACE_INCLUDE_DIRECTORIES

        SYSTEM_PUBLIC_LINK_LIBRARIES SYSTEM_PRIVATE_LINK_LIBRARIES SYSTEM_INTERFACE_LINK_LIBRARIES
        SYSTEM_PUBLIC_INCLUDE_DIRECTORIES SYSTEM_PRIVATE_INCLUDE_DIRECTORIES SYSTEM_INTERFACE_INCLUDE_DIRECTORIES
    )

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    message(${LOGLEVEL} "add_main_executable args: "
        " ${ARGUMENTS_SOURCE_FILES} ${ARGUMENTS_HEADER_FILES} ${ARGUMENTS_PROTO_FILES}"
        " ${ARGUMENTS_PUBLIC_LINK_LIBRARIES} ${ARGUMENTS_PRIVATE_LINK_LIBRARIES}"
        " ${ARGUMENTS_INTERFACE_LINK_LIBRARIES} ${ARGUMENTS_DEPENDENCIES}"
        " ${ARGUMENTS_PUBLIC_DEFINITIONS} ${ARGUMENTS_PRIVATE_DEFINITIONS} ${ARGUMENTS_INTERFACE_DEFINITIONS}"
        " ${ARGUMENTS_PUBLIC_INCLUDE_DIRECTORIES} ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_INTERFACE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_SYSTEM_PUBLIC_LINK_LIBRARIES} ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES}"
        " ${ARGUMENTS_SYSTEM_INTERFACE_LINK_LIBRARIES}"
        " ${ARGUMENTS_SYSTEM_PUBLIC_INCLUDE_DIRECTORIES} ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_SYSTEM_INTERFACE_INCLUDE_DIRECTORIES}"
    )
    _check_unparsed_arguments("ARGUMENTS")

    # exclude main.cpp
    set(main_cpp)
    foreach( _file_path ${ARGUMENTS_SOURCE_FILES} )
        get_filename_component(_file_name ${_file_path} NAME)

        if(_file_name STREQUAL "main.cpp")
            set(main_cpp ${_file_path})
            list(REMOVE_ITEM ARGUMENTS_SOURCE_FILES ${_file_path})
        endif()
    endforeach()

    message(${LOGLEVEL} "main_cpp: ${main_cpp}")

    if(ARGUMENTS_PROTO_FILES)
        message(FATAL_ERROR "the argument `PROTO_FILES` for add_main_executable is deprecated now. "
            "please use `PROTO_DIRECTORIES_NAMES` instead.")
    endif()

    sysprog_dependencies_targets(
        DEPENDENCIES ${ARGUMENTS_DEPENDENCIES}

        OUTPUT_MAIN_TARGETS _all_main_targets
        OUTPUT_MOCK_TARGETS _all_mock_targets
    )

    message(${LOGLEVEL} "add_main_executable _all_main_targets: ${_all_main_targets}")
    message(${LOGLEVEL} "add_main_executable _all_mock_targets: ${_all_mock_targets}")

    foreach(_target ${_all_main_targets})
        _append_target_settings(
            TARGET_NAME ${_target}

            PUBLIC_DEFINITIONS ${ARGUMENTS_PUBLIC_DEFINITIONS}
            PRIVATE_DEFINITIONS ${ARGUMENTS_PRIVATE_DEFINITIONS}
            INTERFACE_DEFINITIONS ${ARGUMENTS_INTERFACE_DEFINITIONS}
        )
    endforeach()

    _add_targets_group(_all_main_targets)

    if(ARGUMENTS_DISABLE_WARNING_AS_ERROR_MODE)
        set(_disable_warning_as_error_mode DISABLE_WARNING_AS_ERROR_MODE)
    endif()

    if(ARGUMENTS_SOURCE_FILES)
        sysprog_add_library(
            TARGET_NAME ${PROJECT_NAME}_core
            ${_disable_warning_as_error_mode}

            OBJECT

            SOURCE_FILES ${ARGUMENTS_SOURCE_FILES}
            HEADER_FILES ${ARGUMENTS_HEADER_FILES}

            PUBLIC_INCLUDE_DIRECTORIES
                ${ARGUMENTS_PUBLIC_INCLUDE_DIRECTORIES}
            .

            PRIVATE_INCLUDE_DIRECTORIES ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES}
            INTERFACE_INCLUDE_DIRECTORIES ${ARGUMENTS_INTERFACE_INCLUDE_DIRECTORIES}

            PUBLIC_LINK_LIBRARIES
                ${ARGUMENTS_PUBLIC_LINK_LIBRARIES}
                ${_all_main_targets}

            PRIVATE_LINK_LIBRARIES ${ARGUMENTS_PRIVATE_LINK_LIBRARIES}
            INTERFACE_LINK_LIBRARIES ${ARGUMENTS_INTERFACE_LINK_LIBRARIES}

            SYSTEM_PUBLIC_INCLUDE_DIRECTORIES
                ${CMAKE_INCLUDE_PATH}
                ${ARGUMENTS_SYSTEM_PUBLIC_INCLUDE_DIRECTORIES}

            SYSTEM_PRIVATE_INCLUDE_DIRECTORIES ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}
            SYSTEM_INTERFACE_INCLUDE_DIRECTORIES ${ARGUMENTS_SYSTEM_INTERFACE_INCLUDE_DIRECTORIES}

            SYSTEM_PUBLIC_LINK_LIBRARIES
                ${ARGUMENTS_SYSTEM_PUBLIC_LINK_LIBRARIES}
                ${_protos_lib}
            SYSTEM_PRIVATE_LINK_LIBRARIES ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES}
            SYSTEM_INTERFACE_LINK_LIBRARIES ${ARGUMENTS_SYSTEM_INTERFACE_LINK_LIBRARIES}

            PUBLIC_DEFINITIONS ${ARGUMENTS_PUBLIC_DEFINITIONS}
            PRIVATE_DEFINITIONS ${ARGUMENTS_PRIVATE_DEFINITIONS}
            INTERFACE_DEFINITIONS ${ARGUMENTS_INTERFACE_DEFINITIONS}
        )

        add_library(${PROJECT_NAME}::core ALIAS ${PROJECT_NAME}_core)
    endif()

    # make interface for dependencies tests
    # todo: check _build_tests_option is on
    if(_all_mock_targets)
        sysprog_add_library(
            TARGET_NAME ${PROJECT_NAME}_dependencies_mocks
            ${_disable_warning_as_error_mode}

            INTERFACE
            INTERFACE_LINK_LIBRARIES ${_all_mock_targets}
        )

        add_library(${PROJECT_NAME}::dependencies_mocks ALIAS ${PROJECT_NAME}_dependencies_mocks)
    endif()

    if(TARGET ${PROJECT_NAME}::core)
        set(_core_lib ${PROJECT_NAME}::core)
    endif()

    _get_version_info_resource_file(_version_info_resource_file)

    sysprog_add_executable(
        TARGET_NAME ${PROJECT_NAME}
        ${_disable_warning_as_error_mode}

        SOURCE_FILES ${main_cpp} ${_version_info_resource_file}

        PRIVATE_LINK_LIBRARIES ${_core_lib}

        PUBLIC_DEFINITIONS ${ARGUMENTS_PUBLIC_DEFINITIONS}
        PRIVATE_DEFINITIONS ${ARGUMENTS_PRIVATE_DEFINITIONS}
    )

    _set_default_output_directory(${PROJECT_NAME})
    _run_conan_imports_to_target(${PROJECT_NAME})
endfunction()

function(sysprog_dependencies_targets)
    set(options)
    set(one_value_args DEPENDENCIES_DIR OUTPUT_MAIN_TARGETS OUTPUT_MOCK_TARGETS OUTPUT_TEST_TARGETS)
    set(multi_value_args DEPENDENCIES)

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    message(${LOGLEVEL} "sysprog_dependencies_targets args:"
        " ${ARGUMENTS_DEPENDENCIES_DIR} ${ARGUMENTS_OUTPUT_MAIN_TARGETS} ${ARGUMENTS_OUTPUT_TEST_TARGETS}"
        " ${ARGUMENTS_OUTPUT_MOCK_TARGETS} ${ARGUMENTS_DEPENDENCIES}"
    )
    _check_unparsed_arguments("ARGUMENTS")

    foreach(_dependency ${ARGUMENTS_DEPENDENCIES})
        get_filename_component(_dependency_name ${_dependency} NAME)

        _get_cached_targets(_dependency_targets ${_dependency} ${ARGUMENTS_DEPENDENCIES_DIR})

        foreach(_target ${_dependency_targets})
            # e.g. _dependency dir is `db.lib` but target's name is `finam.db`
            # or for `finam.monitoring` target is just `monitoring`
            if((_target MATCHES "^finam\\.*" AND NOT _target MATCHES "\\.mocks$" AND NOT _target MATCHES "\\_mocks$"
                    AND NOT _target MATCHES "\\.test[s]?$")
                OR ${_target} STREQUAL "${_dependency_name}" OR "finam.${_target}" STREQUAL "${_dependency_name}")
                list(APPEND _all_main_targets ${_target})

                if(NOT _target MATCHES "^finam\\.*" AND ${_target} STREQUAL "${_dependency_name}")
                    message(WARNING
                        " Do not pass target `${_target}` to DEPENDENCIES. Link it properly:        \n"
                        "   PUBLIC_LINK_LIBRARIES                                                   \n"
                        "       sysprog::${_target}                                                 \n"
                        " If `${_target}` has mocks you have to link them to tests properly too:    \n"
                        "   add_tests_executable(                                                   \n"
                        "       ...                                                                 \n"
                        "       PRIVATE_LINK_LIBRARIES                                              \n"
                        "           sysprog::${_target}::mocks                                      \n"
                        "   )                                                                       \n"
                    )
                endif()
            elseif(_target MATCHES "\\.mocks$")
                list(APPEND _all_mock_targets ${_target})
            elseif(_target MATCHES "\\.test[s]?$")
                list(APPEND _all_test_targets ${_target})
            endif()
        endforeach()
    endforeach()

    if(ARGUMENTS_OUTPUT_MAIN_TARGETS)
        set(${ARGUMENTS_OUTPUT_MAIN_TARGETS} ${_all_main_targets} PARENT_SCOPE)
    endif()

    if(ARGUMENTS_OUTPUT_MOCK_TARGETS)
        set(${ARGUMENTS_OUTPUT_MOCK_TARGETS} ${_all_mock_targets} PARENT_SCOPE)
    endif()

    if(ARGUMENTS_OUTPUT_TEST_TARGETS)
        set(${ARGUMENTS_OUTPUT_TEST_TARGETS} ${_all_test_targets} PARENT_SCOPE)
    endif()
endfunction()

function(add_tests_executable)
    set(options DISABLE_WARNING_AS_ERROR_MODE)
    set(one_value_args)
    set(multi_value_args
        SOURCE_FILES HEADER_FILES PROTO_DIRECTORIES_NAMES PROTO_FILES

        PRIVATE_DEFINITIONS
        CTEST_PROPERTIES

        PRIVATE_INCLUDE_DIRECTORIES
        SYSTEM_PRIVATE_INCLUDE_DIRECTORIES

        SYSTEM_PRIVATE_LINK_LIBRARIES
    )

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    message(${LOGLEVEL} "add_tests_executable args: "
        " ${ARGUMENTS_SOURCE_FILES} ${ARGUMENTS_HEADER_FILES} ${ARGUMENTS_PROTO_FILES}"
        " ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES} ${ARGUMENTS_PRIVATE_DEFINITIONS}"
        " ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES} ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_CTEST_PROPERTIES}"
    )
    _check_unparsed_arguments("ARGUMENTS")

    if(TARGET ${PROJECT_NAME}::core)
        set(_core_lib ${PROJECT_NAME}::core)
    endif()

    if(TARGET ${PROJECT_NAME}::dependencies_mocks)
        set(_mocks_lib ${PROJECT_NAME}::dependencies_mocks)
    endif()

    if(ARGUMENTS_PROTO_FILES)
        message(FATAL_ERROR "the argument `PROTO_FILES` for add_tests_executable is deprecated now. "
                "please use `PROTO_DIRECTORIES_NAMES` instead.")
    endif()

    if(ARGUMENTS_DISABLE_WARNING_AS_ERROR_MODE)
        set(_disable_warning_as_error_mode DISABLE_WARNING_AS_ERROR_MODE)
    endif()

    sysprog_add_executable(
        TARGET_NAME ${PROJECT_NAME}.tests
        ${_disable_warning_as_error_mode}

        SOURCE_FILES ${ARGUMENTS_SOURCE_FILES}
        HEADER_FILES ${ARGUMENTS_HEADER_FILES}

        PRIVATE_LINK_LIBRARIES
            ${_core_lib}
            ${_mocks_lib}

        PRIVATE_DEFINITIONS ${ARGUMENTS_PRIVATE_DEFINITIONS}
        PRIVATE_INCLUDE_DIRECTORIES
            ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES}
            ${CMAKE_CURRENT_SOURCE_DIR}/include
        .
            ${PROJECT_SOURCE_DIR}/src

        SYSTEM_PRIVATE_INCLUDE_DIRECTORIES
            ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}

        SYSTEM_PRIVATE_LINK_LIBRARIES
            ${_protos_lib}
            ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES}
    )

    _get_gtest_output_arg(OUTPUT_GTEST_ARG _gtest_output_arg)

    add_test(
        NAME ${PROJECT_NAME}.tests
        COMMAND $<TARGET_FILE:${PROJECT_NAME}.tests> ${_gtest_output_arg}
    )

    if(ARGUMENTS_CTEST_PROPERTIES)
        set_tests_properties(${PROJECT_NAME}.tests
            PROPERTIES ${ARGUMENTS_CTEST_PROPERTIES}
        )
    endif()
endfunction()

function(add_submodule_library)
    set(options STATIC INTERFACE DISABLE_WARNING_AS_ERROR_MODE OPTIONAL ENABLE_BY_DEFAULT)
    set(one_value_args TARGET_NAME)
    set(multi_value_args
        PUBLIC_HEADER_FILES SOURCE_FILES HEADER_FILES PROTO_DIRECTORIES_NAMES PROTO_FILES
        DEPENDENCIES
        PUBLIC_DEFINITIONS PRIVATE_DEFINITIONS INTERFACE_DEFINITIONS

        PUBLIC_LINK_LIBRARIES PRIVATE_LINK_LIBRARIES INTERFACE_LINK_LIBRARIES
        PUBLIC_INCLUDE_DIRECTORIES PRIVATE_INCLUDE_DIRECTORIES INTERFACE_INCLUDE_DIRECTORIES

        SYSTEM_PUBLIC_LINK_LIBRARIES SYSTEM_PRIVATE_LINK_LIBRARIES SYSTEM_INTERFACE_LINK_LIBRARIES
        SYSTEM_PUBLIC_INCLUDE_DIRECTORIES SYSTEM_PRIVATE_INCLUDE_DIRECTORIES SYSTEM_INTERFACE_INCLUDE_DIRECTORIES
    )

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    message(${LOGLEVEL} "add_submodule_library args:"
        " ${ARGUMENTS_STATIC} ${ARGUMENTS_INTERFACE} "
        " ${ARGUMENTS_PUBLIC_HEADER_FILES}"
        " ${ARGUMENTS_SOURCE_FILES} ${ARGUMENTS_HEADER_FILES}"
        " ${ARGUMENTS_PROTO_FILES} ${ARGUMENTS_PROTO_DIRECTORIES_NAMES}"
        " ${ARGUMENTS_PUBLIC_LINK_LIBRARIES} ${ARGUMENTS_PRIVATE_LINK_LIBRARIES}"
        " ${ARGUMENTS_INTERFACE_LINK_LIBRARIES}"
        " ${ARGUMENTS_PUBLIC_DEFINITIONS} ${ARGUMENTS_PRIVATE_DEFINITIONS} ${ARGUMENTS_INTERFACE_DEFINITIONS}"
        " ${ARGUMENTS_PUBLIC_INCLUDE_DIRECTORIES} ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_INTERFACE_INCLUDE_DIRECTORIES} ${ARGUMENTS_DEPENDENCIES}"
        " ${ARGUMENTS_SYSTEM_PUBLIC_LINK_LIBRARIES} ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES}"
        " ${ARGUMENTS_SYSTEM_INTERFACE_LINK_LIBRARIES}"
        " ${ARGUMENTS_SYSTEM_PUBLIC_INCLUDE_DIRECTORIES} ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_SYSTEM_INTERFACE_INCLUDE_DIRECTORIES}"
    )
    _check_unparsed_arguments("ARGUMENTS")

    if(NOT ARGUMENTS_TARGET_NAME)
        set(ARGUMENTS_TARGET_NAME ${PROJECT_NAME})
    endif()

    set(_target_alias_prefix sysprog)
    set(_inner_target_name ${ARGUMENTS_TARGET_NAME})
    if(ARGUMENTS_OPTIONAL)
        # support the same name for optional target in different submodules
        set(_inner_target_name ${PROJECT_NAME}.${ARGUMENTS_TARGET_NAME})

        set(_target_alias_prefix sysprog::${PROJECT_NAME})

        if(ARGUMENTS_ENABLE_BY_DEFAULT)
            set(_enable_by_default_flag ENABLE_BY_DEFAULT)
        endif()

        _check_target_is_enabled(${PROJECT_NAME}_${ARGUMENTS_TARGET_NAME} ${_enable_by_default_flag})
    endif()

    get_filename_component(_dependency_absolute_path "../.." ABSOLUTE BASE_DIR ${CMAKE_SOURCE_DIR})
    if(NOT "${CMAKE_SOURCE_DIR}/dependency" STREQUAL ${_dependency_absolute_path})
        message(FATAL_ERROR "Seems like you want to use subproject as dependency. That's not allowed. Use optional targets instead.")
    endif()

    sysprog_dependencies_targets(
        DEPENDENCIES ${ARGUMENTS_DEPENDENCIES}
        DEPENDENCIES_DIR ${CMAKE_SOURCE_DIR}/dependency
        OUTPUT_MAIN_TARGETS _all_main_dependencies_targets
        OUTPUT_MOCK_TARGETS _all_mock_targets
    )

    set(_lib_type STATIC)
    if(ARGUMENTS_INTERFACE)
        set(_lib_type INTERFACE)
        set(ARGUMENTS_INTERFACE_INCLUDE_DIRECTORIES
                ${PROJECT_SOURCE_DIR}/include
                ${ARGUMENTS_INTERFACE_INCLUDE_DIRECTORIES}
            )
    endif()

    if(ARGUMENTS_PROTO_FILES)
        message(FATAL_ERROR "the argument `PROTO_FILES` for add_submodule_library is deprecated now. "
                "please use `PROTO_DIRECTORIES_NAMES` instead.")
    endif()

    if(ARGUMENTS_DISABLE_WARNING_AS_ERROR_MODE)
        set(_disable_warning_as_error_mode DISABLE_WARNING_AS_ERROR_MODE)
    endif()

    sysprog_add_library(
        TARGET_NAME ${_inner_target_name}
        ${_disable_warning_as_error_mode}

        ${_lib_type}

        SOURCE_FILES ${ARGUMENTS_SOURCE_FILES}
        HEADER_FILES ${ARGUMENTS_HEADER_FILES} ${ARGUMENTS_PUBLIC_HEADER_FILES}

        PUBLIC_INCLUDE_DIRECTORIES
            ${PROJECT_SOURCE_DIR}/include
            ${ARGUMENTS_PUBLIC_INCLUDE_DIRECTORIES}

        PRIVATE_INCLUDE_DIRECTORIES
        .
            ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES}

        INTERFACE_INCLUDE_DIRECTORIES
            ${ARGUMENTS_INTERFACE_INCLUDE_DIRECTORIES}

        SYSTEM_PUBLIC_INCLUDE_DIRECTORIES
            ${CMAKE_INCLUDE_PATH}
            ${ARGUMENTS_SYSTEM_PUBLIC_INCLUDE_DIRECTORIES}

        SYSTEM_PRIVATE_INCLUDE_DIRECTORIES
            ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}

        SYSTEM_INTERFACE_INCLUDE_DIRECTORIES
            ${ARGUMENTS_SYSTEM_INTERFACE_INCLUDE_DIRECTORIES}

        PUBLIC_LINK_LIBRARIES
            ${ARGUMENTS_PUBLIC_LINK_LIBRARIES}
            ${_all_main_dependencies_targets}

        PRIVATE_LINK_LIBRARIES   ${ARGUMENTS_PRIVATE_LINK_LIBRARIES}
        INTERFACE_LINK_LIBRARIES ${ARGUMENTS_INTERFACE_LINK_LIBRARIES}

        SYSTEM_PUBLIC_LINK_LIBRARIES
            ${ARGUMENTS_SYSTEM_PUBLIC_LINK_LIBRARIES}
            ${_protos_lib}

        SYSTEM_PRIVATE_LINK_LIBRARIES   ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES}
        SYSTEM_INTERFACE_LINK_LIBRARIES ${ARGUMENTS_SYSTEM_INTERFACE_LINK_LIBRARIES}

        PUBLIC_DEFINITIONS    ${ARGUMENTS_PUBLIC_DEFINITIONS}
        PRIVATE_DEFINITIONS   ${ARGUMENTS_PRIVATE_DEFINITIONS}
        INTERFACE_DEFINITIONS ${ARGUMENTS_INTERFACE_DEFINITIONS}
    )

    add_library(${_target_alias_prefix}::${ARGUMENTS_TARGET_NAME} ALIAS ${_inner_target_name})

    if(NOT ARGUMENTS_INTERFACE)
        _set_default_output_directory(${_inner_target_name})
    endif()

    # make interface for dependencies tests
    # todo: check _build_tests_option is on
    if(_all_mock_targets)
        sysprog_add_library(
            TARGET_NAME ${_inner_target_name}_dependencies_mocks
            ${_disable_warning_as_error_mode}

            INTERFACE
            INTERFACE_LINK_LIBRARIES ${_all_mock_targets}
        )

        add_library(${_target_alias_prefix}::${ARGUMENTS_TARGET_NAME}::dependencies_mocks
                    ALIAS ${_inner_target_name}_dependencies_mocks)
    endif()

    source_group(
        TREE ${PROJECT_SOURCE_DIR}/include
        PREFIX "Public header files"
        FILES ${ARGUMENTS_PUBLIC_HEADER_FILES}
    )

    source_group(
        TREE .
        PREFIX "Header files"
        FILES ${ARGUMENTS_HEADER_FILES}
    )

    source_group(
        TREE .
        PREFIX "Source files"
        FILES ${ARGUMENTS_SOURCE_FILES}
    )
endfunction()

function(add_submodule_tests)
    set(options DISABLE_WARNING_AS_ERROR_MODE)
    set(one_value_args TARGET_NAME)
    set(multi_value_args
        SOURCE_FILES HEADER_FILES PROTO_DIRECTORIES_NAMES PROTO_FILES
        DEPENDENCIES
        CTEST_PROPERTIES
        PRIVATE_DEFINITIONS

        PRIVATE_INCLUDE_DIRECTORIES
        SYSTEM_PRIVATE_LINK_LIBRARIES SYSTEM_PRIVATE_INCLUDE_DIRECTORIES
    )

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    message(${LOGLEVEL} "add_submodule_tests args:"
        " ${ARGUMENTS_SOURCE_FILES} ${ARGUMENTS_HEADER_FILES} ${ARGUMENTS_PROTO_FILES}"
        " ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES} ${ARGUMENTS_PRIVATE_DEFINITIONS} ${ARGUMENTS_DEPENDENCIES}"
        " ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES} ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}"
        " ${ARGUMENTS_CTEST_PROPERTIES}"
    )
    _check_unparsed_arguments("ARGUMENTS")

    set(_inner_target_name ${PROJECT_NAME})
    set(_target_alias_prefix sysprog)

    if (ARGUMENTS_TARGET_NAME)
        set(_inner_target_name ${_inner_target_name}.${ARGUMENTS_TARGET_NAME})
        set(_target_alias_prefix sysprog::${PROJECT_NAME})
    else()
        set(ARGUMENTS_TARGET_NAME ${PROJECT_NAME})
    endif()

    set(_inner_tests_name ${_inner_target_name}.tests)

    sysprog_dependencies_targets(
        DEPENDENCIES_DIR ${CMAKE_SOURCE_DIR}/dependency
        DEPENDENCIES ${ARGUMENTS_DEPENDENCIES}

        OUTPUT_MAIN_TARGETS _all_main_targets
        OUTPUT_MOCK_TARGETS _all_mock_targets
    )

    list(APPEND _all_main_targets ${_inner_target_name})

    if(TARGET ${_target_alias_prefix}::${ARGUMENTS_TARGET_NAME}::dependencies_mocks)
        list(APPEND _all_mock_targets ${_target_alias_prefix}::${ARGUMENTS_TARGET_NAME}::dependencies_mocks)
    endif()

    if(ARGUMENTS_PROTO_FILES)
        message(FATAL_ERROR "the argument `PROTO_FILES` for add_submodule_tests is deprecated now. "
                "please use `PROTO_DIRECTORIES_NAMES` instead.")
    endif()

    _add_targets_group(_all_main_targets)

    message(${LOGLEVEL} "add_submodule_tests _all_main_targets: ${_all_main_targets}")
    message(${LOGLEVEL} "add_submodule_tests _all_mock_targets: ${_all_mock_targets}")

    if(ARGUMENTS_DISABLE_WARNING_AS_ERROR_MODE)
        set(_disable_warning_as_error_mode DISABLE_WARNING_AS_ERROR_MODE)
    endif()

    sysprog_add_executable(
        TARGET_NAME ${_inner_tests_name}
        ${_disable_warning_as_error_mode}

        SOURCE_FILES ${ARGUMENTS_SOURCE_FILES}
        HEADER_FILES ${ARGUMENTS_HEADER_FILES}

        PRIVATE_LINK_LIBRARIES
            ${_all_main_targets}
            ${_all_mock_targets}

        PUBLIC_DEFINITIONS ${ARGUMENTS_PUBLIC_DEFINITIONS}
        PRIVATE_DEFINITIONS ${ARGUMENTS_PRIVATE_DEFINITIONS}

        PRIVATE_INCLUDE_DIRECTORIES
            ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES}
            ${CMAKE_CURRENT_SOURCE_DIR}/include
        .
            ${PROJECT_SOURCE_DIR}/src

        SYSTEM_PRIVATE_INCLUDE_DIRECTORIES
            ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}

        SYSTEM_PRIVATE_LINK_LIBRARIES
            ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES}
            ${_protos_lib}
    )

    _get_gtest_output_arg(OUTPUT_GTEST_ARG _gtest_output_arg)

    add_test(
        NAME ${_inner_tests_name}
        COMMAND $<TARGET_FILE:${_inner_tests_name}> ${_gtest_output_arg}
    )

    if(ARGUMENTS_CTEST_PROPERTIES)
        set_tests_properties(${_inner_tests_name}
            PROPERTIES ${ARGUMENTS_CTEST_PROPERTIES}
        )
    endif()
endfunction()

macro(run_conan_install_default)
     _get_conanfile(_conanfile)
    if(EXISTS ${_conanfile} AND NOT _variables_package_manager_is_vcpkg)
        if(NOT ${CMAKE_CURRENT_BINARY_DIR} IN_LIST CMAKE_MODULE_PATH)
            list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_BINARY_DIR})
        endif()

        if(NOT ${CMAKE_CURRENT_BINARY_DIR} IN_LIST CMAKE_PREFIX_PATH)
            list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_BINARY_DIR})
        endif()

        # force supported configs only
        if(NOT DEFINED CMAKE_BUILD_TYPE)
            set(CMAKE_CONFIGURATION_TYPES Debug;RelWithDebInfo)
        endif()

        if(NOT DEFINED CONAN_CMAKE_SILENT_OUTPUT)
            set(CONAN_CMAKE_SILENT_OUTPUT ON CACHE BOOL "disable messages about found libs")
        endif()

        conan_cmake_run(
            CONANFILE ${_conanfile}
            BASIC_SETUP
            BUILD missing
            PROFILE default
            PROFILE_AUTO arch build_type compiler compiler.runtime compiler.libcxx
            NO_OUTPUT_DIRS
            NO_IMPORTS
        )

        _load_conan_paths()
    endif()
endmacro()
