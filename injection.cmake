function(_collect_dependencies_targets)
    if(NOT CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR)
        # we are in some submodule and already parsed all of them at this moment
        return()
    endif()

    set(_dependencies_dir ${CMAKE_CURRENT_SOURCE_DIR}/dependency)
    file(GLOB _dependencies RELATIVE ${_dependencies_dir} ${_dependencies_dir}/* LIST_DIRECTORIES true)

    list(REMOVE_ITEM _dependencies "cmake_tools")

    foreach(_dependency ${_dependencies})
        # will append to cache for the first time
        _get_cached_targets(_targets ${_dependency} ${_dependencies_dir})
    endforeach()
endfunction()

run_conan_install_default()

_collect_dependencies_targets()
