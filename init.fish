# path-helper initialization hook
#
# You can use the following variables in this file:
# * $package       package name
# * $path          package path
# * $dependencies  package dependencies
if status is-login

  set -l config_home (__path.util.xdg)

  path load -p {$config_home}/env/paths {$config_home}/env/paths.d
  path load -m {$config_home}/env/manpaths {$config_home}/env/manpaths.d

end
