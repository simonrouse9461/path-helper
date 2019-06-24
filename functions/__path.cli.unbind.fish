function __path.cli.unbind -d "Stop prepending a path variable to $PATH or $MANPATH"  
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

  set -g local_path $$PATHvar
  set -l added_paths_var {$pathvar}_added_{$PATHvar}
  __path.util.remove local_path $$added_paths_var
  set -xg $PATHvar $local_path
  set -e $added_paths_var
  set -e local_path
  functions -e __path_reconstruct_{$PATHvar}_from_{$pathvar} 
end
