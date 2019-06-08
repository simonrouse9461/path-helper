function __path.cli.bind -d "Automatically prepend a path variable to $PATH or $MANPATH"
  argparse --name=(status function) -x p,m      \
    (fish_opt --short=p --long=PATH)            \
    (fish_opt --short=m --long=MANPATH)         \
    (fish_opt --short=v --long=verbose)         \
    (fish_opt --short=s --long=suppress)        \
  -- $argv
  or return 1

  set -q argv[1]
    or return 0
  set pathvar $argv[1]

  set -q _flag_m
    and set PATHvar MANPATH
    or set PATHvar PATH

  set -l added_paths_var {$pathvar}_added_{$PATHvar}

  eval "
  function __path_reconstruct_"$PATHvar"_from_$pathvar -d \"Update \\\$$PATHvar when \\\$$pathvar changes\" --on-variable $pathvar
    set -g local_path \$$PATHvar 
    __path.util.remove local_path \$$added_paths_var
    set -g $added_paths_var
    if set -q $pathvar
      set --path path \$$pathvar
      for x in \$path[-1..1]
        __path.util.remove local_path \$x
          or set -ga $added_paths_var \$x
        set -p local_path \$x
      end
    end
    set -xg $PATHvar \$local_path
    set -e local_path
  end
  "
  __path_reconstruct_{$PATHvar}_from_{$pathvar}
end
