# Specific things for Windows

function(_platform_process_version_template _result)
    set(_version_info_file ${CMAKE_CURRENT_BINARY_DIR}/version.rc)

    if (NOT PROJECT_COPYRIGHT)
        set(PROJECT_COPYRIGHT "Ravin Arseny (C)")
    endif()

    if(NOT EXISTS ${_version_info_file})
        string(TIMESTAMP CURRENT_YEAR "%Y")
        configure_file(
            ${CMAKE_VERSION_TEMPLATE_PATH}
            ${_version_info_file}
            @ONLY
        )
    endif()

    set(${_result} ${_version_info_file} PARENT_SCOPE)
endfunction()
