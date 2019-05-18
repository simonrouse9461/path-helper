
# TODO: 
# add paths from file and dirs
# modes
# warning

function fish_path_helper -d "Generate PATH configuration commands"
  argparse --name=(status function)       \
    (fish_opt --short=h --long=help)      \
    (fish_opt --short=l --long=local)     \
    (fish_opt --short=g --long=global)    \
    (fish_opt --short=o --long=override)  \
    (fish_opt --short=v --long=verbose)   \
    (fish_opt --short=s --long=suppress)  \
    (fish_opt --short=f --long=files)     \
  -- $argv

  set -q XDG_CONFIG_HOME
    and set config_home $XDG_CONFIG_HOME
    or set config_home ~/.config

  function __generate_code -V _flag_v -V _flag_s
    for file in "$argv[2]" $argv[2].d/*
      set -q _flag_v
        and echo (set_color green)"generate $argv[1] from $file"(set_color normal) 1>&2
      eval "cat $file" ^ /dev/null | egrep -v '^\s*(#|$)' | while read -l line
        set --path expanded_line (eval "echo $line")
        for path in $expanded_line
          test -d $path
            and echo "set -gxp $argv[1] $path;"
            or set -q _flag_s
            or echo (set_color red)"error"(test $file; and echo " in file $file"; or echo)": $path is not a valid directory!"(set_color normal) 1>&2
        end
      end
    end
  end

  if set -q _flag_o
    set -q _flag_v
      and echo (set_color green)"clear PATH and MANPATH"(set_color normal) 1>&2
    echo "set -gx PATH;"
    echo "set -gx MANPATH;"
  end
  set -q _flag_g
    and __generate_code PATH /etc/paths
    and __generate_code MANPATH /etc/manpaths
  set -q _flag_l
    and __generate_code PATH {$config_home}/paths
    and __generate_code MANPATH {$config_home}/manpaths
  not set -q _flag_g 
    and not set -q _flag_l
    and not set -q _flag_f
    and __generate_code PATH

  functions -e __generate_code
end
