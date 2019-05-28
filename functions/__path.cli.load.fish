function __path.cli.load -d "Load paths from files and prepend to PATH"
  argparse --name=(status function) -x p,m      \
    (fish_opt --short=p --long=PATH)            \
    (fish_opt --short=m --long=MANPATH)         \
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
  not set -q argv[1]
    and set files ''

  if set -q _flag_m
    set PATHvar MANPATH
    set PATHflag -m
  else 
    set PATHvar PATH
    set PATHflag -p
  end

  for file in $files
    # omit directories
    test -d $file
      and continue
    set -q _flag_v
      and echo (status function)": Generate $PATHvar from $file" >& 2

    if test $file
      set -l filevar __path_file_(realpath $file | md5)
      set -gxa __path_files $filevar
      set -gx $filevar (realpath $file)
      set pathvar {$filevar}_{$PATHvar}
    else
      set pathvar __path_user_{$PATHvar}
    end

    path bind $PATHflag $pathvar

    # omit empty lines and comment lines
    eval cat $file | egrep -v '^\s*(#|$)' | while read -l line
      # split line by colons
      set --path splited $line
      # expand tildes and wildcards
      eval set expanded (eval echo $splited[-1..1])
      for path in $expanded
        # check for valid directory
        if test -d $path
          set -l idx (contains --index -- $path $$pathvar)
            and set -e {$pathvar}[$idx]
          set -gxp $pathvar $path
          set -q _flag_v
            and echo (status function)": Add $path to $PATHvar" >& 2
        else if not set -q _flag_s;
          set msg (set -q argv[1]; and echo "In file $file, "; or echo)
          echo (status function)": $msg$path is not a valid directory!" >& 2
        end
      end
    end
  end

  return 0
end
