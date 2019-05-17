# path-helper initialization hook
#
# You can use the following variables in this file:
# * $package       package name
# * $path          package path
# * $dependencies  package dependencies
echo plugin-path-helper
if status --is-login
  eval (fish_path_helper)
end
