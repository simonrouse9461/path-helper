# path-helper initialization hook
#
# You can use the following variables in this file:
# * $package       package name
# * $path          package path
# * $dependencies  package dependencies
if status is-login
  eval (fish_path_helper -l)
end
