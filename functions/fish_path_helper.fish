function fish_path_helper -d "Generate PATH configuration commands"
  set -q XDG_CONFIG_HOME
    and set -l config_home $XDG_CONFIG_HOME
    or set -l config_home ~/.config
  function __generate_code
    for file in $argv[2] $argv[2].d/*
	    for line in (cat $file ^ /dev/null | grep -v '^\s*#')
        set -l expanded_line (eval "echo $line")
        test -d $expanded_line
          and echo "set -gx $argv[1] $expanded_line \$$argv[1];"
          or echo "Error in file $file: $line is not a valid directory!" 1>&2
	    end
    end
  end
  __generate_code PATH {$config_home}/paths
  __generate_code MANPATH {$config_home}/manpaths
  functions -e __generate_code
end
