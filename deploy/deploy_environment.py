
ROOT_DIRECTORY = "G:/development/"

# Possible options are ['shared', 'opengl', 'with_vulkan', 'openssl', 'with_pcre2', 'with_glib', 
# 'with_doubleconversion', 'with_freetype', 'with_harfbuzz', 'with_libjpeg', 'with_libpng', 'with_sqlite3', 
# 'with_mysql', 'with_pq', 'with_odbc', 'with_zstd', 'with_brotli', 'with_dbus', 'with_openal', 'with_gstreamer', 
# 'with_pulseaudio', 'with_md4c', 'gui', 'widgets', 'device', 'cross_compile', 'sysroot', 'multiconfiguration', 
# 'disabled_features', 'qtsvg', 'qtdeclarative', 'qttools', 'qttranslations', 'qtdoc', 'qtwayland', 'qtquicktimeline', 
# 'qtquick3d', 'qtshadertools', 'qt5compat', 'qtactiveqt', 'qtcharts', 'qtdatavis3d', 'qtlottie', 'qtscxml', 
# 'qtvirtualkeyboard', 'qt3d', 'qtimageformats', 'qtnetworkauth', 'qtcoap', 'qtmqtt', 'qtopcua', 'qtmultimedia', 
# 'qtlocation', 'qtsensors', 'qtconnectivity', 'qtserialbus', 'qtserialport', 'qtwebsockets', 'qtwebchannel', 
# 'qtwebengine', 'qtwebview', 'qtremoteobjects', 'qtpositioning', 'qtlanguageserver', 'qtspeech', 'qthttpserver', 
# 'qtquick3dphysics', 'qtgrpc', 'qtquickeffectmaker', 'qtgraphs', 
# 'essential_modules', 'addon_modules', 'deprecated_modules', 'preview_modules']

def download_repository(git_url: str, path_to: str):
    print(f"Load repo '{git_url}' to '{path_to}'...")

def load_structure(root: str):
    # download_repository("", root + "api/")
    download_repository("", root + "applications/mindmath")
    download_repository("", root + "applications/wcf")
    download_repository("", root + "conan/")
    #download_repository("", root + "examples/")

    download_repository("", root + "opensource/Hazel")
    download_repository("", root + "opensource/npcap")
    download_repository("", root + "opensource/ollama-hpp")
    download_repository("", root + "opensource/openssl")
    download_repository("", root + "opensource/qt")
    download_repository("", root + "opensource/td")
    download_repository("", root + "opensource/viking")

    download_repository("", root + "projects/banner_born")
    download_repository("", root + "projects/bird_chirp")
    download_repository("", root + "projects/eagle")
    download_repository("", root + "projects/fuac")
    download_repository("", root + "projects/gazeta")
    download_repository("", root + "projects/stockbot")

    download_repository("", root + "tools/badger")
    download_repository("", root + "tools/build_tools")
    download_repository("", root + "tools/hare")
    download_repository("", root + "tools/net802")
    download_repository("", root + "tools/py_scripts")
    download_repository("", root + "tools/server-scripts")

    download_repository("", root + "trash/")
    download_repository("", root + "web/")

if __name__ == "__main__":
    load_structure(ROOT_DIRECTORY)
