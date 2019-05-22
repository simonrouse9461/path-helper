function path-bind -d "Automatically prepend a path variable to $PATH"
  set -q argv[1]
    or return
  set pathvar $argv[1]

  eval "
  function __reconstruct_path_from_$pathvar -d \"Update \\\$PATH when \\\$$pathvar changes\" --on-variable $pathvar
    set -l local_path \$PATH

    for x in \$__"$pathvar"_added_paths
      set -l idx (contains --index -- \$x \$local_path)
      and set -e local_path[\$idx]
    end

    set -g __"$pathvar"_added_paths
    if set -q $pathvar
      set --path path \$$pathvar
      for x in \$path[-1..1]
        if set -l idx (contains --index -- \$x \$local_path)
          set -e local_path[\$idx]
        else
          set -ga __"$pathvar"_added_paths \$x
        end
        set -p local_path \$x
      end
    end

    set -xg PATH \$local_path
  end
  "
  __reconstruct_path_from_$pathvar
end
