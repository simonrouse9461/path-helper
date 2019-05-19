# path-helper initialization hook
#
# You can use the following variables in this file:
# * $package       package name
# * $path          package path
# * $dependencies  package dependencies
if status is-login

  set -q XDG_CONFIG_HOME
    and set config_home $XDG_CONFIG_HOME
    or set config_home ~/.config

  path-helper -P {$config_home}/paths {$config_home}/paths.d
  path-helper -M {$config_home}/manpaths {$config_home}/manpaths.d

end
