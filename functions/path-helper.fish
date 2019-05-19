function path-helper -d "Generate PATH configuration commands"
  argparse --name=(status function) -x P,M,U    \
    (fish_opt --short=v --long=verbose)         \
    (fish_opt --short=s --long=suppress)        \
    (fish_opt --short=P --long=path)            \
    (fish_opt --short=M --long=man-path)        \
    (fish_opt --short=U --long=fish-user-paths) \
    (fish_opt --short=d --long=dry-run)         \
  -- $argv
  or return 1

  # expand directories to list of files
  for arg in $argv[1..-1]
    if test -d $arg
      set -a files {$arg}/*
    else if test -e $arg
      set -a files $arg
    else
      not set -q _flag_s
        and echo (status function)": $arg is not a valid file or directory!" >& 2
    end
  end

  # this will make cat to read from stdin if no args are given
  not set -q files
    and set files ''

  # determing path variable and set options
  set pathvar PATH
  set opt "-gxp"
  set -q _flag_m
    and set pathvar MANPATH
  set -q _flag_u
    and set pathvar fish_user_paths
    and set opt "-Up"

  for file in $files
    # omit directories
    test -d $file
      and continue
    set -q _flag_v
      and echo (status function)": Generate $pathvar from $file" >& 2

    # omit empty lines and comment lines
    eval cat $file | egrep -v '^\s*(#|$)' | while read -l line
      set --path splited_line $line
      for path in $splited_line
        set expanded_path (eval echo $path)
        if test -d $expanded_path
          set cmd "set $opt $pathvar $expanded_path;"
          set -q _flag_d
            and echo $cmd
            or eval $cmd
        else if not set -q _flag_s;
          set msg (set -q argv[1]; and echo "In file $file, "; or echo)
          echo (status function)": $msg$path is not a valid directory!" >& 2
        end
      end
    end
  end
end
