function path-load -d "Load paths from files and prepend to PATH"
  argparse --name=(status function) -x p,m      \
    (fish_opt --short=p --long=PATH)            \
    (fish_opt --short=m --long=MANPATH)         \
    (fish_opt --short=d --long=dry-run)         \
    (fish_opt --short=v --long=verbose)         \
    (fish_opt --short=s --long=suppress)        \
  -- $argv
  or return 1

  # expand directories to list of files
  for arg in $argv
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
  set -q _flag_M
    and set pathvar MANPATH

  for file in $files
    # omit directories
    test -d $file
      and continue
    set -q _flag_v
      and echo (status function)": Generate $pathvar from $file" >& 2

    # omit empty lines and comment lines
    eval cat $file | egrep -v '^\s*(#|$)' | while read -l line
      set --path splited_line $line
      for path in $splited_line[-1..1]
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
