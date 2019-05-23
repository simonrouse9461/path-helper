function path-bind -d "Automatically prepend a path variable to $PATH or $MANPATH"
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

  eval "
  function __reconstruct_"$PATHvar"_from_$pathvar -d \"Update \\\$$PATHvar when \\\$$pathvar changes\" --on-variable $pathvar
    set -l local_path \$$PATHvar
    set -l added_paths_var "$pathvar"_added_$PATHvar

    for x in \$\$added_paths_var
      set -l idx (contains --index -- \$x \$local_path)
      and set -e local_path[\$idx]
    end

    set -g \$added_paths_var
    if set -q $pathvar
      set --path path \$$pathvar
      for x in \$path[-1..1]
        if set -l idx (contains --index -- \$x \$local_path)
          set -e local_path[\$idx]
        else
          set -ga \$added_paths_var \$x
        end
        set -p local_path \$x
      end
    end

    set -xg $PATHvar \$local_path
  end
  "
  __reconstruct_{$PATHvar}_from_{$pathvar}
end
