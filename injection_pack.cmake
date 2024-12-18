include_guard()
cmake_minimum_required(VERSION 3.20)

set(CMAKE_INSTALL_MFC_LIBRARIES TRUE)
set(CMAKE_INSTALL_UCRT_LIBRARIES TRUE)
set(CMAKE_INSTALL_OPENMP_LIBRARIES TRUE)


set(CPACK_PACKAGE_ICON "${CMAKE_CURRENT_SOURCE_DIR}/resource\\\\icon-math-96.bmp")

# .gitignore
list(APPEND CPACK_SOURCE_IGNORE_FILES "/\.git/")
list(APPEND CPACK_SOURCE_IGNORE_FILES "/\.idea/")
list(APPEND CPACK_SOURCE_IGNORE_FILES "/bin/")
list(APPEND CPACK_SOURCE_IGNORE_FILES "/cmake_build/")
list(APPEND CPACK_SOURCE_IGNORE_FILES "/CMakeUserPresets.json/")

if (WIN32)
    set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/bin/${CMAKE_GENERATOR_PLATFORM})
    set(CPACK_SOURCE_GENERATOR "NSIS;ZIP")
    set(CPACK_NSIS_DISPLAY_NAME "${CMAKE_PROJECT_NAME} ${CPACK_PACKAGE_VERSION}")
    set(CPACK_NSIS_MUI_ICON "${CMAKE_CURRENT_SOURCE_DIR}/resource/icon-math-96.ico")
    set(CPACK_NSIS_MUI_UNIICON "${CMAKE_CURRENT_SOURCE_DIR}/resource/icon-math-96.ico")
    set(CPACK_NSIS_INSTALLED_ICON_NAME "${CMAKE_CURRENT_SOURCE_DIR}/resource/icon-math-96.ico")
else()
    set(CMAKE_INSTALL_PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/bin/unix)
    set(CPACK_SOURCE_GENERATOR "DEB;RPM;TGZ;TXZ")
endif()

include(InstallRequiredSystemLibraries)

install(
    TARGETS ${CMAKE_PROJECT_NAME}.console
    CONFIGURATIONS Release
    RUNTIME DESTINATION bin
    COMPONENT ${CMAKE_PROJECT_NAME}.console)
if(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS)
    install(
        PROGRAMS ${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS}
        DESTINATION bin COMPONENT runtime_libraries)
endif(CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS)
install(
    DIRECTORY docs/
    DESTINATION documentation COMPONENT documentation)

set(CPACK_PACKAGE_NAME "${CMAKE_PROJECT_NAME}")
set(CPACK_PACKAGE_VENDOR "${VENDOR}")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${VENDOR} ${CMAKE_PROJECT_NAME} ${CPACK_PACKAGE_VERSION}")
set(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/docs/Copyright.txt")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/docs/Copyright.txt")

if (VENDOR)
    set(CPACK_PACKAGE_INSTALL_DIRECTORY "${VENDOR}\\\\${CMAKE_PROJECT_NAME}")
else()
    set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CMAKE_PROJECT_NAME}")
endif(VENDOR)

set(CPACK_NSIS_MODIFY_PATH ON)
set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)
set(CPACK_COMPONENTS_ALL ${CMAKE_PROJECT_NAME}.console runtime_libraries documentation)

set(CPACK_INSTALL_CMAKE_PROJECTS "${CMAKE_CURRENT_BINARY_DIR};${CMAKE_PROJECT_NAME};ALL;/")
if (WIN32)
    set(CPACK_PACKAGE_EXECUTABLES
        "bin/${CMAKE_GENERATOR_PLATFORM}/Release/${CMAKE_PROJECT_NAME}.console"
        "${CMAKE_PROJECT_NAME}.console")
else()
    set(CPACK_PACKAGE_EXECUTABLES
        "bin/unix/${CMAKE_PROJECT_NAME}.console"
        "${CMAKE_PROJECT_NAME}.console")
endif()
SET(CPACK_OUTPUT_FILE_PREFIX ../)

include(CPack)

cpack_add_component_group(${CMAKE_PROJECT_NAME} EXPANDED
    DESCRIPTION "${CMAKE_PROJECT_NAME} application representations and modules")

# Каждый executable target
cpack_add_component(
    ${CMAKE_PROJECT_NAME}.console
    DISPLAY_NAME "Console"
    DESCRIPTION "Console view of ${CMAKE_PROJECT_NAME} application."
    GROUP ${CMAKE_PROJECT_NAME})

cpack_add_component(
    documentation
    DISPLAY_NAME "Documentation"
    DESCRIPTION "Documentation for ${CMAKE_PROJECT_NAME} application."
    GROUP ${CMAKE_PROJECT_NAME}
    DEPENDS "${CMAKE_PROJECT_NAME}.console;")

cpack_add_component(
    runtime_libraries
    DISPLAY_NAME "Runtime Libraries"
    DESCRIPTION
    "Runtime libraries for ${CMAKE_PROJECT_NAME} run on your OS. "
    "Uncheck this if you already installed this libs."
    DEPENDS "${CMAKE_PROJECT_NAME}.console;")
