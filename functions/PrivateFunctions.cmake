# Private API of CMake Tools

function(_setup_project_targets_settings)
    if(NOT DEFINED PROJECT_COMPILE_FEATURES)
        set(PROJECT_COMPILE_FEATURES
                ${PROJECT_DEFAULT_COMPILE_FEATURES}
            CACHE STRING "compile features for all targets"
        )
    endif()

    if(NOT DEFINED PROJECT_COMPILE_OPTIONS)
        set(PROJECT_COMPILE_OPTIONS
                ${PROJECT_DEFAULT_COMPILE_OPTIONS}
                ${PROJECT_COMPILE_OPTION_WARNING_AS_ERROR}
            CACHE STRING "compile options for all targets")
    endif()

    if(NOT DEFINED PROJECT_COMPILE_DEFINITIONS)
        set(PROJECT_COMPILE_DEFINITIONS
                ${PROJECT_DEFAULT_COMPILE_DEFINITIONS}
            CACHE STRING "compile definitions for all targets")
    endif()
endfunction()

function(_get_sysprog_targets_settings)
    set(options DISABLE_WARNING_AS_ERROR_MODE)
    set(one_value_args OUTPUT_COMPILE_FEATURES OUTPUT_COMPILE_OPTIONS OUTPUT_COMPILE_DEFINITIONS)
    set(multi_value_args)

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    message(${LOGLEVEL} "_get_sysprog_targets_settings args:"
        " ${ARGUMENTS_DISABLE_WARNING_AS_ERROR_MODE}"
        " ${ARGUMENTS_OUTPUT_COMPILE_FEATURES} ${ARGUMENTS_OUTPUT_COMPILE_OPTIONS}"
        " ${ARGUMENTS_OUTPUT_COMPILE_DEFINITIONS}"
    )
    _check_unparsed_arguments("ARGUMENTS")

    _setup_project_targets_settings()

    set(${ARGUMENTS_OUTPUT_COMPILE_FEATURES} ${PROJECT_COMPILE_FEATURES} PARENT_SCOPE)
    set(${ARGUMENTS_OUTPUT_COMPILE_DEFINITIONS} ${PROJECT_COMPILE_DEFINITIONS} PARENT_SCOPE)

    set(_compile_options ${PROJECT_COMPILE_OPTIONS})

    if(ARGUMENTS_DISABLE_WARNING_AS_ERROR_MODE)
        list(REMOVE_ITEM _compile_options
            ${PROJECT_COMPILE_OPTION_WARNING_AS_ERROR})
    endif()

    set(${ARGUMENTS_OUTPUT_COMPILE_OPTIONS} ${_compile_options} PARENT_SCOPE)
endfunction()

function(_append_target_settings)
    set(options)
    set(one_value_args TARGET_NAME)
    set(multi_value_args
        PUBLIC_COMPILE_FEATURES PRIVATE_COMPILE_FEATURES INTERFACE_COMPILE_FEATURES
        PUBLIC_DEFINITIONS PRIVATE_DEFINITIONS INTERFACE_DEFINITIONS
        PUBLIC_COMPILE_OPTIONS PRIVATE_COMPILE_OPTIONS INTERFACE_COMPILE_OPTIONS

        PROPERTIES

        PUBLIC_LINK_LIBRARIES PRIVATE_LINK_LIBRARIES INTERFACE_LINK_LIBRARIES
        PUBLIC_INCLUDE_DIRECTORIES PRIVATE_INCLUDE_DIRECTORIES INTERFACE_INCLUDE_DIRECTORIES

        SYSTEM_PUBLIC_LINK_LIBRARIES SYSTEM_PRIVATE_LINK_LIBRARIES SYSTEM_INTERFACE_LINK_LIBRARIES
        SYSTEM_PUBLIC_INCLUDE_DIRECTORIES SYSTEM_PRIVATE_INCLUDE_DIRECTORIES SYSTEM_INTERFACE_INCLUDE_DIRECTORIES
    )

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    _check_unparsed_arguments("ARGUMENTS")

    get_target_property(_target_type ${ARGUMENTS_TARGET_NAME} TYPE)

    if(ARGUMENTS_SYSTEM_INTERFACE_LINK_LIBRARIES)
        _get_include_directories(
            TARGETS ${ARGUMENTS_SYSTEM_INTERFACE_LINK_LIBRARIES}
            OUTPUT_INCLUDE_DIRECTORIES SYSTEM_INTERFACE_INCLUDE_DIRECTORIES
        )
    endif()

    if(ARGUMENTS_SYSTEM_PUBLIC_LINK_LIBRARIES)
        _get_include_directories(
            TARGETS ${ARGUMENTS_SYSTEM_PUBLIC_LINK_LIBRARIES}
            OUTPUT_INCLUDE_DIRECTORIES ARGUMENTS_SYSTEM_PUBLIC_INCLUDE_DIRECTORIES
        )
    endif()

    if(ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES)
        _get_include_directories(
            TARGETS ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES}
            OUTPUT_INCLUDE_DIRECTORIES ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES
        )
    endif()

    if(COMMAND _compilers_set_system_include_directories)
        _compilers_set_system_include_directories(
            TARGET_NAME ${ARGUMENTS_TARGET_NAME}
            SYSTEM_INTERFACE_INCLUDE_DIRECTORIES ${ARGUMENTS_SYSTEM_INTERFACE_INCLUDE_DIRECTORIES}
            SYSTEM_PUBLIC_INCLUDE_DIRECTORIES ${ARGUMENTS_SYSTEM_PUBLIC_INCLUDE_DIRECTORIES}
            SYSTEM_PRIVATE_INCLUDE_DIRECTORIES ${ARGUMENTS_SYSTEM_PRIVATE_INCLUDE_DIRECTORIES}
        )
    endif()

    if(${_target_type} STREQUAL "INTERFACE_LIBRARY")
        target_compile_features(${ARGUMENTS_TARGET_NAME}
            INTERFACE ${ARGUMENTS_INTERFACE_COMPILE_FEATURES}
        )

        target_compile_definitions(${ARGUMENTS_TARGET_NAME}
            INTERFACE ${ARGUMENTS_INTERFACE_DEFINITIONS}
        )

        target_compile_options(${ARGUMENTS_TARGET_NAME}
            INTERFACE ${ARGUMENTS_INTERFACE_COMPILE_OPTIONS}
        )

        target_link_libraries(${ARGUMENTS_TARGET_NAME}
            INTERFACE
                ${ARGUMENTS_INTERFACE_LINK_LIBRARIES}
                ${ARGUMENTS_SYSTEM_INTERFACE_LINK_LIBRARIES}
        )

        target_include_directories(${ARGUMENTS_TARGET_NAME}
            INTERFACE
                ${ARGUMENTS_INTERFACE_INCLUDE_DIRECTORIES}
        )
    else()
        target_compile_features(${ARGUMENTS_TARGET_NAME}
            PUBLIC ${ARGUMENTS_PUBLIC_COMPILE_FEATURES}
            PRIVATE ${ARGUMENTS_PRIVATE_COMPILE_FEATURES}
            INTERFACE ${ARGUMENTS_INTERFACE_COMPILE_FEATURES}
        )

        target_compile_definitions(${ARGUMENTS_TARGET_NAME}
            PUBLIC ${ARGUMENTS_PUBLIC_DEFINITIONS}
            PRIVATE ${ARGUMENTS_PRIVATE_DEFINITIONS}
            INTERFACE ${ARGUMENTS_INTERFACE_DEFINITIONS}
        )

        target_compile_options(${ARGUMENTS_TARGET_NAME}
            PUBLIC    ${ARGUMENTS_PUBLIC_COMPILE_OPTIONS}
                      $<$<CONFIG:Release>:--sysprog_do_not_use_release>
            PRIVATE   ${ARGUMENTS_PRIVATE_COMPILE_OPTIONS}
            INTERFACE ${ARGUMENTS_INTERFACE_COMPILE_OPTIONS}
        )

        target_include_directories(${ARGUMENTS_TARGET_NAME}
            PUBLIC ${ARGUMENTS_PUBLIC_INCLUDE_DIRECTORIES}
            PRIVATE ${ARGUMENTS_PRIVATE_INCLUDE_DIRECTORIES}
            INTERFACE ${ARGUMENTS_INTERFACE_INCLUDE_DIRECTORIES}
        )

        target_link_libraries(${ARGUMENTS_TARGET_NAME}
            PUBLIC
                ${ARGUMENTS_PUBLIC_LINK_LIBRARIES}
                ${ARGUMENTS_SYSTEM_PUBLIC_LINK_LIBRARIES}
            PRIVATE
                ${ARGUMENTS_PRIVATE_LINK_LIBRARIES}
                ${ARGUMENTS_SYSTEM_PRIVATE_LINK_LIBRARIES}
            INTERFACE
                ${ARGUMENTS_INTERFACE_LINK_LIBRARIES}
                ${ARGUMENTS_SYSTEM_INTERFACE_LINK_LIBRARIES}
        )

        if(ARGUMENTS_PROPERTIES)
            set_target_properties(${ARGUMENTS_TARGET_NAME}
                PROPERTIES ${ARGUMENTS_PROPERTIES}
            )
        endif()
    endif()
endfunction()

function(_get_include_directories)
    set(options)
    set(one_value_args OUTPUT_INCLUDE_DIRECTORIES)
    set(multi_value_args TARGETS)

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    _check_unparsed_arguments("ARGUMENTS")

    if(ARGUMENTS_OUTPUT_INCLUDE_DIRECTORIES)
        foreach(_target ${ARGUMENTS_TARGETS})
            if(TARGET ${_target})
                get_target_property(_include_directories ${_target} INTERFACE_INCLUDE_DIRECTORIES)
                if(_include_directories)
                    set(${ARGUMENTS_OUTPUT_INCLUDE_DIRECTORIES}
                            ${${ARGUMENTS_OUTPUT_INCLUDE_DIRECTORIES}} ${_include_directories} PARENT_SCOPE)
                endif()
            endif()
        endforeach()
    else()
        message(FATAL_ERROR "OUTPUT_INCLUDE_DIRECTORIES is required arg for _get_include_directories")
    endif()
endfunction()

function(_get_all_targets _result _dir)
    get_property(_sub_directories DIRECTORY "${_dir}" PROPERTY SUBDIRECTORIES)
    foreach(_subdir IN LISTS _sub_directories)
        get_filename_component(_dir_name ${_subdir} NAME)
        if(${_dir_name} STREQUAL "src" OR ${_dir_name} STREQUAL "test")
            _get_all_targets(${_result} "${_subdir}")
        endif()
    endforeach()

    get_directory_property(_sub_targets DIRECTORY "${_dir}" BUILDSYSTEM_TARGETS)
    set(${_result} ${${_result}} ${_sub_targets} PARENT_SCOPE)
endfunction()

function(_get_build_option _result _target_name _default_value)
    set(_build_option "build_${_target_name}")

    string(REPLACE "." "_" _build_option ${_build_option})
    string(TOUPPER ${_build_option} _build_option)

    if(NOT DEFINED ${_build_option})
        option(${_build_option} "Build target" ${_default_value})
    endif()

    set(${_result} ${_build_option} PARENT_SCOPE)
endfunction()

function(_get_gtest_output_arg)
    set(options)
    set(one_value_args OUTPUT_GTEST_ARG)
    set(multi_value_args)

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    _check_unparsed_arguments("ARGUMENTS")

    if(ARGUMENTS_OUTPUT_GTEST_ARG)
        if(NOT TEST_REPORTS_DIR)
            if(CTEST_BINARY_DIRECTORY)
                set(TEST_REPORTS_DIR "${CTEST_BINARY_DIRECTORY}/test_reports"
                    CACHE STRING "Gtest reports location")
            else()
                set(TEST_REPORTS_DIR "${CMAKE_BINARY_DIR}/test_reports"
                    CACHE STRING "Gtest reports location")
            endif()
        endif()

        set(${ARGUMENTS_OUTPUT_GTEST_ARG}
                --gtest_output=xml:${TEST_REPORTS_DIR}/${PROJECT_NAME}.tests.xml PARENT_SCOPE)
    else()
        message(FATAL_ERROR "OUTPUT_GTEST_ARG is required arg for _get_gtest_output_arg")
    endif()
endfunction()

function(_get_proto_files)
    set(options)
    set(one_value_args PROTO_REPO_DIRECTORY OUTPUT_PROTO_FILES OUTPUT_IMPORT_DIRECTORIES)
    set(multi_value_args PROTO_DIRECTORIES_NAMES)

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    message(${LOGLEVEL} "_get_proto_files args:"
        " ${ARGUMENTS_PROTO_REPO_DIRECTORY} ${ARGUMENTS_PROTO_DIRECTORIES_NAMES}"
        " ${ARGUMENTS_OUTPUT_PROTO_FILES} ${ARGUMENTS_OUTPUT_IMPORT_DIRECTORIES}"
    )
    _check_unparsed_arguments("ARGUMENTS")

    if(NOT ARGUMENTS_PROTO_REPO_DIRECTORY)
        set(ARGUMENTS_PROTO_REPO_DIRECTORY ${CMAKE_SOURCE_DIR}/dependency/protocols/proto-repo)
    endif()

    set(_proto_files)

    foreach(_proto_dir ${ARGUMENTS_PROTO_DIRECTORIES_NAMES})
        file(GLOB_RECURSE _current_proto_files "${ARGUMENTS_PROTO_REPO_DIRECTORY}/${_proto_dir}/src/*.proto")

        list(APPEND _proto_files ${_current_proto_files})
        list(APPEND _import_dirs "${ARGUMENTS_PROTO_REPO_DIRECTORY}/${_proto_dir}/src/main/proto")

        message(${LOGLEVEL} "_get_proto_files: in '${_proto_dir}' found next proto files: ${_current_proto_files}")
    endforeach()

    set(${ARGUMENTS_OUTPUT_PROTO_FILES} ${_proto_files} PARENT_SCOPE)
    set(${ARGUMENTS_OUTPUT_IMPORT_DIRECTORIES} ${_import_dirs} PARENT_SCOPE)
endfunction()

function(_generate_from_protos)
    set(options)
    set(one_value_args PROTO_OUT_DIRECTORY
                       OUTPUT_PROTOBUF_GENERATED_SOURCES OUTPUT_GRPC_GENERATED_SOURCES)
    set(multi_value_args IMPORT_DIRECTORIES PROTO_FILES)

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    message(${LOGLEVEL} "_generate_from_protos args:"
        " ${ARGUMENTS_PROTO_OUT_DIRECTORY}"
        " ${ARGUMENTS_OUTPUT_PROTOBUF_GENERATED_SOURCES} ${ARGUMENTS_OUTPUT_GRPC_GENERATED_SOURCES}"
        " ${ARGUMENTS_IMPORT_DIRECTORIES} ${ARGUMENTS_PROTO_FILES}"
    )
    _check_unparsed_arguments("ARGUMENTS")

    if(NOT EXISTS ${ARGUMENTS_PROTO_OUT_DIRECTORY})
        file(MAKE_DIRECTORY ${ARGUMENTS_PROTO_OUT_DIRECTORY})
    endif()

    if(ARGUMENTS_OUTPUT_PROTOBUF_GENERATED_SOURCES)
        protobuf_generate(
            LANGUAGE cpp
            PROTOC_OUT_DIR ${ARGUMENTS_PROTO_OUT_DIRECTORY}
            IMPORT_DIRS ${ARGUMENTS_IMPORT_DIRECTORIES}
            OUT_VAR _protobuf_generated_sources
            PROTOS ${ARGUMENTS_PROTO_FILES}
        )

        set(${ARGUMENTS_OUTPUT_PROTOBUF_GENERATED_SOURCES} ${_protobuf_generated_sources} PARENT_SCOPE)
    endif()

    if(ARGUMENTS_OUTPUT_GRPC_GENERATED_SOURCES)
        if(TARGET gRPC::grpc_cpp_plugin)
            # todo: remove after full migrate to conan
            if(_variables_package_manager_is_vcpkg)
                get_target_property(_grpc_cpp_plugin gRPC::grpc_cpp_plugin IMPORTED_LOCATION_RELEASE)
            else()
                set(_grpc_cpp_plugin $<TARGET_FILE:gRPC::grpc_cpp_plugin>)
            endif()

            message(STATUS "sysprog_generate_from_protos grpc_cpp_plugin: ${_grpc_cpp_plugin}")
        else()
            message(FATAL_ERROR "sysprog_generate_from_protos couldn't find grpc_cpp_plugin")
        endif()

        protobuf_generate(
            LANGUAGE grpc
            PROTOC_OUT_DIR ${ARGUMENTS_PROTO_OUT_DIRECTORY}
            IMPORT_DIRS ${ARGUMENTS_IMPORT_DIRECTORIES}
            PLUGIN "protoc-gen-grpc=${_grpc_cpp_plugin}"
            GENERATE_EXTENSIONS .grpc.pb.h .grpc.pb.cc
            OUT_VAR _grpc_generated_sources
            PROTOS ${ARGUMENTS_PROTO_FILES}
        )

        set(${ARGUMENTS_OUTPUT_GRPC_GENERATED_SOURCES} ${_grpc_generated_sources} PARENT_SCOPE)
    endif()
endfunction()

function(_get_cached_targets _result _dependency)
    if(${ARGC} EQUAL 3)
        set(_dependencies_dir ${ARGV2})
    else()
        set(_dependencies_dir ${CMAKE_SOURCE_DIR}/dependency)
    endif()

    set(_properties_suffix "sysprog_deps_")

    set(_property_name "${_properties_suffix}${_dependency}")
    set(_dependency_targets)

    get_property(_property_is_set GLOBAL PROPERTY ${_property_name} SET)
    if(_property_is_set)
        get_property(_dependency_targets GLOBAL PROPERTY ${_property_name})
    else()
        add_subdirectory(
            ${_dependencies_dir}/${_dependency}
            ${CMAKE_CURRENT_BINARY_DIR}/${_dependency}
        )

        _get_all_targets(_dependency_targets ${_dependencies_dir}/${_dependency})

        message(${LOGLEVEL} "dependency ${_dependency} targets: ${_dependency_targets}")

        set_property(GLOBAL PROPERTY ${_property_name} ${_dependency_targets})
    endif()

    set(${_result} ${_dependency_targets} PARENT_SCOPE)
endfunction()

macro(_check_unparsed_arguments _prefix)
    if(${_prefix}_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR
            "There are unknown arguments in ${CMAKE_CURRENT_FUNCTION}: ${${_prefix}_UNPARSED_ARGUMENTS}"
        )
    endif()
endmacro()

macro(_inject_custom_code)
    set(CMAKE_PROJECT_INCLUDE ${CMAKE_TOOLS_PATH}/injection.cmake)
endmacro()

function(_get_conanfile _result)
    if(EXISTS ${PROJECT_SOURCE_DIR}/conanfile.txt)
        set(${_result} ${PROJECT_SOURCE_DIR}/conanfile.txt PARENT_SCOPE)
    elseif(EXISTS ${PROJECT_SOURCE_DIR}/conanfile.py)
        set(${_result} ${PROJECT_SOURCE_DIR}/conanfile.py PARENT_SCOPE)
    else()
        set(${_result} <none> PARENT_SCOPE)
    endif()
endfunction()

# proto_directories_names is [in/out] variable with list of proto-repo modules
# third_party_libs is [in/out] variable with list of third party libraries
# _proto_repo path to proto-repo repository
# it is supposed by client that they works on the latest versions of grpc and protocols
function(_tweak_proto_dependencies proto_directories_names third_party_libs _proto_repo)
    set(_proto_directories_names ${${proto_directories_names}})
    set(_third_party_libs ${${third_party_libs}})

    list(FIND _proto_directories_names grpc-proto _grpc_proto_index)
    list(FIND _proto_directories_names grpc-proto-common _grpc_proto_common_index)
    list(REMOVE_ITEM _proto_directories_names grpc-proto grpc-proto-common)
    list(REMOVE_ITEM _third_party_libs googleapis::googleapis)

    if ((_grpc_proto_index EQUAL -1) AND (_grpc_proto_common_index EQUAL -1))
        # client isn't interested in proto files
        # so, don't change them anything
        return()
    endif()

    if (gRPC_VERSION VERSION_LESS "1.44")
        if (EXISTS ${_proto_repo}/grpc-proto-common)
            list(PREPEND _proto_directories_names grpc-proto-common)
        endif()
        list(PREPEND _proto_directories_names grpc-proto)
    else()
        if (NOT EXISTS ${_proto_repo}/grpc-proto-common)
            message(FATAL_ERROR "You have to upgrade proto-repo repository")
        endif()
        if (_grpc_proto_index GREATER_EQUAL 0)
            message(FATAL_ERROR "Remove proto-repo from PROTO_DIRECTORIES_NAMES, it is included in grpc now")
        endif()
        find_package(googleapis REQUIRED)
        list(APPEND _third_party_libs googleapis::googleapis)
        list(PREPEND _proto_directories_names grpc-proto-common)
    endif()

    set(${proto_directories_names} ${_proto_directories_names} PARENT_SCOPE)
    set(${third_party_libs} ${_third_party_libs} PARENT_SCOPE)
endfunction()

macro(_load_conan_paths)
    set(_conan_paths ${CMAKE_BINARY_DIR}/conan_paths.cmake)
    if(EXISTS ${_conan_paths})
        include(${_conan_paths})
        message(STATUS "Conan: Loading ${_conan_paths}")
    endif()
endmacro()

macro(_check_target_is_enabled _target_name)
    set(options ENABLE_BY_DEFAULT)
    set(one_value_args)
    set(multi_value_args)

    cmake_parse_arguments(ARGUMENTS "${options}" "${one_value_args}" "${multi_value_args}" ${ARGN})
    _get_build_option(_build_option ${_target_name} ${ARGUMENTS_ENABLE_BY_DEFAULT})

    message(${LOGLEVEL} "${_build_option}: ${${_build_option}}")

    if(NOT ${${_build_option}})
        return()
    endif()
endmacro()

function(_set_default_output_directory _target)
    set(_out_path "${CMAKE_SOURCE_DIR}/bin/$<CONFIG>")

    if(NOT DEFINED CMAKE_RUNTIME_OUTPUT_DIRECTORY AND NOT DEFINED CMAKE_RUNTIME_OUTPUT_DIRECTORY_$<CONFIG>)
        set_target_properties(${_target}
            PROPERTIES
            RUNTIME_OUTPUT_DIRECTORY ${_out_path}
            )
    endif()

    if(NOT DEFINED CMAKE_ARCHIVE_OUTPUT_DIRECTORY AND NOT DEFINED CMAKE_ARCHIVE_OUTPUT_DIRECTORY_$<CONFIG>)
        set_target_properties(${_target}
            PROPERTIES
            ARCHIVE_OUTPUT_DIRECTORY ${_out_path}
            )
    endif()

    if(NOT DEFINED CMAKE_LIBRARY_OUTPUT_DIRECTORY AND NOT DEFINED CMAKE_LIBRARY_OUTPUT_DIRECTORY_$<CONFIG>)
        set_target_properties(${_target}
            PROPERTIES
            LIBRARY_OUTPUT_DIRECTORY ${_out_path}
            )
    endif()
endfunction()

function(_get_version_info_resource_file _result)
    if(COMMAND _platform_process_version_template)
        _platform_process_version_template(_version_info_file)
        set(${_result} ${_version_info_file} PARENT_SCOPE)
    endif()
endfunction()

macro(_add_targets_group _targets)
    if(COMMAND _platform_add_targets_group)
        _platform_add_targets_group(${_targets})
    endif()
endmacro()

function(_run_conan_imports_to_target _target)
    _get_conanfile(_conanfile)
    if(NOT EXISTS ${_conanfile} OR _variables_package_manager_is_vcpkg)
        return()
    endif()

    if(CONAN_COMMAND)
        set(CONAN_CMD ${CONAN_COMMAND})
    else()
        conan_check(REQUIRED)
    endif()

    add_custom_command(
        TARGET ${_target}
        POST_BUILD
        COMMAND
        ${CONAN_CMD} imports -if ${PROJECT_BINARY_DIR} -imf $<TARGET_FILE_DIR:${_target}> ${_conanfile}
    )

    add_custom_command(
        TARGET ${_target}
        POST_BUILD
        COMMAND
        ${CMAKE_COMMAND} -E remove  $<TARGET_FILE_DIR:${_target}>/conan_imports_manifest.txt
    )
endfunction()
