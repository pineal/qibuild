## Copyright (C) 2011 Aldebaran Robotics

#! qiBuild ogre tools
# ===================
#
# This module contains useful functions helping writing
# code that use ogre libraries


#! Generate suitable configuration files, resources.cfg and plugins.cfg
#  and their install rules.
#
#  This allows you to configure ogre from CMake and plain text files
#  instead of doing it with the C++ Ogre API.
#
#
# \group RESOURCES_PATHS The path to the directory where to find the meshes,
#                        the .material, and so on.
#
# \param RENDER_PLUGIN   The name of the Render plugins, for instance
#                        RenderSystem_GL.
#
# Calling this function will make sure that:
#   - resources.cfg is available next to the executable,
#     and contains correct path to resources
#   - plugins.cfg is build correctly for windows (debug / release),
#     mac, and linux.
#     on windows, a plugins_d.cfg is created, containing path to
#     ${_render_plugin}_d.
#   - those files are installed at the correct place
# \example:ogre
function(configure_ogre)
  # FIXME: install rules
  # FIXME: put configuration files in etc/ rather that in bin/

  cmake_parse_arguments(ARG "" "RENDER_PLUGIN" "RESOURCES_PATHS" ${ARGN})

  # Set CMAKE_FIND_LIBRARY_PREFIXES so that RenderSystem_GL.so is found
  # (there is not libRendeSystem_GL.so)
  set(_backup ${CMAKE_FIND_LIBRARY_PREFIXES})
  set(CMAKE_FIND_LIBRARY_PREFIXES "")
  find_library(_ogre_plugin NAMES ${ARG_RENDER_PLUGIN}
                            PATH_SUFFIXES "OGRE")
  set(CMAKE_FIND_LIBRARY_PREFIXES ${_backup})

  if(NOT _ogre_plugin)
    qi_error("Could not find library for render plugin: '${ARG_RENDER_PLUGIN}'")
  endif()

  get_filename_component(_ogre_plugins_folder ${_ogre_plugin} PATH)

  set(_plugins_cfg "${QI_SDK_DIR}/${QI_SDK_BIN}/plugins.cfg")
  file(WRITE  "${_plugins_cfg}" "# Defines Ogre plugins to load\n")
  file(APPEND "${_plugins_cfg}" "PluginFolder=${_ogre_plugins_folder}\n")
  file(APPEND "${_plugins_cfg}" "Plugin=${ARG_RENDER_PLUGIN}\n")

  if(WIN32)
    set(_plugins_d_cfg "${QI_SDK_DIR}/${QI_SDK_BIN}/plugins_d.cfg")
    file(WRITE  "${_plugins__d_cfg}" "# Defines Ogre plugins to load\n")
    file(APPEND "${_plugins__d_cfg}" "PluginFolder=${_ogre_plugins_folder}\n")
    file(APPEND "${_plugins__d_cfg}" "Plugin=${ARG_RENDER_PLUGIN}_d\n")
  endif()

  set(_resources_cfg "${QI_SDK_DIR}/${QI_SDK_BIN}/resources.cfg")
  file(WRITE  "${_resources_cfg}" "# Defines where to find Ogre resources\n")
  file(APPEND "${_resources_cfg}" "[General]\n")
  foreach(_resource_path ${ARG_RESOURCES_PATHS})
    file(APPEND "${_resources_cfg}" "FileSystem=${_resource_path}\n")
  endforeach()

endfunction()


