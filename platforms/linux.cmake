# Specific things for Linux

macro(_platform_add_targets_group _targets)
    set(${_targets} -Wl,--start-group ${${_targets}} -Wl,--end-group)
endmacro()
