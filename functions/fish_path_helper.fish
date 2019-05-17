function fish_path_helper -d "Generate PATH configuration commands"
  argparse --name=(status function)       \
    (fish_opt --short=l --long=local)     \
    (fish_opt --short=g --long=global)    \
    (fish_opt --short=o --long=override)  \
    (fish_opt --short=v --long=verbose)   \
  -- $argv

  set -q XDG_CONFIG_HOME
    and set config_home $XDG_CONFIG_HOME
    or set config_home ~/.config

  function __generate_code
    for file in $argv[2] $argv[2].d/*
      test -n "$argv[3]"
        and echo (set_color green)">>> generate $argv[1] from $file <<<"(set_color normal) 1>&2
	    for line in (cat $file ^ /dev/null | grep -v '^\s*#')
        set expanded_line (eval "echo $line")
        test -d $expanded_line
          and echo "set -gxp $argv[1] $expanded_line;"
          or echo "Error in file $file: $line is not a valid directory!" 1>&2
	    end
    end
  end

  if set -q _flag_o
    set -q _flag_v
      and echo (set_color green)">>> clear PATH and MANPATH <<<"(set_color normal) 1>&2
    echo "set -gx PATH;"
    echo "set -gx MANPATH;"
  end
  set -q _flag_g
    and __generate_code PATH /etc/paths $_flag_v
    and __generate_code MANPATH /etc/manpaths $_flag_v
  set -q _flag_l
    and __generate_code PATH {$config_home}/paths $_flag_v
    and __generate_code MANPATH {$config_home}/manpaths $_flag_v
  
  functions -e __generate_code
end
