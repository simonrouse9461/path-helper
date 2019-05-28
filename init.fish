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

  path load -p {$config_home}/env/paths {$config_home}/env/paths.d
  path load -m {$config_home}/env/manpaths {$config_home}/env/manpaths.d

end
