function __path.util.xdg
  set -q XDG_CONFIG_HOME
    and echo $XDG_CONFIG_HOME
    or echo ~/.config
end
